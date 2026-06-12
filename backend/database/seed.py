import asyncio
import os
import yaml
import sys

# Add project root to path
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), "../../")))

from backend.database.postgres import AsyncSessionLocal
from backend.database.models_db import CurrencyPairDB
from sqlalchemy import select

async def seed_data():
    print("Seeding currency pairs...")
    
    config_path = os.path.join(os.path.dirname(__file__), "../config/pairs.yaml")
    with open(config_path, "r") as f:
        pairs_data = yaml.safe_load(f)["pairs"]

    async with AsyncSessionLocal() as session:
        for p in pairs_data:
            # Check if exists
            stmt = select(CurrencyPairDB).where(CurrencyPairDB.symbol == p["symbol"])
            result = await session.execute(stmt)
            if result.scalar_one_or_none():
                print(f"Pair {p['symbol']} already exists, skipping.")
                continue
            
            new_pair = CurrencyPairDB(
                symbol=p["symbol"],
                pip_size=p["pip_size"],
                pip_value=p["pip_value"]
            )
            session.add(new_pair)
        
        await session.commit()
    print("Done.")

if __name__ == "__main__":
    asyncio.run(seed_data())
