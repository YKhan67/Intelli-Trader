import os
import sys

# MUST BE AT THE TOP: Add the project root to path so 'backend' package is found
project_root = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
if project_root not in sys.path:
    sys.path.append(project_root)

import asyncio
from backend.database.postgres import AsyncSessionLocal
from backend.database.models_db import OHLCVBarDB, EconomicCalendarDB, COTDataDB
from sqlalchemy import select, func

async def check():
    print("Connecting to database...")
    async with AsyncSessionLocal() as session:
        # Check OHLCV
        count_ohlcv = await session.execute(select(func.count(OHLCVBarDB.id)))
        print(f"OHLCV Bars: {count_ohlcv.scalar()}")
        
        # Check Calendar
        count_cal = await session.execute(select(func.count(EconomicCalendarDB.id)))
        print(f"Calendar Events: {count_cal.scalar()}")
        
        # Check COT
        count_cot = await session.execute(select(func.count(COTDataDB.id)))
        print(f"COT Data rows: {count_cot.scalar()}")
    print("Check complete.")

if __name__ == "__main__":
    asyncio.run(check())
