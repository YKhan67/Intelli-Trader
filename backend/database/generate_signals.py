import asyncio
import sys
import os
import logging
from datetime import datetime, timezone

# Add project root to sys.path
project_root = os.path.abspath(os.path.join(os.path.dirname(__file__), "../.."))
if project_root not in sys.path:
    sys.path.append(project_root)

from backend.live_engine import get_engine

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("SignalGenerator")

async def run_signals_only():
    print("\n" + "="*50)
    print("AI SIGNAL GENERATOR (PHASE 3 ONLY)")
    print("="*50)
    
    engine = get_engine()
    pairs = ["EURUSD", "GBPUSD", "USDJPY", "AUDUSD", "USDCHF", "USDCAD", "NZDUSD", "XAUUSD", "BTCUSD"]
    timeframes = ["M15", "H1", "H4"]

    print(f"\nStarting AI Pipeline for {len(pairs)} pairs...")

    for pair in pairs:
        print(f"\n>>> Processing {pair}...")
        for tf in timeframes:
            try:
                # skip_sync=True uses the existing data in Postgres
                print(f"    Calculating {tf}...")
                await engine.run_pair_cycle(pair, tf, skip_sync=True)
            except Exception as e:
                logger.error(f"    FAILED {pair} {tf}: {e}")

    print("\n" + "="*50)
    print("COMPLETE: All AI Signals pushed to Redis.")
    print("="*50)

if __name__ == "__main__":
    asyncio.run(run_signals_only())
