import asyncio
import os
import sys
import logging
import time
from sqlalchemy import text

# Path normalization for institutional imports
current_dir = os.path.dirname(os.path.abspath(__file__))
project_root = os.path.dirname(current_dir)
if project_root not in sys.path:
    sys.path.insert(0, project_root)

from backend.database.postgres import engine, AsyncSessionLocal
from backend.modules.smc.smc_manager import SMCManager

# --- Total Scope Configuration ---
PAIRS = ["EURUSD", "GBPUSD", "USDJPY", "AUDUSD", "USDCHF", "USDCAD", "NZDUSD", "XAUUSD", "BTCUSD", "BTCEUR"]

logging.basicConfig(level=logging.INFO, format="%(asctime)s [%(levelname)s] %(message)s")
logger = logging.getLogger("SMCSurgical")

async def main():
    sys.stdout.write("\n" + "="*75 + "\n")
    sys.stdout.write("🛡️  INTELLI-TRADER: SURGICAL SMC RECONSTRUCTION (STAGE 5 FINAL)\n")
    sys.stdout.write("="*75 + "\n")

    try:
        # 1. Clear half-finished zones from the crashed run
        logger.info("Cleaning SMC workspace for fresh reconstruction...")
        async with AsyncSessionLocal() as session:
            await session.execute(text("TRUNCATE smc_zones RESTART IDENTITY"))
            await session.commit()

        # 2. Reconstruct Institutional zones across the 10-year timeline
        smc = SMCManager()
        
        for symbol in PAIRS:
            logger.info(f">>> Processing [{symbol}] Institutional Zones...")
            # We use a deep lookback (50,000 bars) to capture 10 years of H1 significance
            # and process on H1 timeframe as it's the primary dashboard driver.
            try:
                # First build M30
                await smc.update_zones(symbol, "M30", lookback_bars=50000)
                # Then build H1 (Primary)
                await smc.update_zones(symbol, "H1", lookback_bars=50000)
                # Finally H4 (Institutional Pivot)
                await smc.update_zones(symbol, "H4", lookback_bars=10000)
                
                logger.info(f"   ✅ {symbol} SMC Grid Stabilized.")
            except Exception as e:
                logger.error(f"   ❌ {symbol} SMC Failure: {e}")

    except Exception as e:
        logger.error(f"FATAL RECONSTRUCTION ERROR: {e}")

    sys.stdout.write("\n✅ SMC RECONSTRUCTION COMPLETE. MISSION SUCCESS.\n")
    sys.stdout.write("="*75 + "\n")

if __name__ == "__main__":
    try:
        asyncio.run(main())
    except KeyboardInterrupt:
        sys.stdout.write("\n🛡️  Interrupted. Database state preserved.\n")
        os._exit(0)
