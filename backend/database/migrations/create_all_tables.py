import asyncio
import os
import sys

# Add project root to path
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), "../../../")))

from backend.database.postgres import engine, Base
from backend.database.models_db import (
    CurrencyPairDB, OHLCVBarDB, IndicatorDB, SMCZoneDB, 
    RegimeHistoryDB, StrategyDecisionDB, TradeDB, 
    PerformanceDailyDB, PerformanceStrategyDB, 
    EconomicCalendarDB, COTDataDB, ModelVersionDB, 
    DataDownloadLogDB
)

async def create_tables():
    print("Dropping all PostgreSQL tables (Resetting)...")
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.drop_all)
    
    print("Creating all PostgreSQL tables...")
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)
    print("Done.")

if __name__ == "__main__":
    asyncio.run(create_tables())
