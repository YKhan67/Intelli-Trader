import os
import sys
import asyncio
import pandas as pd

# Add project root to path
project_root = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
if project_root not in sys.path:
    sys.path.append(project_root)

from backend.database.postgres import AsyncSessionLocal
from backend.database.models_db import OHLCVBarDB, IndicatorDB
from sqlalchemy import select, and_

async def find_periods():
    async with AsyncSessionLocal() as session:
        print("Scanning for test periods in EURUSD H1...")
        stmt = select(OHLCVBarDB, IndicatorDB.data).join(
            IndicatorDB, OHLCVBarDB.id == IndicatorDB.bar_id
        ).where(
            and_(OHLCVBarDB.timeframe == "H1")
        ).order_by(OHLCVBarDB.timestamp.asc())
        
        result = await session.execute(stmt)
        rows = result.all()
        
        if not rows:
            print("No H1 data found.")
            return

        trending_up = None
        trending_down = None
        ranging = None

        for bar, data in rows:
            adx = data.get('adx_14')
            ema_200 = data.get('ema_200')
            rsi = data.get('rsi_14')
            
            if not adx or not ema_200 or not rsi: continue

            # TRENDING UP: ADX > 30 and price well above EMA200
            if adx > 30 and bar.close > ema_200 * 1.005 and not trending_up:
                trending_up = bar.timestamp
                print(f"Found Trending Up: {trending_up} (ADX: {adx:.2f})")

            # TRENDING DOWN: ADX > 30 and price well below EMA200
            if adx > 30 and bar.close < ema_200 * 0.995 and not trending_down:
                trending_down = bar.timestamp
                print(f"Found Trending Down: {trending_down} (ADX: {adx:.2f})")

            # RANGING: ADX < 20 and RSI neutral
            if adx < 15 and 45 < rsi < 55 and not ranging:
                ranging = bar.timestamp
                print(f"Found Ranging: {ranging} (ADX: {adx:.2f}, RSI: {rsi:.2f})")
            
            if trending_up and trending_down and ranging:
                break

        print("\nVerification dates identified.")

if __name__ == "__main__":
    asyncio.run(find_periods())
