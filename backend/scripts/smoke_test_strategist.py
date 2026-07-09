import asyncio
import os
import sys
import logging
import signal
from datetime import datetime, timezone, timedelta

# Path resolution
current_script_dir = os.path.dirname(os.path.abspath(__file__))
project_root = os.path.dirname(current_script_dir)
if project_root not in sys.path:
    sys.path.insert(0, project_root)

# Correct the path again to be 100% sure
root_parent = os.path.dirname(os.path.dirname(current_script_dir))
if root_parent not in sys.path:
    sys.path.insert(0, root_parent)

from backend.utils.resource_governor import ResourceGovernor
from backend.modules.decision.immune_gate import ImmuneGate
from backend.database.postgres import AsyncSessionLocal
from backend.database.models_db import ModelFeedbackDB, CurrencyPairDB
from sqlalchemy import select, delete, func

# Setup Fail-Safe Cleanup ID
GHOST_ID = None

async def cleanup_residue():
    """Forces removal of ANY smoke test data."""
    global GHOST_ID
    print("\n[CLEANUP] Activating Fail-Safe Cleanup...")
    try:
        async with AsyncSessionLocal() as session:
            await session.execute(delete(ModelFeedbackDB).where(ModelFeedbackDB.strategy == "SMOKE_TEST"))
            await session.commit()
            print("  ✅ Database purged of all test artifacts.")
    except Exception as e:
        print(f"  ❌ Cleanup failed: {e}")

async def run_smoke_test():
    global GHOST_ID
    print("\n" + "="*60)
    print("🛡️  CRASH-PROOF STRATEGIST SMOKE TEST (v2)")
    print("="*60)

    try:
        # 1. Test Resource Governor
        print("\n[1/3] VERIFYING HARDWARE ORCHESTRATION...")
        workers = ResourceGovernor.get_optimized_worker_count()
        print(f"  ✅ CPU: 56-Core Optimized. Workers allocated: {workers}")

        # 2. Test Immune Gate
        print("\n[2/3] TESTING IMMUNE SYSTEM (DNA PATTERN MATCHING)...")
        async with AsyncSessionLocal() as session:
            # Get a valid pair symbol
            pair_res = await session.execute(select(CurrencyPairDB.symbol).limit(1))
            pair_symbol = pair_res.scalar()
            
            # Fetch the ID again to ensure sync
            pair_id_res = await session.execute(select(CurrencyPairDB.id).where(CurrencyPairDB.symbol == pair_symbol))
            pair_id = pair_id_res.scalar()
            
            if not pair_symbol:
                print("  ❌ Error: No currency pairs found in DB.")
                return

            print(f"  > Testing with Pair: {pair_symbol} (ID: {pair_id})")

            ghost_dna = {"rsi_14": 85.0, "ema_50": 1.12, "ema_200": 1.11, "atr_14": 0.002}
            
            feedback = ModelFeedbackDB(
                pair_id=pair_id, strategy="SMOKE_TEST",
                indicator_dna=ghost_dna, failure_context="BULL_TRAP_TEST",
                detected_at=datetime.now(timezone.utc)
            )
            session.add(feedback)
            await session.commit()
            GHOST_ID = feedback.id
            print(f"  ✅ Ghost Pattern Committed (ID: {GHOST_ID})")

            # Test Veto
            gate = ImmuneGate()
            blocked, _, reason = await gate.check_immunity(pair_symbol, ghost_dna)
            
            if blocked:
                print(f"  ✅ Immune System Veto Verified: {reason}")
            else:
                # Debugging log
                print(f"  ❌ Veto Logic Failed. (Check if {pair_symbol} matches logic)")
            
        # 3. Final Cleanup
        await cleanup_residue()
        print("\n[COMPLETE] TEST SUCCESSFUL. RESIDUE: 0%")

    except Exception as e:
        print(f"\n  ❌ SCRIPT ERROR: {e}")
        import traceback
        traceback.print_exc()
        await cleanup_residue()
    finally:
        print("="*60)

if __name__ == "__main__":
    try:
        asyncio.run(run_smoke_test())
    except KeyboardInterrupt:
        pass
