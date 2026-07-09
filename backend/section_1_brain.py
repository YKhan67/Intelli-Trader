import asyncio
import os
import sys
import logging
import signal
import zipfile
import io
import requests
import pandas as pd
import numpy as np
import multiprocessing
from datetime import datetime, timezone, timedelta
from concurrent.futures import ProcessPoolExecutor, as_completed
from sqlalchemy import select, func, and_, text, create_engine
from typing import List, Dict, Tuple

# Path resolution
current_dir = os.path.dirname(os.path.abspath(__file__))
project_root = os.path.dirname(current_dir)
if project_root not in sys.path:
    sys.path.insert(0, project_root)

from backend.database.postgres import AsyncSessionLocal, DATABASE_URL
from backend.database.models_db import OHLCVBarDB, CurrencyPairDB
from backend.modules.indicators.calculator import IndicatorCalculator
from backend.modules.learner.learning_engine import LearningEngine

# Configure Institutional Logging
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(name)s: %(message)s",
    handlers=[logging.StreamHandler(sys.stdout), logging.FileHandler("logs/brain_etl.log")]
)
logger = logging.getLogger("SmartBrain")

# --- Constants & Config ---
PAIRS = ["EURUSD", "GBPUSD", "USDJPY", "AUDUSD", "USDCHF", "USDCAD", "NZDUSD", "XAUUSD", "BTCUSD"]
TIMEFRAMES = ["M1", "M30", "H1", "H4"]
BASE_URL = "https://raw.githubusercontent.com/philipperemy/FX-1-Minute-Data/master"

# Global shutdown flag for workers
shutdown_event = multiprocessing.Event()

def signal_handler(sig, frame):
    print("\n" + "!"*60)
    print("CRITICAL: INTERRUPT RECEIVED. SHUTTING DOWN 56-CORE GRID...")
    print("!"*60)
    shutdown_event.set()
    sys.exit(0)

signal.signal(signal.SIGINT, signal_handler)

# --- ETL Worker Logic ---

def etl_worker_task(pair: str, year: int, pair_id: int):
    """
    Independent worker: Download -> Extract -> Resample -> Bulk Load.
    Designed for zero-dependency execution on a single core.
    """
    if shutdown_event.is_set(): return None
    
    # 1. Database Connection (Separate for each process)
    sync_url = DATABASE_URL.replace("postgresql+asyncpg", "postgresql")
    engine = create_engine(sync_url, pool_pre_ping=True)
    
    try:
        # 2. Download with Retry Logic
        url = f"{BASE_URL}/{pair}/{pair}_{year}.csv.zip"
        if pair in ["XAUUSD", "BTCUSD"]: # Handle different repo naming if any
             url = f"{BASE_URL}/{pair}/{pair}_{year}.csv.zip"

        csv_data = None
        for attempt in range(3):
            if shutdown_event.is_set(): return None
            try:
                r = requests.get(url, timeout=15)
                if r.status_code == 200:
                    with zipfile.ZipFile(io.BytesIO(r.content)) as z:
                        csv_filename = z.namelist()[0]
                        with z.open(csv_filename) as f:
                            csv_data = f.read()
                    break
                elif r.status_code == 404:
                    return f"SKIP: {pair} {year} (Not in archive)"
            except Exception as e:
                if attempt == 2: raise e
                asyncio.run(asyncio.sleep(5 * (attempt + 1)))

        if not csv_data: return f"FAIL: {pair} {year} (Download Error)"

        # 3. Process M1 Data
        df = pd.read_csv(io.BytesIO(csv_data), header=None, names=['ts', 'open', 'high', 'low', 'close', 'v'])
        df['ts'] = pd.to_datetime(df['ts'])
        df.set_index('ts', inplace=True)
        
        # 4. Multicore Resampling (Vectorized)
        resampled_payloads = []
        rules = {"M1": None, "M30": "30min", "H1": "1h", "H4": "4h"}
        
        for tf_code, rule in rules.items():
            if rule:
                work_df = df.resample(rule).agg({'open': 'first', 'high': 'max', 'low': 'min', 'close': 'last', 'v': 'sum'}).dropna()
            else:
                work_df = df

            # Prepare for DB
            for ts, row in work_df.iterrows():
                resampled_payloads.append({
                    "pair_id": pair_id,
                    "timeframe": tf_code,
                    "timestamp": ts.to_pydatetime().replace(tzinfo=timezone.utc),
                    "open": float(row['open']), "high": float(row['high']),
                    "low": float(row['low']), "close": float(row['close']),
                    "volume": float(row['v']), "spread_pips": 0.0
                })

        # 5. Bulk Load into PostgreSQL
        with engine.begin() as conn:
            # Atomic clear of this specific pair/year to allow clean re-runs
            start_yr = datetime(year, 1, 1, tzinfo=timezone.utc)
            end_yr = datetime(year, 12, 31, 23, 59, tzinfo=timezone.utc)
            conn.execute(text(f"DELETE FROM ohlcv_bars WHERE pair_id = {pair_id} AND timestamp >= '{start_yr}' AND timestamp <= '{end_yr}'"))
            
            # Chunked Insertion
            chunk_size = 5000
            for i in range(0, len(resampled_payloads), chunk_size):
                if shutdown_event.is_set(): break
                chunk = resampled_payloads[i:i + chunk_size]
                conn.execute(OHLCVBarDB.__table__.insert(), chunk)

        return f"SUCCESS: {pair} {year} Ported ({len(resampled_payloads)} bars)"

    except Exception as e:
        return f"ERROR: {pair} {year} -> {str(e)}"
    finally:
        engine.dispose()

# --- Main Controller ---

async def run_smart_brain():
    print("\n" + "="*70)
    print("🛡️  INTELLI-TRADER: SMART BRAIN (56-CORE ETL & LEARNING ENGINE)")
    print("="*70)
    
    # 1. User Input
    try:
        days = int(input("\nHow many days of history to verify/ingest? (1-7300): "))
    except:
        days = 3650
        
    start_date = datetime.now(timezone.utc) - timedelta(days=days)
    target_years = list(range(start_date.year, datetime.now().year + 1))

    # 2. Smart Gap Discovery
    print(f"\n[PHASE 1] Scanning Database for gaps since {start_date.date()}...")
    tasks = []
    
    async with AsyncSessionLocal() as session:
        pair_res = await session.execute(select(CurrencyPairDB.id, CurrencyPairDB.symbol))
        pair_map = {r[1]: r[0] for r in pair_res.all()}
        
        for pair in PAIRS:
            if pair not in pair_map: continue
            pid = pair_map[pair]
            
            for year in target_years:
                # Check if we have at least 10,000 M1 bars for this year/pair
                # (A full year has ~370,000 trading minutes)
                s_date = datetime(year, 1, 1, tzinfo=timezone.utc)
                e_date = datetime(year, 12, 31, 23, 59, tzinfo=timezone.utc)
                
                stmt = select(func.count(OHLCVBarDB.id)).where(
                    and_(OHLCVBarDB.pair_id == pid, OHLCVBarDB.timeframe == "M1",
                         OHLCVBarDB.timestamp >= s_date, OHLCVBarDB.timestamp <= e_date)
                )
                count = (await session.execute(stmt)).scalar()
                
                if count < 10000:
                    tasks.append((pair, year, pid))

    if not tasks:
        print("✅ No missing years detected in your request window. Database is healthy.")
    else:
        # 3. 56-Core Parallel ETL
        print(f"🚀 Identified {len(tasks)} pair-year tasks missing. Launching Parallel Grid...")
        
        # Adjust workers for 56-core efficiency (Max 56)
        max_workers = min(len(tasks), multiprocessing.cpu_count())
        
        with ProcessPoolExecutor(max_workers=max_workers) as executor:
            future_to_task = {executor.submit(etl_worker_task, t[0], t[1], t[2]): t for t in tasks}
            
            for future in as_completed(future_to_task):
                if shutdown_event.is_set(): break
                result = future.result()
                if result: print(f"  {result}")

    # 4. Intelligence Phase
    print("\n[PHASE 2] Building Technical Indicators (Multi-Core)...")
    learner = LearningEngine()
    # Process all pairs/timeframes to ensure indicators match newly ported data
    await learner.run_historical_processing(PAIRS, ["M30", "H1", "H4"])

    # 5. ML Training Phase
    print("\n[PHASE 3] Starting Autonomous Model Retraining...")
    await learner.train_models(PAIRS)
    
    print("\n" + "="*70)
    print("✅ SMART BRAIN CYCLE COMPLETE: 10 Years of Intelligence Deployed.")
    print("="*70)

if __name__ == "__main__":
    try:
        asyncio.run(run_smart_brain())
    except KeyboardInterrupt:
        pass
