import asyncio
import os
import sys
import logging
from datetime import datetime, timezone

# Correct Path Resolution: Add the folder CONTAINING 'backend' to sys.path
# This script is at [ROOT]/backend/scripts/seed_initial_intelligence.py
current_script_dir = os.path.dirname(os.path.abspath(__file__))
project_root = os.path.dirname(os.path.dirname(current_script_dir))
if project_root not in sys.path:
    sys.path.insert(0, project_root)

from backend.database.postgres import AsyncSessionLocal
from backend.database.models_db import ModelVersionDB
from backend.modules.models import ModelStatus
from sqlalchemy import select

async def seed_intelligence():
    print("Seeding Initial Model Intelligence...")
    
    modules = [
        "Regime Classifier",
        "Strategy Selector",
        "Timeframe Scorer",
        "Risk Manager",
        "Anomaly Detector"
    ]
    
    async with AsyncSessionLocal() as session:
        for module in modules:
            # Check if this module already has a version
            stmt = select(ModelVersionDB).where(ModelVersionDB.module == module)
            res = await session.execute(stmt)
            if res.scalars().first():
                print(f"  {module} already has a version. Skipping.")
                continue

            # Create Baseline with a UNIQUE version string per module
            # Logic: include module name in version to satisfy unique constraint
            module_slug = module.lower().replace(" ", "_")
            version_str = f"1.0.0-{module_slug}-baseline"

            version = ModelVersionDB(
                version=version_str,
                module=module,
                status=ModelStatus.LIVE,
                metrics={"accuracy": 0.5, "note": "Initial baseline"}
            )
            session.add(version)
            # Flush or commit inside the loop to avoid autoflush issues with the next select
            await session.flush()
        
        await session.commit()
    print("Intelligence Seeding Complete.")

if __name__ == "__main__":
    asyncio.run(seed_intelligence())
