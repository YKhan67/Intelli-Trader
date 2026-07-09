import asyncio
import os
import sys

# Path resolution
project_root = os.path.abspath(os.path.join(os.path.dirname(__file__), "../.."))
if project_root not in sys.path:
    sys.path.append(project_root)

from backend.database.postgres import engine, Base
# Import models to ensure they are registered with Base
from backend.database.models_db import ModelFeedbackDB

async def sync_tables():
    print(">>> Syncing new institutional tables (Immune System)...")
    try:
        async with engine.begin() as conn:
            # This will ONLY create tables that do not exist yet.
            # It will NOT delete or overwrite your 10 years of price data.
            await conn.run_sync(Base.metadata.create_all)
        print("✅ SUCCESS: 'model_feedback' table is now live in PostgreSQL.")
    except Exception as e:
        print(f"❌ FAILED to sync tables: {e}")

if __name__ == "__main__":
    asyncio.run(sync_tables())
