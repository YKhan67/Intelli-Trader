import asyncio
import os
import sys
from sqlalchemy import select, func

# Add project root to path
project_root = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
if project_root not in sys.path:
    sys.path.append(project_root)

from backend.database.postgres import AsyncSessionLocal
from backend.database.models_db import OHLCVBarDB

async def main():
    async with AsyncSessionLocal() as session:
        stmt = select(func.min(OHLCVBarDB.timestamp), func.max(OHLCVBarDB.timestamp), func.count(OHLCVBarDB.id)).where(OHLCVBarDB.timeframe == "H1")
        res = await session.execute(stmt)
        min_ts, max_ts, count = res.fetchone()
        print(f"H1 Data Summary:")
        print(f"  Count: {count}")
        print(f"  Range: {min_ts} to {max_ts}")

if __name__ == "__main__":
    asyncio.run(main())
