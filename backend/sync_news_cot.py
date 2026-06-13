import asyncio
import os
import sys

# Add project root to path
project_root = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
if project_root not in sys.path:
    sys.path.append(project_root)

from backend.modules.ingestion import IngestionManager

async def main():
    print("=== STARTING FAST NEWS & COT SYNC ===")
    manager = IngestionManager()
    
    # 1. Sync Institutional Bias (COT)
    print("\n[1/2] Syncing COT Data (Institutional Bias)...")
    await manager.cot_dl.download_historical()
    
    # 2. Sync Latest News (RSS)
    print("\n[2/2] Fetching Latest News Headlines...")
    await manager.rss_poller.poll_once()
    
    print("\n=== SYNC COMPLETE ===")
    print("Run 'python check_db.py' and 'python check_mongo.py' to see the results.")

if __name__ == "__main__":
    asyncio.run(main())
