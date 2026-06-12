import asyncio
import os
import sys

# Add the project root (Intelli-Trader) to the Python path
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

from backend.modules.ingestion import IngestionManager

async def main():
    print("Initializing Ingestion Manager...")
    manager = IngestionManager()
    
    print("Starting historical ingestion for EURUSD (Smoke Test)...")
    await manager.run_historical()
    print("Verification script finished.")

if __name__ == "__main__":
    asyncio.run(main())
