import asyncio
import sys
import os
from sqlalchemy import text

# Add project root to path
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from backend.database.postgres import engine

async def check():
    print("\n" + "="*50)
    print("🛡️  INTELLI-TRADER: DB STATE AUDIT")
    print("="*50)
    try:
        async with engine.connect() as conn:
            # 1. Pairs
            res = await conn.execute(text("SELECT id, symbol FROM currency_pairs ORDER BY id"))
            pairs = res.all()
            print(f"Currency Pairs found: {[p[1] for p in pairs]}")

            # 2. Counts
            res = await conn.execute(text("""
                SELECT p.symbol, b.timeframe, COUNT(*) 
                FROM ohlcv_bars b
                JOIN currency_pairs p ON b.pair_id = p.id
                GROUP BY p.symbol, b.timeframe
                ORDER BY p.symbol, b.timeframe
            """))
            counts = res.all()
            if not counts:
                print("\nSTATUS: ohlcv_bars table is EMPTY.")
            else:
                print("\nBar Counts in Database:")
                for c in counts:
                    print(f"  {c[0]} {c[1]}: {c[2]} rows")

            # 3. Indicators
            res = await conn.execute(text("""
                SELECT p.symbol, b.timeframe, COUNT(*) 
                FROM indicators i
                JOIN ohlcv_bars b ON i.bar_id = b.id
                JOIN currency_pairs p ON b.pair_id = p.id
                GROUP BY p.symbol, b.timeframe
                ORDER BY p.symbol, b.timeframe
            """))
            icounts = res.all()
            if icounts:
                print("\nIndicator Counts in Database:")
                for ic in icounts:
                    print(f"  {ic[0]} {ic[1]}: {ic[2]} indicators")

    except Exception as e:
        print(f"ERROR: {e}")

if __name__ == "__main__":
    asyncio.run(check())
