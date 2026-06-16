import asyncio
import sys
import os
import logging
from datetime import datetime, timedelta, timezone

# Add project root to sys.path
project_root = os.path.abspath(os.path.join(os.path.dirname(__file__), "../.."))
if project_root not in sys.path:
    sys.path.append(project_root)

from backend.modules.ingestion import IngestionManager
from backend.live_engine import get_engine

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("DataIngestor")

async def run_real_ingestion():
    print("\n" + "="*50)
    print("INSTITUTIONAL MASS DATA INGESTOR (VECTORIZED)")
    print("="*50)
    
    try:
        days_input = input("\nHow many days of historical data to sync? (1-1000): ")
        days = int(days_input)
    except:
        days = 30

    print(f"\n[PHASE 1] Initializing Vectorized Pipeline for {days} days...")
    ingestion = IngestionManager()
    ingestion.price_dl.config["days_history"] = days
    
    # Run the optimized concurrent downloader and vectorized resampler
    await ingestion.price_dl.download_historical()
    
    print(f"\n[PHASE 2] Syncing Economic Calendar...")
    await ingestion.calendar_sc.download_historical()
    
    print("\n[PHASE 3] Generating AI Signals (Vectorized Engine)...")
    engine = get_engine()
    pairs = ["EURUSD", "GBPUSD", "USDJPY", "AUDUSD", "USDCHF", "USDCAD", "NZDUSD", "XAUUSD", "BTCUSD"]
    
    for pair in pairs:
        print(f"  Calculating Signals for {pair}...")
        for tf in ["M15", "H1", "H4"]:
            try:
                # Use skip_sync=True because Phase 1 handled the entire vectorized state
                await engine.run_pair_cycle(pair, tf, skip_sync=True)
            except Exception as e:
                logger.error(f"  Error calculating signals for {pair} {tf}: {e}")

    print("\n" + "="*50)
    print(f"COMPLETE: Live Database Synchronized via Vectorized Engine.")
    print("="*50)

if __name__ == "__main__":
    asyncio.run(run_real_ingestion())
