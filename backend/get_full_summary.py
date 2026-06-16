import asyncio
import os
import sys
from sqlalchemy import select, func

# Add project root to path
project_root = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
if project_root not in sys.path:
    sys.path.append(project_root)

from backend.database.postgres import AsyncSessionLocal
from backend.database.models_db import OHLCVBarDB, CurrencyPairDB

async def main():
    async with AsyncSessionLocal() as session:
        stmt = select(CurrencyPairDB)
        res = await session.execute(stmt)
        pairs = res.scalars().all()
        
        for p in pairs:
            print(f"--- Pair: {p.symbol} ---")
            stmt = select(
                OHLCVBarDB.timeframe, 
                func.count(OHLCVBarDB.id), 
                func.min(OHLCVBarDB.timestamp), 
                func.max(OHLCVBarDB.timestamp)
            ).where(OHLCVBarDB.pair_id == p.id).group_by(OHLCVBarDB.timeframe)
            res = await session.execute(stmt)
            for tf, count, start, end in res.all():
                print(f"  {tf}: {count} bars | {start.date()} to {end.date()}")

if __name__ == "__main__":
    asyncio.run(main())
