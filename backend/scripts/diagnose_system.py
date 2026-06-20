import asyncio
import os
import sys
import logging
from datetime import datetime, timezone

# Correct Path Resolution
current_script_dir = os.path.dirname(os.path.abspath(__file__))
project_base = os.path.dirname(os.path.dirname(current_script_dir))
if project_base not in sys.path:
    sys.path.insert(0, project_base)

from backend.database.postgres import check_postgres_health, AsyncSessionLocal
from backend.database.models_db import OHLCVBarDB, TradeDB, IndicatorDB, CurrencyPairDB, ModelVersionDB, COTDataDB, EconomicCalendarDB
from sqlalchemy import select, func

async def diagnose():
    print("\n" + "="*60)
    print("INTELLI-TRADER INSTITUTIONAL DIAGNOSTIC v2")
    print("="*60)
    
    # 1. DB Connectivity
    pg_ok = await check_postgres_health()
    print(f"[DB] PostgreSQL: {'✅ HEALTHY' if pg_ok else '❌ FAILED'}")

    async with AsyncSessionLocal() as session:
        # 2. Pair Check
        res = await session.execute(select(func.count(CurrencyPairDB.id)))
        pair_count = res.scalar()
        print(f"[DATA] Currency Pairs configured: {pair_count}")

        # 3. Data Freshness Check
        for tf in ["M1", "H1", "H4"]:
            stmt = select(func.max(OHLCVBarDB.timestamp)).where(OHLCVBarDB.timeframe == tf)
            res = await session.execute(stmt)
            latest = res.scalar()
            if latest:
                if latest.tzinfo is None: latest = latest.replace(tzinfo=timezone.utc)
                diff = (datetime.now(timezone.utc) - latest).total_seconds() / 3600
                status = "✅ FRESH" if diff < 2 else "⚠️ STALE"
                print(f"[DATA] {tf} Latest Bar: {latest} ({status}, {diff:.1f}h ago)")
            else:
                print(f"[DATA] {tf} Latest Bar: ❌ NO DATA")

        # 4. Sentiment Data Check
        from backend.database.mongo import get_mongo_db
        try:
            db = get_mongo_db()
            news_count = await db.news_articles.count_documents({})
            processed_count = await db.news_articles.count_documents({"is_processed": True})
            print(f"[DATA] News Articles: {news_count} total, {processed_count} processed AI.")
        except:
            print("[DATA] MongoDB News: ❌ CONNECTION FAILED")

        # 5. COT Data Check
        res = await session.execute(select(func.count(COTDataDB.id)))
        cot_count = res.scalar()
        print(f"[DATA] COT Data Records: {cot_count}")

        # 6. Economic Calendar Check
        res = await session.execute(select(func.count(EconomicCalendarDB.id)))
        cal_count = res.scalar()
        print(f"[DATA] Calendar Events: {cal_count}")

        # 7. Model Version Check
        stmt = select(ModelVersionDB).order_by(ModelVersionDB.trained_at.desc())
        res = await session.execute(stmt)
        versions = res.scalars().all()
        if versions:
            print(f"[AI] Active Models: {len(versions)} detected.")
        else:
            print("[AI] Active Models: ❌ NONE FOUND")

    print("\n" + "="*60)
    print("DIAGNOSTIC COMPLETE")
    print("="*60)

if __name__ == "__main__":
    asyncio.run(diagnose())
