import asyncio
import sys
import os

# Path normalization
current_dir = os.path.dirname(os.path.abspath(__file__))
project_root = os.path.dirname(current_dir)
if project_root not in sys.path:
    sys.path.insert(0, project_root)

from backend.database.postgres import engine
from sqlalchemy import text

async def run_purge():
    """
    LOGICAL FIX: Institutional Truncate Protocol.
    Replaces slow row-based DELETE with near-instant TRUNCATE.
    """
    print("\n" + "="*60)
    print("🛡️  INTELLI-TRADER: INSTITUTIONAL MEMORY PURGE")
    print("="*60)
    
    try:
        async with engine.begin() as conn:
            # 1. Use TRUNCATE with CASCADE to handle all relationships at once
            # This is 1000x faster than DELETE for millions of rows.
            print("   [ACTION] Executing Atomic Truncate on all tables...")
            await conn.execute(text("TRUNCATE trades, regime_history, model_feedback, indicators, ohlcv_bars RESTART IDENTITY CASCADE"))
            
        print("\n✅ INSTANT PURGE COMPLETE.")
        print("🚀 DATABASE IS NOW 100% CLEAN AND READY FOR RECOVERY MASTER.")
        
    except Exception as e:
        print(f"\n❌ CRITICAL PURGE FAILURE: {e}")

if __name__ == "__main__":
    asyncio.run(run_purge())
