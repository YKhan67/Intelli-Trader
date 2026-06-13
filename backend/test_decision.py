import asyncio
import os
import sys
from datetime import datetime, timezone

# Add project root to path
project_root = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
if project_root not in sys.path:
    sys.path.append(project_root)

from backend.modules.decision import DecisionEngine
from backend.modules.models import SignalAction

async def main():
    print("Initializing Decision Engine...")
    engine = DecisionEngine()
    
    pair = "EURUSD"
    # To run this test, we need data in the DB.
    # For now, we simulate a call.
    
    print(f"Running Decision Pipeline for {pair}...")
    # This might fail if DB is empty or indicators missing,
    # but the engine is designed to return HOLD on error.
    try:
        # Note: In a real test, we'd need to pass a mock DataFrame and indicators
        # or have real data in DB. 
        # For the sake of proving the module exists and imports work:
        print("Note: This test requires database state. Starting pipeline...")
        # (Assuming data exists from previous prompt runs)
        
        # We'll use a wrapper to handle the missing data gracefully for this test
        from backend.database.postgres import AsyncSessionLocal
        from backend.database.models_db import OHLCVBarDB, IndicatorDB
        from sqlalchemy import select, and_
        import pandas as pd
        
        async with AsyncSessionLocal() as session:
            stmt = select(OHLCVBarDB, IndicatorDB.data).join(
                IndicatorDB, OHLCVBarDB.id == IndicatorDB.bar_id
            ).where(
                and_(OHLCVBarDB.timeframe == "H1")
            ).order_by(OHLCVBarDB.timestamp.desc()).limit(100)
            
            result = await session.execute(stmt)
            rows = result.all()
            
            if not rows:
                print("No data found in DB. Run ingestion and indicators first.")
                return

            rows = rows[::-1]
            df = pd.DataFrame([{
                'close': r[0].close, 'high': r[0].high, 'low': r[0].low, 'timestamp': r[0].timestamp, 'open': r[0].open, 'volume': r[0].volume
            } for r in rows])
            df.set_index('timestamp', inplace=True)
            latest_indicators = rows[-1][1]
            
            from backend.modules.smc import SMCManager
            smc = SMCManager()
            active_zones = await smc.get_active_zones(pair, "H1")

            signal = await engine.run_pipeline(
                pair=pair,
                df=df,
                indicators=latest_indicators,
                active_zones=active_zones,
                account_balance=10000.0,
                open_trades=[],
                trading_mode="normal"
            )
            
            print(f"\n--- Final Decision ---")
            print(f"Action: {signal.trade_decision.action}")
            print(f"Confidence: {signal.trade_decision.confidence:.2f}")
            print(f"Reason: {signal.trade_decision.reason}")
            
    except Exception as e:
        print(f"Error during decision test: {e}")
        import traceback
        traceback.print_exc()

if __name__ == "__main__":
    asyncio.run(main())
