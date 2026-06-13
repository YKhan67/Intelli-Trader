import asyncio
import os
import sys
import pandas as pd

# Add project root to path
project_root = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
if project_root not in sys.path:
    sys.path.append(project_root)

from backend.modules.indicators import IndicatorCalculator
from backend.database.postgres import AsyncSessionLocal
from backend.database.models_db import OHLCVBarDB, IndicatorDB, CurrencyPairDB
from sqlalchemy import select, and_

async def verify_indicators(pair, timeframe, limit=5):
    """Fetches and prints the calculated indicators from the DB."""
    async with AsyncSessionLocal() as session:
        # Get the latest bars and their indicators
        stmt = select(OHLCVBarDB, IndicatorDB.data).join(
            IndicatorDB, OHLCVBarDB.id == IndicatorDB.bar_id
        ).where(
            and_(OHLCVBarDB.timeframe == timeframe)
        ).order_by(OHLCVBarDB.timestamp.desc()).limit(limit)
        
        result = await session.execute(stmt)
        rows = result.all()
        
        if not rows:
            print("No indicators found in database for verification.")
            return

        print(f"\n--- Verification: Latest {len(rows)} bars for {pair} {timeframe} ---")
        for bar, data in rows:
            print(f"Timestamp: {bar.timestamp}")
            print(f"  Price (C): {bar.close:.5f}")
            # Print a subset of indicators to verify
            sample_keys = ['ema_50', 'rsi_14', 'macd_line', 'bb_middle', 'atr_14', 'pivot']
            line = "  "
            for k in sample_keys:
                val = data.get(k)
                v_str = f"{val:.5f}" if val is not None else "NaN"
                line += f"{k}: {v_str} | "
            print(line)

async def main():
    print("Initializing Indicator Calculator...")
    calculator = IndicatorCalculator()
    
    pair = "EURUSD"
    timeframe = "H1"
    lookback = 500
    
    print(f"Calculating indicators for {pair} {timeframe} (Lookback: {lookback})...")
    try:
        report = await calculator.calculate_all(pair, timeframe, lookback_bars=lookback)
        if report:
            print("Calculation successful.")
            await verify_indicators(pair, timeframe)
        else:
            print("Calculation skipped or failed.")
    except Exception as e:
        print(f"Error during calculation: {e}")
        import traceback
        traceback.print_exc()

if __name__ == "__main__":
    asyncio.run(main())
