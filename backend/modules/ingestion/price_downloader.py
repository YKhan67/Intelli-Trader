import asyncio
import os
import subprocess
import pandas as pd
import logging
import zipfile
import re
import shutil
from datetime import datetime, timedelta, timezone
from typing import List, Dict, Any, Optional
from sqlalchemy import select, and_, func, create_engine, delete
from sqlalchemy.dialects.postgresql import insert as pg_insert
from backend.database.postgres import AsyncSessionLocal, DATABASE_URL
from backend.database.models_db import CurrencyPairDB, OHLCVBarDB

logger = logging.getLogger("PriceDownloader")

class PriceDownloader:
    def __init__(self, config: Dict[str, Any]):
        self.config = config
        self.pairs = config["pairs"]
        self.zip_base_path = config.get("historical_zip_path", "D:/prj/ForexDataDL/downloads")
        self.temp_dir = "backend/data/temp"
        os.makedirs(self.temp_dir, exist_ok=True)
        sync_url = DATABASE_URL.replace("postgresql+asyncpg", "postgresql")
        self.sync_engine = create_engine(sync_url)

    def _is_weekend(self, ts):
        wd = ts.weekday()
        hr = ts.hour
        if wd == 5: return True
        if wd == 4 and hr >= 22: return True
        if wd == 6 and hr < 22: return True
        return False

    async def download_historical(self, target_symbol: Optional[str] = None):
        """Waterfall Sync: Optimized for single pair or full market."""
        days_back = self.config.get("days_history", 30)
        now = datetime.now(timezone.utc)
        default_start = now - timedelta(days=days_back)

        sync_list = [target_symbol] if target_symbol else self.pairs
        
        async with AsyncSessionLocal() as session:
            pair_map = {}
            for s in sync_list:
                res = await session.execute(select(CurrencyPairDB.id).where(CurrencyPairDB.symbol == s))
                pid = res.scalar()
                if pid: pair_map[s] = pid

            for symbol, pair_id in pair_map.items():
                print(f"\n>>> Analyzing {symbol}...")
                
                # Check DB coverage for requested range
                stmt = select(func.count(OHLCVBarDB.id)).where(
                    and_(OHLCVBarDB.pair_id == pair_id, 
                         OHLCVBarDB.timeframe == "M1",
                         OHLCVBarDB.timestamp >= default_start)
                )
                count = (await session.execute(stmt)).scalar() or 0
                
                if count >= (days_back * 1000):
                    print(f"    [SKIP] DB history complete ({count} bars).")
                else:
                    if symbol != "BTCUSD":
                        await self._import_zips_surgical(symbol, pair_id, default_start.year, now.year)

                    stmt_max = select(func.max(OHLCVBarDB.timestamp)).where(
                        and_(OHLCVBarDB.pair_id == pair_id, OHLCVBarDB.timeframe == "M1")
                    )
                    last_ts = (await session.execute(stmt_max)).scalar()
                    from_date = last_ts if last_ts else default_start
                    
                    if (now - from_date).total_seconds() > 3600:
                        await self._download_via_node_turbo(symbol, pair_id, from_date.strftime("%Y-%m-%d"))

                # CRITICAL: Always ensure resampling is triggered to generate HTF bars for AI
                print(f"    [INFO] Ensuring H1/H4 timeframes are populated for {symbol}...")
                await self.resample_timeframes(pair_id)

    async def resample_timeframes(self, pair_id: int):
        """Builds M15, M30, H1, H4 bars from M1 data. Crucial for AI Signal Generation."""
        async with AsyncSessionLocal() as session:
            # 1. Fetch M1 bars
            stmt = select(OHLCVBarDB).where(
                and_(OHLCVBarDB.pair_id == pair_id, OHLCVBarDB.timeframe == "M1")
            ).order_by(OHLCVBarDB.timestamp.asc())
            res = await session.execute(stmt)
            m1_bars = res.scalars().all()
            
            if not m1_bars: return

            df = pd.DataFrame([{
                'timestamp': b.timestamp, 'open': b.open, 'high': b.high, 
                'low': b.low, 'close': b.close, 'volume': b.volume
            } for b in m1_bars])
            df.set_index('timestamp', inplace=True)

            for tf in ["M15", "M30", "H1", "H4"]:
                # Correct Pandas frequency mapping for recent versions (using 'min' and 'h')
                tf_map = {"M15": "15min", "M30": "30min", "H1": "1h", "H4": "4h"}
                freq = tf_map.get(tf, "1h")
                
                resampled = df.resample(freq).agg({
                    'open': 'first', 'high': 'max', 'low': 'min', 'close': 'last', 'volume': 'sum'
                }).dropna()

                new_bars = []
                for ts, row in resampled.iterrows():
                    new_bars.append({
                        "pair_id": pair_id, "timeframe": tf, 
                        "timestamp": ts.to_pydatetime().replace(tzinfo=timezone.utc),
                        "open": float(row['open']), "high": float(row['high']),
                        "low": float(row['low']), "close": float(row['close']),
                        "volume": float(row['volume']), "spread_pips": 0.0
                    })
                
                if new_bars:
                    # Clean existing HTF bars to prevent duplicates/gaps
                    await session.execute(
                        delete(OHLCVBarDB).where(
                            and_(OHLCVBarDB.pair_id == pair_id, OHLCVBarDB.timeframe == tf)
                        )
                    )
                    
                    # Insert in chunks using Python's built-in slicing
                    chunk_size = 5000
                    for i in range(0, len(new_bars), chunk_size):
                        chunk = new_bars[i:i+chunk_size]
                        await session.execute(pg_insert(OHLCVBarDB).values(chunk))
            
            await session.commit()
            print(f"      [DONE] Resampled M1 into M15, M30, H1, H4.")

    async def _import_zips_surgical(self, symbol, pair_id, start_year, end_year):
        for year in range(start_year, end_year + 1):
            async with AsyncSessionLocal() as session:
                stmt = select(func.count(OHLCVBarDB.id)).where(
                    and_(OHLCVBarDB.pair_id == pair_id,
                         OHLCVBarDB.timeframe == "M1",
                         func.extract('year', OHLCVBarDB.timestamp) == year)
                )
                y_count = (await session.execute(stmt)).scalar() or 0
                if y_count > 250000: continue

            zip_file = None
            if os.path.exists(self.zip_base_path):
                for root, _, files in os.walk(self.zip_base_path):
                    for f in files:
                        if symbol in f.upper() and f.endswith(".zip") and str(year) in f:
                            zip_file = os.path.join(root, f)
                            break
            if zip_file:
                print(f"    [LOCAL] Filling missing year {year}: {os.path.basename(zip_file)}")
                await asyncio.to_thread(self._stream_zip_to_db, zip_file, pair_id)

    async def _download_via_node_turbo(self, symbol, pair_id, from_date):
        instrument = symbol.lower().replace("_", "")
        to_date = datetime.now(timezone.utc).strftime("%Y-%m-%d")
        if from_date >= to_date: return

        node_cmd = "dukascopy-node"
        if shutil.which(node_cmd) is None: node_cmd = "npx dukascopy-node"
        
        cmd = f"{node_cmd} -i {instrument} -from {from_date} -to {to_date} -t m1 -f csv"
        try:
            process = await asyncio.create_subprocess_shell(cmd, stdout=asyncio.subprocess.PIPE, stderr=asyncio.subprocess.PIPE)
            stdout, _ = await process.communicate()
            if process.returncode == 0 and stdout:
                clean_csv = self._filter_garbage(stdout.decode('utf-8', errors='ignore'))
                if clean_csv:
                    out_p = os.path.join(self.temp_dir, f"{symbol}_turbo.csv")
                    with open(out_p, "w", encoding='utf-8') as f: f.write(clean_csv)
                    await asyncio.to_thread(self._stream_csv_to_db, out_p, pair_id)
                    if os.path.exists(out_p): os.remove(out_p)
        except: pass

    def _stream_csv_to_db(self, file_path, pair_id):
        try:
            reader = pd.read_csv(file_path, chunksize=50000)
            for df in reader:
                df['timestamp'] = pd.to_datetime(df['timestamp'])
                bars = [{"pair_id": pair_id, "timeframe": "M1", "timestamp": r.timestamp.to_pydatetime().replace(tzinfo=timezone.utc),
                         "open": float(r.open), "high": float(r.high), "low": float(r.low), "close": float(r.close),
                         "volume": float(r.volume), "spread_pips": 0.0} for r in df.itertuples()]
                with self.sync_engine.begin() as conn:
                    conn.execute(pg_insert(OHLCVBarDB).values(bars).on_conflict_do_nothing())
        except: pass

    def _stream_zip_to_db(self, zip_path, pair_id):
        with zipfile.ZipFile(zip_path, 'r') as z:
            csv_name = z.namelist()[0]
            with z.open(csv_name) as f:
                reader = pd.read_csv(f, sep=';', names=['ts', 'o', 'h', 'l', 'c', 'v'], header=None, chunksize=50000)
                for df in reader:
                    df['timestamp'] = pd.to_datetime(df['ts'], format='%Y%m%d %H%M%S')
                    bars = [{"pair_id": pair_id, "timeframe": "M1", "timestamp": r.timestamp.to_pydatetime().replace(tzinfo=timezone.utc),
                             "open": float(r.o), "high": float(r.h), "low": float(r.l), "close": float(r.c),
                             "volume": float(r.v), "spread_pips": 0.0} for r in df.itertuples()]
                    with self.sync_engine.begin() as conn:
                        conn.execute(pg_insert(OHLCVBarDB).values(bars).on_conflict_do_nothing())

    def _filter_garbage(self, raw_stdout: str) -> str:
        lines = raw_stdout.splitlines()
        for i, line in enumerate(lines):
            if "timestamp" in line.lower() and "open" in line.lower():
                return "\n".join(lines[i:])
        return ""

    async def _fill_live_gaps(self, symbol, pair_id, now):
        """Bridge for Phase 3."""
        await self.download_historical(target_symbol=symbol)
