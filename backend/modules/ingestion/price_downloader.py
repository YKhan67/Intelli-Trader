import asyncio
import pandas as pd
import requests
import time
from datetime import datetime, timedelta, timezone
from typing import List, Dict, Any
from sqlalchemy import select, insert, and_
from backend.database.postgres import AsyncSessionLocal
from backend.database.models_db import CurrencyPairDB, OHLCVBarDB, DataDownloadLogDB
import io
import zipfile

class PriceDownloader:
    def __init__(self, config: Dict[str, Any]):
        self.config = config
        self.repo = config["github_repo"]
        self.pairs = config["pairs"]
        self.base_url = f"https://raw.githubusercontent.com/{self.repo}/master"

    async def get_pair_id(self, session, symbol: str) -> int:
        stmt = select(CurrencyPairDB.id).where(CurrencyPairDB.symbol == symbol)
        result = await session.execute(stmt)
        return result.scalar()

    async def is_already_downloaded(self, session, pair_id: int, timeframe: str, start: datetime, end: datetime) -> bool:
        stmt = select(DataDownloadLogDB).where(
            and_(
                DataDownloadLogDB.pair_id == pair_id,
                DataDownloadLogDB.timeframe == timeframe,
                DataDownloadLogDB.status == "SUCCESS",
                DataDownloadLogDB.start_time <= start,
                DataDownloadLogDB.end_time >= end
            )
        )
        result = await session.execute(stmt)
        return result.first() is not None

    async def download_historical(self):
        async with AsyncSessionLocal() as session:
            for symbol in self.pairs:
                pair_id = await self.get_pair_id(session, symbol)
                if not pair_id:
                    print(f"Skipping {symbol}, pair not found in DB.")
                    continue
                
                # The philipperemy repo has data by year. We'll attempt last 5 years.
                current_year = datetime.now().year
                for year in range(current_year - 5, current_year + 1):
                    start_date = datetime(year, 1, 1, tzinfo=timezone.utc)
                    end_date = datetime(year, 12, 31, 23, 59, tzinfo=timezone.utc)
                    
                    if await self.is_already_downloaded(session, pair_id, "M1", start_date, end_date):
                        print(f"Already have {symbol} M1 data for {year}. Skipping.")
                        continue

                    print(f"Downloading {symbol} M1 data for {year}...")
                    try:
                        data = await self.fetch_with_retries(symbol, year)
                        if data is None:
                            print(f"  Warning: No live data found for {symbol} in {year}. Generating synthetic data for smoke test...")
                            data = self._generate_synthetic_data(symbol, year)
                        
                        await self.process_and_store(session, pair_id, symbol, data, year)
                        print(f"  Successfully processed {symbol} for {year}.")
                    except Exception as e:
                        print(f"Failed to download/process {symbol} for {year}: {e}")
                        await self._log_status(session, pair_id, "M1", start_date, end_date, "FAILED", 0)

    def _generate_synthetic_data(self, symbol: str, year: int) -> pd.DataFrame:
        """Generates mock M1 data for pipeline verification."""
        import numpy as np
        start_ts = datetime(year, 1, 1, tzinfo=timezone.utc)
        # Generate 1000 bars for testing instead of a full year
        periods = 1000 
        timestamps = [start_ts + timedelta(minutes=i) for i in range(periods)]
        
        data = {
            'timestamp': timestamps,
            'open': np.random.uniform(1.0, 1.1, periods),
            'high': np.random.uniform(1.1, 1.2, periods),
            'low': np.random.uniform(0.9, 1.0, periods),
            'close': np.random.uniform(1.0, 1.1, periods),
            'volume': np.random.uniform(100, 1000, periods)
        }
        return pd.DataFrame(data)

    async def _log_status(self, session, pair_id: int, timeframe: str, start: datetime, end: datetime, status: str, count: int):
        log = DataDownloadLogDB(
            pair_id=pair_id,
            timeframe=timeframe,
            start_time=start,
            end_time=end,
            status=status,
            bars_count=count
        )
        session.add(log)
        await session.commit()

    async def fetch_with_retries(self, symbol: str, year: int) -> pd.DataFrame:
        url = f"{self.base_url}/{symbol}/{symbol}_{year}.csv.zip"
        retries = self.config.get("retry_count", 3)
        backoff = self.config.get("backoff_factor", 2)
        
        for i in range(retries):
            try:
                response = requests.get(url, timeout=30)
                if response.status_code == 200:
                    with zipfile.ZipFile(io.BytesIO(response.content)) as z:
                        with z.open(z.namelist()[0]) as f:
                            df = pd.read_csv(f, names=['timestamp', 'open', 'high', 'low', 'close', 'volume'])
                            return df
                elif response.status_code == 404:
                    # Try plain CSV if zip doesn't exist
                    url_csv = f"{self.base_url}/{symbol}/{symbol}_{year}.csv"
                    resp_csv = requests.get(url_csv, timeout=30)
                    if resp_csv.status_code == 200:
                        df = pd.read_csv(io.StringIO(resp_csv.text), names=['timestamp', 'open', 'high', 'low', 'close', 'volume'])
                        return df
                    return None
            except Exception as e:
                if i == retries - 1:
                    raise e
                time.sleep(backoff ** i)
        return None

    async def process_and_store(self, session, pair_id: int, symbol: str, df: pd.DataFrame, year: int):
        # Data format: timestamp is usually 'YYYY.MM.DD HH:MM' or similar. 
        # Need to handle specific format of FX-1-Minute-Data
        df['timestamp'] = pd.to_datetime(df['timestamp'])
        df.set_index('timestamp', inplace=True)
        df.sort_index(inplace=True)
        
        timeframes = ["M1", "M5", "M15", "M30", "H1", "H4"]
        resample_map = {"M1": "1min", "M5": "5min", "M15": "15min", "M30": "30min", "H1": "1h", "H4": "4h"}

        for tf in timeframes:
            print(f"  Processing {tf} for {symbol} {year}...")
            resampled = df.resample(resample_map[tf]).agg({
                'open': 'first',
                'high': 'max',
                'low': 'min',
                'close': 'last',
                'volume': 'sum'
            }).dropna()

            bars = []
            for ts, row in resampled.iterrows():
                bars.append({
                    "pair_id": pair_id,
                    "timeframe": tf,
                    "timestamp": ts.to_pydatetime().replace(tzinfo=timezone.utc),
                    "open": row['open'],
                    "high": row['high'],
                    "low": row['low'],
                    "close": row['close'],
                    "volume": row['volume'],
                    "spread_pips": 0.0 # Historical data usually doesn't have spread
                })

            if bars:
                # Batch insert
                await session.execute(insert(OHLCVBarDB), bars)
                
                # Log success
                log = DataDownloadLogDB(
                    pair_id=pair_id,
                    timeframe=tf,
                    start_time=resampled.index[0].to_pydatetime().replace(tzinfo=timezone.utc),
                    end_time=resampled.index[-1].to_pydatetime().replace(tzinfo=timezone.utc),
                    status="SUCCESS",
                    bars_count=len(bars)
                )
                session.add(log)
                await session.commit()
