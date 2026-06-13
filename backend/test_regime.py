import asyncio
import os
import sys
import pandas as pd
from datetime import datetime, timezone
from sqlalchemy import select, and_

# Add project root to path
project_root = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
if project_root not in sys.path:
    sys.path.append(project_root)

from backend.modules.regime import RegimeClassifier
from backend.database.postgres import AsyncSessionLocal
from backend.database.models_db import OHLCVBarDB, IndicatorDB

async def run_test_at(classifier, pair, timeframe, target_date, label):
    print(f"\n>>> TESTING: {label} ({target_date})")
    
    async with AsyncSessionLocal() as session:
        # Fetch data up to the target date
        stmt = select(OHLCVBarDB, IndicatorDB.data).join(
            IndicatorDB, OHLCVBarDB.id == IndicatorDB.bar_id
        ).where(
            and_(OHLCVBarDB.timeframe == timeframe, OHLCVBarDB.timestamp <= target_date)
        ).order_by(OHLCVBarDB.timestamp.desc()).limit(100)
        
        result = await session.execute(stmt)
        rows = result.all()
        
        if not rows:
            print(f"  No data found up to {target_date}")
            return

        # Prepare input
        rows = rows[::-1]
        df = pd.DataFrame([{
            'close': r[0].close, 'high': r[0].high, 'low': r[0].low, 'timestamp': r[0].timestamp
        } for r in rows])
        df.set_index('timestamp', inplace=True)
        latest_indicators = rows[-1][1]
        
        try:
            res = await classifier.classify(pair, timeframe, df, latest_indicators)
            print(f"  Result: {res.regime}")
            print(f"  Confidence: {res.confidence:.2f}")
            print(f"  Indicators Agreed: {res.indicators_agreed}")
        except Exception as e:
            print(f"  Error: {e}")

async def main():
    classifier = RegimeClassifier()
    pair = "EURUSD"
    timeframe = "H1"
    
    # 1. Test Ranging Period
    ranging_date = datetime(2026, 5, 29, 10, 0, tzinfo=timezone.utc)
    await run_test_at(classifier, pair, timeframe, ranging_date, "RANGING PERIOD")
    
    # 2. Test Trending Period
    trending_date = datetime(2026, 6, 8, 0, 0, tzinfo=timezone.utc)
    await run_test_at(classifier, pair, timeframe, trending_date, "TRENDING PERIOD")

if __name__ == "__main__":
    asyncio.run(main())
