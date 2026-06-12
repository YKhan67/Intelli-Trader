import asyncio
from backend.database.postgres import AsyncSessionLocal
from backend.database.models_db import OHLCVBarDB, EconomicCalendarDB, COTDataDB
from sqlalchemy import select, func

async def check():
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

if __name__ == "__main__":
    import os
    import sys
    sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))
    asyncio.run(check())
