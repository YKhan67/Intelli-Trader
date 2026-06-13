import asyncio
import os
import httpx
import pandas as pd
import lzma
import struct
from datetime import datetime, timedelta, timezone
from typing import List, Dict, Any
from sqlalchemy import select, insert, and_
from backend.database.postgres import AsyncSessionLocal
from backend.database.models_db import CurrencyPairDB, OHLCVBarDB, DataDownloadLogDB

class PriceDownloader:
    def __init__(self, config: Dict[str, Any]):
        self.config = config
        self.pairs = config["pairs"]
        self.local_path = config.get("local_data_path", "backend/data/raw/prices")
        self.base_url = "https://datafeed.dukascopy.com/datafeed"

    async def get_pair_id(self, session, symbol: str) -> int:
        stmt = select(CurrencyPairDB.id).where(CurrencyPairDB.symbol == symbol)
        result = await session.execute(stmt)
        return result.scalar()

    async def download_historical(self):
        """Production historical download: uses Dukascopy then Local Files."""
        os.makedirs(self.local_path, exist_ok=True)
        
        async with AsyncSessionLocal() as session:
            for symbol in self.pairs:
                pair_id = await self.get_pair_id(session, symbol)
                if not pair_id: continue

                print(f"Ingesting {symbol}...")
                
                # 1. Try Dukascopy
                df = await self._fetch_from_dukascopy(symbol)
                
                # 2. Try Local CSV if Dukascopy failed
                if df is None:
                    local_file = os.path.join(self.local_path, f"{symbol}.csv")
                    if os.path.exists(local_file):
                        print(f"  Dukascopy failed. Using local file: {local_file}")
                        df = pd.read_csv(local_file)
                
                if df is not None:
                    await self.process_and_store(session, pair_id, symbol, df, "LIVE_DATA")
                else:
                    print(f"  CRITICAL ERROR: No real data found for {symbol}. Check connection or local folder.")

    async def _fetch_from_dukascopy(self, symbol: str) -> pd.DataFrame:
        now = datetime.now(timezone.utc)
        all_data = []
        api_symbol = symbol.replace("_", "").upper()
        days_back = self.config.get("days_history", 1)
        
        headers = {
            "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
        }

        async with httpx.AsyncClient(timeout=15.0, headers=headers, follow_redirects=True) as client:
            for day_offset in range(days_back):
                target_day = now - timedelta(days=day_offset)
                tasks = []
                for hour in range(24):
                    url = f"{self.base_url}/{api_symbol}/{target_day.year}/{target_day.month-1:02d}/{target_day.day:02d}/{hour:02d}h_ticks.bi5"
                    tasks.append(self._download_single_hour(client, url, target_day.replace(hour=hour)))
                
                results = await asyncio.gather(*tasks)
                for res in results:
                    if res: all_data.extend(res)

        if all_data:
            return pd.DataFrame(all_data)
        return None

    async def _download_single_hour(self, client, url, base_ts):
        try:
            resp = await client.get(url)
            if resp.status_code == 200:
                return self._parse_bi5(resp.content, base_ts)
        except:
            return None

    def _parse_bi5(self, content: bytes, base_ts: datetime) -> List[Dict]:
        try:
            decompressed = lzma.decompress(content)
            ticks = []
            for i in range(0, len(decompressed), 20):
                ms_offset, ask, bid, ask_vol, bid_vol = struct.unpack(">IIIII", decompressed[i:i+20])
                ts = base_ts.replace(minute=0, second=0, microsecond=0) + timedelta(milliseconds=ms_offset)
                ticks.append({
                    'timestamp': ts, 'open': bid / 100000.0, 'high': bid / 100000.0,
                    'low': bid / 100000.0, 'close': bid / 100000.0, 'volume': bid_vol
                })
            return ticks
        except:
            return []

    async def process_and_store(self, session, pair_id: int, symbol: str, df: pd.DataFrame, source: str):
        df.columns = [c.lower() for c in df.columns]
        if 'time' in df.columns: df.rename(columns={'time': 'timestamp'}, inplace=True)
        df['timestamp'] = pd.to_datetime(df['timestamp'])
        df.set_index('timestamp', inplace=True)
        
        # Resample to M1 if it's raw tick data
        if len(df) > 10000: # Heuristic for tick data
            df = df.resample('1min').agg({'open': 'first', 'high': 'max', 'low': 'min', 'close': 'last', 'volume': 'sum'}).dropna()

        timeframes = self.config.get("timeframes", ["M1", "M5", "M15", "M30", "H1", "H4"])
        resample_map = {"M1": "1min", "M5": "5min", "M15": "15min", "M30": "30min", "H1": "1h", "H4": "4h"}

        for tf in timeframes:
            resampled = df.resample(resample_map[tf]).agg({'open': 'first', 'high': 'max', 'low': 'min', 'close': 'last', 'volume': 'sum'}).dropna()
            bars = []
            for ts, row in resampled.iterrows():
                bars.append({
                    "pair_id": pair_id, "timeframe": tf, "timestamp": ts.to_pydatetime().replace(tzinfo=timezone.utc),
                    "open": row['open'], "high": row['high'], "low": row['low'], "close": row['close'],
                    "volume": row['volume'], "spread_pips": 0.0
                })

            if bars:
                try:
                    await session.execute(insert(OHLCVBarDB), bars)
                    await session.commit()
                except:
                    await session.rollback()

        log = DataDownloadLogDB(
            pair_id=pair_id, timeframe="ALL", start_time=df.index[0].to_pydatetime().replace(tzinfo=timezone.utc),
            end_time=df.index[-1].to_pydatetime().replace(tzinfo=timezone.utc), status="SUCCESS", bars_count=len(df)
        )
        session.add(log)
        await session.commit()
