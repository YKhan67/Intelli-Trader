import asyncio
import os
import subprocess
import pandas as pd
import logging
import zipfile
import re
import shutil
import io
from datetime import datetime, timedelta, timezone
from typing import List, Dict, Any, Optional
from sqlalchemy import select, and_, func, create_engine, text
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
        
        # High-speed sync engine
        sync_url = DATABASE_URL.replace("postgresql+asyncpg", "postgresql")
        self.sync_engine = create_engine(sync_url)

    async def download_historical(self, target_symbol: Optional[str] = None):
        """Waterfall Sync: Optimized with Native-SQL Resampling (Zero-Network)."""
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
                
                # Check DB coverage for M1
                stmt_max = select(func.max(OHLCVBarDB.timestamp)).where(
                    and_(OHLCVBarDB.pair_id == pair_id, OHLCVBarDB.timeframe == "M1")
                )
                last_ts = (await session.execute(stmt_max)).scalar()
                
                start_date = (last_ts + timedelta(minutes=1)) if last_ts else default_start
                
                # Download M1 gap if needed
                if start_date < (now - timedelta(hours=1)):
                    from_str = start_date.strftime("%Y-%m-%d")
                    print(f"    [INFO] Filling M1 gap from {from_str}...")
                    await self._turbo_download_node(symbol, pair_id, from_str)

                # NATIVE-SQL HOTPATH: Resample directly in Postgres (Zero-Network)
                # This is the fastest method possible. Data never leaves the database.
                print(f"    [HOTPATH] Native SQL Resampling for {symbol}...")
                await self.resample_native_sql(pair_id, symbol)

    async def resample_native_sql(self, pair_id: int, symbol: str):
        """
        Uses PostgreSQL native window functions for instant resampling.
        Bypasses Python network overhead entirely.
        """
        timeframes = {
            "M15": "15 minutes",
            "M30": "30 minutes",
            "H1": "1 hour",
            "H4": "4 hours"
        }

        with self.sync_engine.begin() as conn:
            for tf_code, interval in timeframes.items():
                # 1. Atomic clear: Delete referencing indicators first, then the bars
                # This prevents ForeignKeyViolation errors
                conn.execute(text(f"""
                    DELETE FROM indicators 
                    WHERE bar_id IN (
                        SELECT id FROM ohlcv_bars 
                        WHERE pair_id = {pair_id} AND timeframe = '{tf_code}'
                    )
                """))
                conn.execute(text(f"DELETE FROM ohlcv_bars WHERE pair_id = {pair_id} AND timeframe = '{tf_code}'"))
                
                # 2. Native Resample: Group by Epoch bucket
                # This logic accurately captures Open, High, Low, Close within each time block
                sql = text(f"""
                    INSERT INTO ohlcv_bars (pair_id, timeframe, timestamp, open, high, low, close, volume, spread_pips)
                    SELECT 
                        pair_id,
                        '{tf_code}',
                        (to_timestamp(floor(extract(epoch from timestamp) / extract(epoch from interval '{interval}')) * extract(epoch from interval '{interval}'))) AT TIME ZONE 'UTC' as bucket,
                        (array_agg(open ORDER BY timestamp ASC))[1] as open,
                        max(high) as high,
                        min(low) as low,
                        (array_agg(close ORDER BY timestamp DESC))[1] as close,
                        sum(volume) as volume,
                        0.0
                    FROM ohlcv_bars
                    WHERE pair_id = :pid AND timeframe = 'M1'
                    GROUP BY pair_id, bucket
                    ORDER BY bucket ASC
                """)
                conn.execute(sql, {"pid": pair_id})
                
        print(f"      [DONE] {symbol} resampled into M15, M30, H1, H4.")

    async def _turbo_download_node(self, symbol, pair_id, from_date):
        """High-speed bridge using dukascopy-node CLI."""
        instrument = symbol.lower().replace("_", "")
        to_date = datetime.now(timezone.utc).strftime("%Y-%m-%d")
        
        node_cmd = "dukascopy-node"
        if shutil.which(node_cmd) is None: node_cmd = "npx dukascopy-node"
        
        cmd = f"{node_cmd} -i {instrument} -from {from_date} -to {to_date} -t m1 -f csv"
        
        try:
            process = await asyncio.create_subprocess_shell(
                cmd, stdout=asyncio.subprocess.PIPE, stderr=asyncio.subprocess.PIPE
            )
            stdout, stderr = await process.communicate()
            
            if process.returncode == 0 and stdout:
                clean_csv = self._filter_garbage(stdout.decode('utf-8', errors='ignore'))
                if clean_csv:
                    await asyncio.to_thread(self._bulk_insert_csv, clean_csv, pair_id)
            else:
                logger.warning(f"Turbo failed for {symbol}: {stderr.decode() if stderr else 'No data'}")
        except Exception as e:
            logger.error(f"Turbo error: {e}")

    def _bulk_insert_csv(self, csv_data, pair_id):
        """Vectorized CSV import."""
        try:
            f = io.StringIO(csv_data)
            df = pd.read_csv(f)
            if df.empty: return

            df.columns = [c.lower() for c in df.columns]
            df['timestamp'] = pd.to_datetime(df['timestamp'])
            
            # Prepare rows as list of dicts for bulk insert
            bars = []
            for r in df.itertuples():
                bars.append({
                    "pair_id": pair_id, "timeframe": "M1",
                    "timestamp": r.timestamp.to_pydatetime().replace(tzinfo=timezone.utc),
                    "open": r.open, "high": r.high, "low": r.low, "close": r.close,
                    "volume": r.volume, "spread_pips": 0.0
                })

            if bars:
                with self.sync_engine.begin() as conn:
                    conn.execute(pg_insert(OHLCVBarDB).values(bars).on_conflict_do_nothing())
        except Exception as e:
            logger.error(f"Bulk insert failed: {e}")

    def _filter_garbage(self, raw_stdout: str) -> str:
        lines = raw_stdout.splitlines()
        for i, line in enumerate(lines):
            if "timestamp" in line.lower() and "open" in line.lower():
                return "\n".join(lines[i:])
        return ""

    async def _fill_live_gaps(self, symbol, pair_id, now):
        await self.download_historical(target_symbol=symbol)
