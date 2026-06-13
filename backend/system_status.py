import os
import sys
import asyncio
from datetime import datetime, timezone

# Add project root to path
project_root = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
if project_root not in sys.path:
    sys.path.append(project_root)

from backend.database.postgres import AsyncSessionLocal
from backend.database.mongo import get_mongo_db
from backend.database.models_db import OHLCVBarDB, COTDataDB, EconomicCalendarDB, SMCZoneDB
from sqlalchemy import select, func

async def check_real_time_status():
    print("=== FOREXAI REAL-TIME STATUS DASHBOARD ===")
    now = datetime.now(timezone.utc)
    
    # 1. Price Data Freshness
    async with AsyncSessionLocal() as session:
        stmt = select(func.max(OHLCVBarDB.timestamp))
        res = await session.execute(stmt)
        latest_price = res.scalar()
        
        if latest_price:
            diff = (now - latest_price).total_seconds() / 60
            status = "FRESH" if diff < 60 else "STALE"
            print(f"Price Data: {latest_price.strftime('%Y-%m-%d %H:%M')} UTC ({status}, {diff:.1f} mins ago)")
        else:
            print("Price Data: NO DATA")

    # 2. News Data Freshness
    db = get_mongo_db()
    latest_news_doc = await db.news_articles.find_one(sort=[("received_at", -1)])
    if latest_news_doc:
        received_at = latest_news_doc.get("received_at").replace(tzinfo=timezone.utc)
        diff = (now - received_at).total_seconds() / 60
        status = "FRESH" if diff < 15 else "STALE"
        print(f"News Headlines: {received_at.strftime('%Y-%m-%d %H:%M')} UTC ({status}, {diff:.1f} mins ago)")
    else:
        print("News Headlines: NO DATA")

    # 3. Institutional Bias (COT)
    async with AsyncSessionLocal() as session:
        stmt = select(func.max(COTDataDB.week_ending))
        res = await session.execute(stmt)
        latest_cot = res.scalar()
        if latest_cot:
            print(f"COT Bias: Latest report from {latest_cot.strftime('%Y-%m-%d')}")
        else:
            print("COT Bias: NO DATA")

    # 4. SMC Zones
    async with AsyncSessionLocal() as session:
        stmt = select(func.count(SMCZoneDB.id)).where(SMCZoneDB.is_active == True)
        res = await session.execute(stmt)
        count = res.scalar()
        print(f"Active SMC Zones: {count} zones currently tracked")

    print("==========================================")

if __name__ == "__main__":
    asyncio.run(check_real_time_status())
