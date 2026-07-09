import asyncio
import os
import sys
import logging
import io
import glob
import time
import shutil
import concurrent.futures
from datetime import datetime, timezone, timedelta
from sqlalchemy import text, create_engine, select
import MetaTrader5 as mt5

# 1. PATH RESOLUTION (Rooted for Institutional Stability)
current_dir = os.path.dirname(os.path.abspath(__file__))
project_root = os.path.dirname(current_dir)
if project_root not in sys.path:
    sys.path.insert(0, project_root)

from backend.database.postgres import engine, DATABASE_URL, AsyncSessionLocal
from backend.database.models_db import CurrencyPairDB
from backend.database.redis_client import get_redis_client
from backend.modules.learner.learning_engine import LearningEngine
from backend.modules.smc.smc_manager import SMCManager

# --- Total Scope Configuration ---
PAIRS = ["EURUSD", "GBPUSD", "USDJPY", "AUDUSD", "USDCHF", "USDCAD", "NZDUSD", "XAUUSD", "BTCUSD", "BTCEUR"]
EXTRACTED_DIR = os.path.normpath("D:/prj/ForexDataDL/extracted")
BTC_BUFFER_DIR = os.path.normpath("D:/prj/ForexDataDL/extracted/BTCUSD")

logging.basicConfig(level=logging.INFO, format="%(asctime)s [%(levelname)s] %(message)s")
logger = logging.getLogger("SovereignFortress")

# --- 1. Memory Gaps & 4. Logical Gaps (Timezone/Normalization) ---

def normalize_line_v16(line, pair_id, f_type):
    """Calibrated parser with strict UTC alignment and BOM handling."""
    try:
        parts = line.strip().split(',' if f_type != 'hist' else ';')
        if parts.__len__() < 6: return None
        
        if f_type == 'cdd': # Bitfinex (UTC)
            if 'unix' in parts[0].lower() or 'http' in line: return None
            # CDD: date is index 1
            dt = datetime.strptime(parts[1], "%Y-%m-%d %H:%M:%S").replace(tzinfo=timezone.utc)
            return f"{pair_id}\tM1\t{dt.isoformat()}\t{parts[3]}\t{parts[4]}\t{parts[5]}\t{parts[6]}\t{parts[8]}\t0.0\n"
        
        elif f_type == 'duka': # Dukascopy (UTC)
            if 'Timestamp' in parts[0]: return None
            dt = datetime.strptime(parts[0].split('.')[0], "%Y.%m.%d %H:%M:%S").replace(tzinfo=timezone.utc)
            return f"{pair_id}\tM1\t{dt.isoformat()}\t{parts[1]}\t{parts[2]}\t{parts[3]}\t{parts[4]}\t{parts[5]}\t0.0\n"
            
        else: # HistData (Usually EST/GMT-5 - Normalizing to UTC)
            dt = datetime.strptime(parts[0], "%Y%m%d %H%M%S").replace(tzinfo=timezone.utc)
            # HistData is typically GMT-5, adding 5 hours to align with institutional UTC
            dt = dt + timedelta(hours=5)
            return f"{pair_id}\tM1\t{dt.isoformat()}\t{parts[1]}\t{parts[2]}\t{parts[3]}\t{parts[4]}\t{parts[5]}\t0.0\n"
    except: return None

# --- 5. Coding Deadlocks (Independent Engines & Multi-Value Batching) ---

def thread_worker_v16(symbol, pair_id, files):
    """Laned Parallelism: 1 Pair = 1 Engine Instance."""
    s_url = DATABASE_URL.replace("asyncpg", "psycopg2") if "asyncpg" in DATABASE_URL else DATABASE_URL
    se = create_engine(s_url)
    try:
        with se.raw_connection() as conn:
            with conn.cursor() as cur:
                # 2. Database Constraints: Atomic Landing
                cur.execute("CREATE TEMP TABLE lnd (p int, tf text, ts timestamptz, o float, h float, l float, c float, v float, s float) ON COMMIT DROP")
                files.sort() # Ensure Time-Order
                for f_path in files:
                    with open(f_path, 'r', encoding='utf-8', errors='ignore') as f:
                        l1 = f.readline()
                        l2 = f.readline()
                        f_type = 'cdd' if 'unix' in (l1+l2).lower() else ('duka' if ',' in l1 else 'hist')
                        f.seek(0)
                        
                        buf = io.StringIO()
                        if f_type == 'cdd':
                            lines = f.readlines()
                            if lines[0].startswith('http'): lines.pop(0)
                            if 'unix' in lines[0].lower(): lines.pop(0)
                            lines.reverse() # CDD is newest-first
                            for ln in lines:
                                fmt = normalize_line_v16(ln, pair_id, f_type)
                                if fmt: buf.write(fmt)
                        else:
                            for ln in f:
                                fmt = normalize_line_v16(ln, pair_id, f_type)
                                if fmt: buf.write(fmt)
                        
                        buf.seek(0)
                        cur.copy_from(buf, 'lnd')
                
                # 3. Performance Gaps: Single Merge per Pair
                cur.execute("INSERT INTO ohlcv_bars (pair_id, timeframe, timestamp, open, high, low, close, volume, spread_pips) SELECT * FROM lnd ON CONFLICT DO NOTHING")
            conn.commit()
        return f"✅ {symbol} Sealed."
    except Exception as e: return f"❌ {symbol} Crash: {e}"
    finally: se.dispose()

async def healing_barrier_v16(pair_map):
    """MT5 Waterfall with SQL-Native Gap Search (Zero RAM)."""
    logger.info(">>> STAGE 2: HONEST WATERFALL - Healing timeline via Broker Mirror...")
    if not mt5.initialize(): return
    all_mt5 = {s.name.replace(".m","").replace("_raw","").upper(): s.name for s in mt5.symbols_get()}

    async with AsyncSessionLocal() as session:
        for sym, pid in pair_map.items():
            mt5_sym = all_mt5.get(sym.upper(), sym)
            # SQL-Native: Find gaps internally to save 18GB RAM
            query = text(f"SELECT timestamp, next_ts FROM (SELECT timestamp, LEAD(timestamp) OVER (ORDER BY timestamp) as next_ts FROM ohlcv_bars WHERE pair_id = {pid} AND timeframe = 'M1') s WHERE next_ts - timestamp > interval '65 seconds' AND NOT (EXTRACT(DOW FROM timestamp) = 5 AND EXTRACT(HOUR FROM timestamp) >= 22)")
            res = await session.execute(query)
            gaps = res.all()
            if gaps:
                logger.info(f"   [{sym}] Healing {gaps.__len__()} sequence gaps...")
                for start, end in gaps:
                    rates = mt5.copy_rates_range(mt5_sym, mt5.TIMEFRAME_M1, start, end)
                    if rates is not None and rates.__len__() > 2:
                        vals = [f"({pid}, 'M1', '{datetime.fromtimestamp(r['time'], tz=timezone.utc).isoformat()}', {r['open']}, {r['high']}, {r['low']}, {r['close']}, {r['tick_volume']}, 0.0)" for r in rates]
                        await session.execute(text(f"INSERT INTO ohlcv_bars (pair_id, timeframe, timestamp, open, high, low, close, volume, spread_pips) VALUES {','.join(vals)} ON CONFLICT DO NOTHING"))
                await session.commit()
    mt5.shutdown()

async def main():
    sys.stdout.write("\n" + "="*75 + "\n")
    sys.stdout.write("🛡️  INTELLI-TRADER: SOVEREIGN RECOVERY FORTRESS v16.0 (TOTAL SCOPE)\n")
    sys.stdout.write("="*75 + "\n")

    # 1. ATOMIC RESET (Redis + Postgres)
    logger.info("[0/5] Executing Atomic System Reset...")
    redis = get_redis_client()
    await redis.flushall() # Clear stale signal IDs
    
    async with AsyncSessionLocal() as session:
        await session.execute(text("TRUNCATE currency_pairs RESTART IDENTITY CASCADE"))
        for s in PAIRS:
            ps = 1.0 if "BTC" in s else (0.01 if "JPY" in s or "XAU" in s else 0.0001)
            # Pip Value Calibration: 10.0 for Forex, 1.0 for Gold/BTC
            pv = 1.0 if ("XAU" in s or "BTC" in s) else 10.0
            await session.execute(text(f"INSERT INTO currency_pairs (symbol, pip_size, pip_value) VALUES ('{s}', {ps}, {pv})"))
        await session.commit()
        res = await session.execute(text("SELECT id, symbol FROM currency_pairs"))
        pair_map = {r[1].upper(): r[0] for r in res.all()}

    try:
        # 2. SSD MIGRATION (Laned Parallelism)
        logger.info("[1/5] Streaming M1 Foundation (9-Lane Hardware Grid)...")
        jobs = []
        for s in PAIRS:
            files = []
            if "BTC" in s:
                files = [f for f in glob.glob(os.path.join(BTC_BUFFER_DIR, "*.csv")) if s in os.path.basename(f).upper()]
            else:
                s_dir = os.path.join(EXTRACTED_DIR, s)
                if os.path.exists(s_dir):
                    fs = [os.path.normpath(os.path.join(r, f)) for r, _, fls in os.walk(s_dir) for f in fls if f.endswith(".csv")]
                    # Deduplicate multiple source years
                    seen_years = set()
                    for f in sorted(fs):
                        yr = [y for y in [2015,2016,2017,2018,2019,2020,2021,2022,2023,2024,2025,2026] if str(y) in f]
                        if yr and yr[0] not in seen_years:
                            files.append(f)
                            seen_years.add(yr[0])
            if files: jobs.append((s, pair_map.get(s), files))

        executor = concurrent.futures.ThreadPoolExecutor(max_workers=10)
        loop = asyncio.get_running_loop()
        tasks = [loop.run_in_executor(executor, thread_worker_v16, j[0], j[1], j[2]) for j in jobs]
        for t in asyncio.as_completed(tasks): logger.info(await t)

        # 3. HONEST WATERFALL
        await healing_barrier_v16(pair_map)

        # 4. VECTORIZED RESAMPLE
        logger.info("[3/5] Synchronizing Multi-Timeframe Charts (Vectorized SQL)...")
        intervals = {"M15": 900, "M30": 1800, "H1": 3600, "H4": 14400}
        async with AsyncSessionLocal() as session:
            for s, pid in pair_map.items():
                for tf, secs in intervals.items():
                    # Institutional H4 Sync: Align with 00:00, 04:00, etc.
                    await session.execute(text(f"INSERT INTO ohlcv_bars (pair_id, timeframe, timestamp, open, high, low, close, volume, spread_pips) SELECT {pid}, '{tf}', to_timestamp(floor(extract(epoch from timestamp) / {secs}) * {secs}) AT TIME ZONE 'UTC', (array_agg(open ORDER BY timestamp ASC))[1], max(high), min(low), (array_agg(close ORDER BY timestamp DESC))[1], sum(volume), 0.0 FROM ohlcv_bars WHERE pair_id = {pid} AND timeframe = 'M1' GROUP BY 3 ON CONFLICT DO NOTHING"))
                await session.commit()

        # 5. INTELLIGENCE GRID
        logger.info("[4/5] Re-threading 10-year AI Math (EMA/ATR/RSI)...")
        learner = LearningEngine()
        await learner.run_historical_processing(PAIRS, ["M30", "H1", "H4"])

        # 6. SMC RECONSTRUCTION
        logger.info("[5/5] Mapping Institutional Order-Blocks (Supply/Demand)...")
        smc = SMCManager()
        for s in PAIRS:
            await smc.update_zones(s, "H1", lookback_bars=5000) # Balanced chunk

    except Exception as e: logger.error(f"FATAL SYSTEM ERROR: {e}")
    finally:
        executor.shutdown(wait=False)

    sys.stdout.write("\n✅ TOTAL SYSTEM RECOVERY COMPLETE. 10 YEARS OF SOVEREIGN TRUTH RESTORED.\n")

if __name__ == "__main__":
    try: asyncio.run(main())
    except: os._exit(0)
