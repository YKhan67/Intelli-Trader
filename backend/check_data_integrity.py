import asyncio
from sqlalchemy import text
from backend.database.postgres import engine

async def check():
    print(">>> CHECKING DATA INTEGRITY...")
    async with engine.connect() as conn:
        # 1. Check Currency Pairs
        res = await conn.execute(text("SELECT id, symbol FROM currency_pairs ORDER BY id"))
        pairs = res.all()
        print(f"\n[1] Currency Pairs in DB ({len(pairs)}):")
        for p in pairs:
            print(f"    ID: {p[0]}, Symbol: {p[1]}")

        # 2. Check Bar Counts per pair and timeframe
        res = await conn.execute(text("""
            SELECT p.symbol, b.timeframe, COUNT(*) 
            FROM ohlcv_bars b
            JOIN currency_pairs p ON b.pair_id = p.id
            GROUP BY p.symbol, b.timeframe
            ORDER BY p.symbol, b.timeframe
        """))
        counts = res.all()
        print(f"\n[2] Bar Counts in DB:")
        if not counts:
            print("    EMPTY: No bars found in ohlcv_bars.")
        for c in counts:
            print(f"    {c[0]} {c[1]}: {c[2]} bars")

if __name__ == "__main__":
    asyncio.run(check())
