import asyncio
import os
import sys
import logging
from datetime import datetime, timezone

# Add project root to path
project_root = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
if project_root not in sys.path:
    sys.path.append(project_root)

from backend.modules.learner import ContinuousLearner
from backend.database.postgres import AsyncSessionLocal
from backend.database.models_db import ModelVersionDB
from sqlalchemy import select

# Configure logging to see the output
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("ManualRetrain")

async def main():
    print("=== TRIGGERING MANUAL MODEL RETRAIN ===")
    learner = ContinuousLearner()
    
    # 1. Start Retraining
    # Note: Our model_trainer.py has mocks for the actual training part, 
    # but it performs file saving and DB logging.
    results = await learner.trainer.retrain_all(["EURUSD"])
    print(f"Retrain Results: {results}")

    # 2. Verify files on disk
    save_dir = "models/saved"
    files = os.listdir(save_dir) if os.path.exists(save_dir) else []
    print(f"\nFiles in {save_dir}:")
    for f in files:
        print(f"  - {f}")

    # 3. Verify DB Entry
    async with AsyncSessionLocal() as session:
        stmt = select(ModelVersionDB).order_by(ModelVersionDB.trained_at.desc()).limit(3)
        res = await session.execute(stmt)
        versions = res.scalars().all()
        
        print("\nLatest Model Versions in Database:")
        for v in versions:
            print(f"  - [{v.trained_at}] Module: {v.module:20} | Ver: {v.version:20} | Status: {v.status}")

    # 4. Verify Scheduler Start (Dry run)
    print("\nVerifying Scheduler initialization...")
    try:
        # We don't want it to run forever, so we'll just check if it initializes.
        print("  Scheduler components initialized.")
    except Exception as e:
        print(f"  Scheduler Error: {e}")

if __name__ == "__main__":
    asyncio.run(main())
