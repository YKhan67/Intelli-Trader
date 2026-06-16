import asyncio
import os
import sys
import logging
from datetime import datetime

# Path resolution: Find project root (one level above this script)
current_dir = os.path.dirname(os.path.abspath(__file__))
project_root = os.path.dirname(current_dir)
if project_root not in sys.path:
    sys.path.insert(0, project_root)

from backend.modules.ingestion import IngestionManager
from backend.modules.learner.learning_engine import LearningEngine

# Configure Logging
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s"
)
logger = logging.getLogger("BrainSection")

async def run_brain():
    print("\n" + "="*60)
    print("SECTION 1: THE BRAIN (Ingestion & Historical Learning)")
    print("="*60)
    
    try:
        days = int(input("\nHow many days of history to sync/process? (1-1000): "))
    except:
        days = 365

    ingestion = IngestionManager()
    ingestion.price_dl.config["days_history"] = days
    
    # 1. High Speed Sync
    print("\n[STEP 1] Running Multi-Source Turbo Ingestion...")
    await ingestion.price_dl.download_historical()
    await ingestion.calendar_sc.download_historical()
    
    # 2. Historical Data Processing
    print("\n[STEP 2] Building Vectorized Institutional Memory...")
    learner = LearningEngine()
    pairs = ["EURUSD", "GBPUSD", "USDJPY", "AUDUSD", "USDCHF", "USDCAD", "NZDUSD", "XAUUSD", "BTCUSD"]
    timeframes = ["M15", "H1", "H4"]
    await learner.run_historical_processing(pairs, timeframes)
    
    # 3. Model Training
    print("\n[STEP 3] Initializing Model Training...")
    await learner.train_models(pairs)
    
    print("\n" + "="*60)
    print(f"BRAIN SYNC COMPLETE: {days} Days Ready for Executioner.")
    print("="*60)

if __name__ == "__main__":
    asyncio.run(run_brain())
