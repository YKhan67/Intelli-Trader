import asyncio
import os
import sys
import pandas as pd
import json
from datetime import datetime, timezone
from sqlalchemy import select, and_

# Add project root to path
project_root = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
if project_root not in sys.path:
    sys.path.append(project_root)

from backend.modules.decision import DecisionEngine
from backend.database.postgres import AsyncSessionLocal
from backend.database.models_db import OHLCVBarDB, IndicatorDB
from backend.modules.smc import SMCManager
from backend.database.redis_client import get_redis_client

async def main():
    print("=== FINAL DECISION ENGINE VERIFICATION ===")
    engine = DecisionEngine()
    smc = SMCManager()
    redis = get_redis_client()
    
    pair = "EURUSD"
    timeframe = "H1"
    # Target a known period from previous indicator tests
    target_date = datetime(2026, 6, 9, 22, 0, tzinfo=timezone.utc)
    
    print(f"Targeting Bar: {target_date}...")
    
    async with AsyncSessionLocal() as session:
        # 1. Fetch historical data up to this point
        stmt = select(OHLCVBarDB, IndicatorDB.data).join(
            IndicatorDB, OHLCVBarDB.id == IndicatorDB.bar_id
        ).where(
            and_(OHLCVBarDB.timeframe == timeframe, OHLCVBarDB.timestamp <= target_date)
        ).order_by(OHLCVBarDB.timestamp.desc()).limit(100)
        
        result = await session.execute(stmt)
        rows = result.all()
        
        if not rows:
            print("ERROR: No data found for the target period. Please run ingestion first.")
            return

        rows = rows[::-1] # Chronological
        df = pd.DataFrame([{
            'close': r[0].close, 'high': r[0].high, 'low': r[0].low, 'open': r[0].open, 
            'volume': r[0].volume, 'timestamp': r[0].timestamp
        } for r in rows])
        df.set_index('timestamp', inplace=True)
        latest_indicators = rows[-1][1]
        
        # 2. Get active SMC zones at that time
        active_zones = await smc.get_active_zones(pair, timeframe)

        # 3. RUN PIPELINE
        print("Running Decision Engine pipeline...")
        signal = await engine.run_pipeline(
            pair=pair,
            df=df,
            indicators=latest_indicators,
            active_zones=active_zones,
            account_balance=10000.0,
            open_trades=[],
            trading_mode="normal"
        )
        
        # 4. VERIFY OUTPUT OBJECT
        print("\n--- [VERIFICATION 1] BackendSignal Object ---")
        print(f"Signal ID: {signal.signal_id}")
        print(f"Action: {signal.trade_decision.action}")
        print(f"Confidence: {signal.trade_decision.confidence:.4f}")
        print(f"Reason: {signal.trade_decision.reason}")
        
        # Check all nested models are present
        assert signal.trade_decision is not None, "Missing trade_decision"
        assert signal.regime_result is not None, "Missing regime_result"
        assert signal.sentiment_result is not None, "Missing sentiment_result"
        assert signal.risk_params is not None, "Missing risk_params"
        print("SUCCESS: All signal sub-models populated.")

        # 5. VERIFY REDIS CACHE
        print("\n--- [VERIFICATION 2] Redis Caching ---")
        cache_key = f"signal:{pair}"
        cached_data = await redis.get(cache_key)
        
        if cached_data:
            print(f"Found cached signal in Redis under '{cache_key}'")
            parsed_cache = json.loads(cached_data)
            print(f"Cached Action: {parsed_cache['trade_decision']['action']}")
            assert parsed_cache['pair'] == pair
            print("SUCCESS: Signal correctly cached in Redis.")
        else:
            print("FAIL: Signal not found in Redis!")

    print("\n=== VERIFICATION COMPLETE ===")

if __name__ == "__main__":
    asyncio.run(main())
