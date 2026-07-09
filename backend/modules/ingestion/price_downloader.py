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
from typing import List, Dict, Any, Optional, Set
from sqlalchemy import select, and_, func, create_engine, text
from sqlalchemy.dialects.postgresql import insert as pg_insert
from backend.database.postgres import AsyncSessionLocal, DATABASE_URL
from backend.database.models_db import CurrencyPairDB, OHLCVBarDB

logger = logging.getLogger("PriceDownloader")

class PriceDownloader:
    def __init__(self, config: Dict[str, Any]):
        self.config = config
        self.pairs = config.get("pairs", [])
        self.zip_base_path = config.get("historical_zip_path", "D:/prj/ForexDataDL/downloads")
        self.temp_dir = "backend/data/temp"
        os.makedirs(self.temp_dir, exist_ok=True)
        sync_url = DATABASE_URL.replace("postgresql+asyncpg", "postgresql")
        self.sync_engine = create_engine(sync_url, pool_pre_ping=True)
        self._active_processes: Set[asyncio.subprocess.Process] = set()

    async def download_historical(self, target_symbol: Optional[str] = None, live_mode: bool = False):
        days_back = 1 if live_mode else self.config.get("days_history", 30)
        now = datetime.now(timezone.utc)
        limit_date = now - timedelta(days=days_back)
        sync_list = [target_symbol] if target_symbol else self.pairs
        
        async with AsyncSessionLocal() as session:
            pair_map = {}
            for s in sync_list:
                res = await session.execute(select(CurrencyPairDB.id).where(CurrencyPairDB.symbol == s))
                pid = res.scalar()
                if pid: pair_map[s] = pid

            for symbol, pair_id in pair_map.items():
                stmt_max = select(func.max(OHLCVBarDB.timestamp)).where(
                    and_(OHLCVBarDB.pair_id == pair_id, OHLCVBarDB.timeframe == "M1")
                )
                last_ts_res = await session.execute(stmt_max)
                last_ts = last_ts_res.scalar()
                start_date = (last_ts + timedelta(minutes=1)) if last_ts else limit_date
                
                if (now - start_date).total_seconds() > 900:
                    await self._turbo_download_node(symbol, pair_id, start_date.strftime("%Y-%m-%d"))

                await self.resample_native_sql(pair_id, symbol, recent_only=live_mode)

    async def resample_native_sql(self, pair_id: int, symbol: str, recent_only: bool = False):
        """
        Institutional Atomic Resampling.
        LOGICAL FIX 1: Resample window increased to 500 hours (20+ days) to break the 
        48h/50-bar death loop and ensure stable indicator history.
        """
        timeframes = {"M15": "15 minutes", "M30": "30 minutes", "H1": "1 hour", "H4": "4 hours"}
        
        # Increased from 48h to 500h for live cycles
        limit_hours = 500 if recent_only else 90000 
        limit_ts = (datetime.now(timezone.utc) - timedelta(hours=limit_hours))
        limit_str = limit_ts.strftime('%Y-%m-%d %H:%M:%S')

        logger.info(f"Resampling {symbol} from {limit_str} (Window: {limit_hours}h)...")

        with self.sync_engine.begin() as conn:
            for tf_code, interval in timeframes.items():
                # Clean indicators
                conn.execute(text(f"""
                    DELETE FROM indicators WHERE bar_id IN (
                        SELECT id FROM ohlcv_bars 
                        WHERE pair_id = {pair_id} AND timeframe = '{tf_code}' AND timestamp >= '{limit_str}'
                    )
                """))
                # Clean existing bars
                conn.execute(text(f"""
                    DELETE FROM ohlcv_bars 
                    WHERE pair_id = {pair_id} AND timeframe = '{tf_code}' AND timestamp >= '{limit_str}'
                """))
                
                # Resample
                sql = text(f"""
                    INSERT INTO ohlcv_bars (pair_id, timeframe, timestamp, open, high, low, close, volume, spread_pips)
                    SELECT 
                        pair_id, 
                        '{tf_code}',
                        date_trunc('minute', timestamp) - (cast(extract(minute from timestamp) as integer) % (extract(epoch from interval '{interval}')::integer / 60)) * interval '1 minute' as bucket,
                        (array_agg(open ORDER BY timestamp ASC))[1], 
                        max(high), 
                        min(low), 
                        (array_agg(close ORDER BY timestamp DESC))[1], 
                        sum(volume), 
                        0.0
                    FROM ohlcv_bars
                    WHERE pair_id = :pid AND timeframe = 'M1' AND timestamp >= '{limit_str}'
                    GROUP BY pair_id, bucket
                    ON CONFLICT DO NOTHING
                """)
                conn.execute(sql, {"pid": pair_id})
        logger.info(f"      [DONE] {symbol} institutional resample finished.")

    async def _turbo_download_node(self, symbol, pair_id, from_date):
        instrument = symbol.lower().replace("_", "")
        node_cmd = "dukascopy-node"
        if shutil.which(node_cmd) is None: node_cmd = "npx dukascopy-node"
        cmd = f"{node_cmd} -i {instrument} -from {from_date} -t m1 -f csv"
        
        process = None
        try:
            process = await asyncio.create_subprocess_shell(
                cmd, 
                stdout=asyncio.subprocess.PIPE, 
                stderr=asyncio.subprocess.PIPE
            )
            self._active_processes.add(process)
            stdout, stderr = await process.communicate()
            
            if process.returncode == 0 and stdout:
                clean_csv = self._filter_garbage(stdout.decode('utf-8', errors='ignore'))
                if clean_csv:
                    f = io.StringIO(clean_csv)
                    df = pd.read_csv(f)
                    df.columns = [c.lower() for c in df.columns]
                    df['timestamp'] = pd.to_datetime(df['timestamp'])
                    bars = [{"pair_id": pair_id, "timeframe": "M1", "timestamp": r.timestamp.to_pydatetime().replace(tzinfo=timezone.utc),
                             "open": float(r.open), "high": float(r.high), "low": float(r.low), "close": float(r.close),
                             "volume": float(r.volume), "spread_pips": 0.0} for r in df.itertuples()]
                    with self.sync_engine.begin() as conn:
                        conn.execute(pg_insert(OHLCVBarDB).values(bars).on_conflict_do_nothing())
        except asyncio.CancelledError:
            if process and process.returncode is None:
                try:
                    process.terminate()
                    await asyncio.wait_for(process.wait(), timeout=3.0)
                except:
                    try: process.kill()
                    except: pass
            raise
        except Exception as e:
            logger.error(f"Turbo download failed for {symbol}: {e}")
        finally:
            if process in self._active_processes:
                self._active_processes.remove(process)

    def _filter_garbage(self, raw_stdout: str) -> str:
        lines = raw_stdout.splitlines()
        for i, line in enumerate(lines):
            if "timestamp" in line.lower() and "open" in line.lower():
                return "\n".join(lines[i:])
        return ""

    async def _fill_live_gaps(self, symbol, pair_id, now):
        await self.download_historical(target_symbol=symbol, live_mode=True)

    async def cleanup(self):
        """LOGICAL FIX 7: Harden Process Reaper for node.exe orphans."""
        if self.sync_engine: self.sync_engine.dispose()
        if not self._active_processes: return
        logger.info(f"Cleanup: Terminating {len(self._active_processes)} node processes...")
        cleanup_tasks = []
        for p in list(self._active_processes):
            if p.returncode is None:
                try:
                    p.terminate()
                    cleanup_tasks.append(asyncio.wait_for(p.wait(), timeout=2.0))
                except:
                    try: p.kill()
                    except: pass
        if cleanup_tasks:
            await asyncio.gather(*cleanup_tasks, return_exceptions=True)
        self._active_processes.clear()
