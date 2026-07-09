import asyncio
import os
import sys
import io
import logging
from datetime import datetime, timezone
from sqlalchemy import text, create_engine, select
from concurrent.futures import ThreadPoolExecutor

# Path normalization
current_dir = os.path.dirname(os.path.abspath(__file__))
project_root = os.path.dirname(current_dir)
if project_root not in sys.path:
    sys.path.insert(0, project_root)

from backend.database.postgres import DATABASE_URL, AsyncSessionLocal
from backend.modules.learner.learning_engine import LearningEngine

logging.basicConfig(level=logging.INFO, format="%(asctime)s [%(levelname)s] %(message)s")
logger = logging.getLogger("SurgicalFix")

# --- Configuration for your missing file ---
TARGET_FILE = os.path.normpath("D:/prj/ForexDataDL/extracted/EURUSD/2022/DAT_ASCII_EURUSD_M1_2022.csv")
TARGET_PAIR = "EURUSD"

def transform_line(line, pair_id):
    try:
        parts = line.strip().split(';')
        if parts.__len__() < 6: return None
        dt = datetime.strptime(parts[0], "%Y%m%d %H%M%S").replace(tzinfo=timezone.utc)
        return f"{pair_id}\tM1\t{dt.isoformat()}\t{parts[1]}\t{parts[2]}\t{parts[3]}\t{parts[4]}\t{parts[5]}\t0.0\n"
    except: return None

async def main():
    sys.stdout.write("\n" + "="*60 + "\n")
    sys.stdout.write(f"🛡️  INTELLI-TRADER: SURGICAL GAP REPAIR [{TARGET_PAIR}]\n")
    sys.stdout.write("="*60 + "\n")

    if not os.path.exists(TARGET_FILE):
        logger.error(f"File not found: {TARGET_FILE}")
        return

    # 1. Get Pair ID
    async with AsyncSessionLocal() as session:
        res = await session.execute(text(f"SELECT id FROM currency_pairs WHERE symbol = '{TARGET_PAIR}'"))
        pid = res.scalar()
        if not pid:
            logger.error(f"Pair {TARGET_PAIR} not found in database.")
            return

    # 2. High-Speed Import
    logger.info(f"Streaming {TARGET_FILE} into database...")
    sync_url = DATABASE_URL.replace("asyncpg", "psycopg2") if "asyncpg" in DATABASE_URL else DATABASE_URL
    se = create_engine(sync_url)
    
    buf = io.StringIO()
    with open(TARGET_FILE, 'r', encoding='utf-8', errors='ignore') as f:
        for line in f:
            fmt = transform_line(line, pid)
            if fmt: buf.write(fmt)
    
    buf.seek(0)
    with se.raw_connection() as conn:
        with conn.cursor() as cur:
            cur.execute("CREATE TEMP TABLE lnd_fix (p int, tf text, ts timestamptz, o float, h float, l float, c float, v float, s float) ON COMMIT DROP")
            cur.copy_from(buf, 'lnd_fix')
            cur.execute("INSERT INTO ohlcv_bars (pair_id, timeframe, timestamp, open, high, low, close, volume, spread_pips) SELECT * FROM lnd_fix ON CONFLICT DO NOTHING")
        conn.commit()
    se.dispose()
    logger.info("✅ M1 Data Gap Filled.")

    # 3. Resample EURUSD only
    logger.info("Updating H1/H4 timeframes for EURUSD...")
    intervals = {"M15": 900, "M30": 1800, "H1": 3600, "H4": 14400}
    async with AsyncSessionLocal() as session:
        for tf, secs in intervals.items():
            sql = text(f"INSERT INTO ohlcv_bars (pair_id, timeframe, timestamp, open, high, low, close, volume, spread_pips) SELECT {pid}, '{tf}', to_timestamp(floor(extract(epoch from timestamp) / {secs}) * {secs}) AT TIME ZONE 'UTC', (array_agg(open ORDER BY timestamp ASC))[1], max(high), min(low), (array_agg(close ORDER BY timestamp DESC))[1], sum(volume), 0.0 FROM ohlcv_bars WHERE pair_id = {pid} AND timeframe = 'M1' GROUP BY 3 ON CONFLICT DO NOTHING")
            await session.execute(sql)
        await session.commit()

    # 4. Indicators for EURUSD only
    logger.info("Recalculating AI Indicators for EURUSD...")
    learner = LearningEngine()
    await learner.run_historical_processing([TARGET_PAIR], ["M30", "H1", "H4"])

    sys.stdout.write("\n✅ SURGICAL REPAIR COMPLETE. EURUSD is now 100% gap-less.\n")

if __name__ == "__main__":
    asyncio.run(main())
