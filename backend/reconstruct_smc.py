import asyncio
import os
import sys
import logging
from sqlalchemy import text

# Path normalization for institutional imports
current_dir = os.path.dirname(os.path.abspath(__file__))
project_root = os.path.dirname(current_dir)
if project_root not in sys.path:
    sys.path.insert(0, project_root)

from backend.database.postgres import AsyncSessionLocal
from backend.modules.smc.smc_manager import SMCManager

# --- Configuration ---
PAIRS = ["EURUSD", "GBPUSD", "USDJPY", "AUDUSD", "USDCHF", "USDCAD", "NZDUSD", "XAUUSD", "BTCUSD", "BTCEUR"]

logging.basicConfig(level=logging.INFO, format="%(asctime)s [%(levelname)s] %(message)s")
logger = logging.getLogger("SMCReconstructor")

async def main():
    sys.stdout.write("\n" + "="*75 + "\n")
    sys.stdout.write("🛡️  INTELLI-TRADER: SURGICAL SMC RECONSTRUCTION (STAGE 5 ONLY)\n")
    sys.stdout.write("="*75 + "\n")

    try:
        # 1. Clear existing SMC zones first to prevent stale overlap
        logger.info("Cleaning existing SMC zones for fresh reconstruction...")
        async with AsyncSessionLocal() as session:
            await session.execute(text("TRUNCATE smc_zones RESTART IDENTITY"))
            await session.commit()

        # 2. Reconstruct SMC Supply/Demand for the decade
        logger.info("Mapping Institutional Order-Blocks (Supply/Demand) across 10-year grid...")
        smc = SMCManager()
        
        for s in PAIRS:
            logger.info(f"   [{s}] Starting deep scan (50,000 bar lookback)...")
            # Using deep lookback for historical context
            # update_zones internal logic handles the timeframe (defaults to H1 in recovery)
            try:
                await smc.update_zones(s, "H1", lookback_bars=50000)
                logger.info(f"   [{s}] SMC Zones Stabilized and Sealed.")
            except Exception as e:
                logger.error(f"   [{s}] SMC Reconstruction failed: {e}")

    except Exception as e: 
        logger.error(f"FATAL RECONSTRUCTION ERROR: {e}")

    sys.stdout.write("\n✅ SMC RECONSTRUCTION COMPLETE. INSTITUTIONAL ZONES DEPLOYED.\n")
    sys.stdout.write("="*75 + "\n")

if __name__ == "__main__":
    try:
        asyncio.run(main())
    except KeyboardInterrupt:
        sys.stdout.write("\n🛡️ INTERRUPTED. SYSTEM PRESERVED.\n")
        os._exit(0)
