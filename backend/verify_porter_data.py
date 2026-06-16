import os
import sys
import asyncio
from datetime import datetime, timezone

# Add project root to path
project_root = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
if project_root not in sys.path:
    sys.path.append(project_root)

from backend.database.postgres import AsyncSessionLocal
from backend.database.models_db import OHLCVBarDB, CurrencyPairDB
from sqlalchemy import select, func

async def verify_data_integrity():
    print("=== DATA PORTER INTEGRITY VERIFICATION ===")
    
    async with AsyncSessionLocal() as session:
        # 1. Check if we have currency pairs seeded
        pair_stmt = select(CurrencyPairDB)
        pair_res = await session.execute(pair_stmt)
        pairs = pair_res.scalars().all()
        
        if not pairs:
            print("ERROR: No currency pairs found in 'currency_pairs' table. Please run seed.py first.")
            return

        print(f"Found {len(pairs)} currency pairs in database.")

        # 2. Check OHLCV table status
        count_stmt = select(func.count(OHLCVBarDB.id))
        total_bars = (await session.execute(count_stmt)).scalar()
        print(f"Total OHLCV Bars: {total_bars}")

        if total_bars == 0:
            print("WARNING: 'ohlcv_bars' table is empty. Your Data Porter hasn't uploaded anything yet.")
            return

        # 3. Sample check for format
        sample_stmt = select(OHLCVBarDB).order_by(OHLCVBarDB.timestamp.desc()).limit(5)
        samples = (await session.execute(sample_stmt)).scalars().all()

        print("\n--- Sample Data Verification ---")
        for bar in samples:
            pair_name = next((p.symbol for p in pairs if p.id == bar.pair_id), f"ID:{bar.pair_id}")
            print(f"[{bar.timestamp}] Pair: {pair_name:7} | TF: {bar.timeframe:4} | C: {bar.close:.5f} | V: {bar.volume}")
            
            # Validation checks
            errors = []
            if bar.timestamp.tzinfo is None: errors.append("Timestamp is not timezone-aware")
            if bar.open <= 0 or bar.high <= 0 or bar.low <= 0 or bar.close <= 0: errors.append("Invalid price level (<=0)")
            if not isinstance(bar.open, float): errors.append("Price is not a float")
            
            if errors:
                print(f"  !! ERRORS: {', '.join(errors)}")
            else:
                print("  Format: OK")

        # 4. Check for timeframe consistency
        tf_stmt = select(OHLCVBarDB.timeframe, func.count(OHLCVBarDB.id)).group_by(OHLCVBarDB.timeframe)
        tf_counts = (await session.execute(tf_stmt)).all()
        print("\n--- Timeframe Distribution ---")
        for tf, count in tf_counts:
            print(f"  {tf}: {count} bars")

    print("\nVerification complete.")

if __name__ == "__main__":
    asyncio.run(verify_data_integrity())
