import asyncio
import os
import sys
from datetime import datetime, timezone, timedelta

# Add project root to path
project_root = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
if project_root not in sys.path:
    sys.path.append(project_root)

from backend.modules.sentiment.article_processor import ArticleProcessor
from backend.modules.sentiment.calendar_filter import CalendarFilter
from backend.database.mongo import get_mongo_db
from backend.database.postgres import AsyncSessionLocal
from backend.database.models_db import EconomicCalendarDB
from sqlalchemy import insert, delete

async def part1_sentiment_check():
    print("\n--- [PART 1] Sentiment Accuracy Check ---")
    processor = ArticleProcessor()
    
    print("Processing unscored articles (batch of 100)...")
    processed_count = await processor.process_unscored_articles(limit=100)
    print(f"Processed {processed_count} articles.")
    
    db = get_mongo_db()
    # Fetch some high and low scores to verify
    print("\nVerifying sample scores (Top 5 processed):")
    
    samples = await db.news_articles.find({"is_processed": True}).sort("timestamp", -1).limit(5).to_list(length=5)
    for a in samples:
        indicator = "[+]" if a['sentiment_score'] > 0 else "[-]" if a['sentiment_score'] < 0 else "[ ]"
        print(f" {indicator} Score: {a['sentiment_score']:.2f} | Headline: {a['headline'][:80]}...")

async def part2_calendar_check():
    print("\n--- [PART 2] Calendar Filter Check (NFP Simulation) ---")
    
    # 1. Ensure the NFP event exists in DB for testing
    nfp_time = datetime(2023, 12, 8, 13, 30, tzinfo=timezone.utc)
    async with AsyncSessionLocal() as session:
        # Clean old test NFP if exists
        await session.execute(delete(EconomicCalendarDB).where(EconomicCalendarDB.event_id == "test-nfp-verify"))
        
        await session.execute(insert(EconomicCalendarDB).values({
            "event_id": "test-nfp-verify",
            "timestamp": nfp_time,
            "currency": "USD",
            "event_name": "Non-Farm Payrolls",
            "impact": "HIGH"
        }))
        await session.commit()
    
    from backend.modules.sentiment.calendar_filter import CalendarFilter
    import yaml
    config_path = os.path.join(project_root, "backend/config/sentiment.yaml")
    with open(config_path, "r") as f:
        config = yaml.safe_load(f)
        
    cal_filter = CalendarFilter(config)
    
    # Test 1: 30 minutes exactly before release (Should HARD BLOCK)
    test_time_hard = nfp_time - timedelta(minutes=30)
    pre, hard, post = await cal_filter.check_pre_trade("EURUSD", test_time_hard)
    print(f"Time: {test_time_hard} (30m before NFP)")
    print(f" -> Pre-News Block: {pre} | Hard Block: {hard} | Post-News: {post}")
    assert hard == True, "FAIL: Should have triggered hard block 30m before NFP"

    # Test 2: 90 minutes before (Should PRE-BLOCK but not HARD-BLOCK)
    test_time_pre = nfp_time - timedelta(minutes=90)
    pre, hard, post = await cal_filter.check_pre_trade("EURUSD", test_time_pre)
    print(f"\nTime: {test_time_pre} (90m before NFP)")
    print(f" -> Pre-News Block: {pre} | Hard Block: {hard} | Post-News: {post}")
    assert pre == True and hard == False, "FAIL: Should be pre-blocked but NOT hard-blocked at 90m"

    # Test 3: 5 minutes after (Should be in POST-NEWS WINDOW)
    test_time_post = nfp_time + timedelta(minutes=5)
    pre, hard, post = await cal_filter.check_pre_trade("EURUSD", test_time_post)
    print(f"\nTime: {test_time_post} (5m after NFP)")
    print(f" -> Pre-News Block: {pre} | Hard Block: {hard} | Post-News: {post}")
    assert post == True, "FAIL: Should be in post-news window 5m after release"

    print("\n[PART 2] Success: Calendar filter logic verified.")

async def main():
    await part1_sentiment_check()
    await part2_calendar_check()

if __name__ == "__main__":
    asyncio.run(main())
