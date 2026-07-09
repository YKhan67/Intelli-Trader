import asyncio
import os
import sys
import logging
from datetime import datetime

# Path resolution
current_dir = os.path.dirname(os.path.abspath(__file__))
project_root = os.path.dirname(current_dir)
if project_root not in sys.path:
    sys.path.insert(0, project_root)

from backend.modules.strategist.shadow_backtester import ShadowBacktester

# Configure Logging
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
    handlers=[logging.StreamHandler(sys.stdout)]
)
logger = logging.getLogger("StrategistSection")

async def run_strategist():
    print("\n" + "="*60)
    print("SECTION 4: THE STRATEGIST (Shadow Backtesting & Immunity)")
    print("="*60)
    
    # Initialize the Strategist (Immune System)
    strategist = ShadowBacktester()
    
    logger.info("Strategist Section starting continuous shadow grid...")
    
    try:
        # Run the shadow backtest loop (default every 1 hour)
        await strategist.run_continuous(interval=3600)
    except asyncio.CancelledError:
        logger.info("Strategist received shutdown signal.")
    except Exception as e:
        logger.error(f"Strategist failed: {e}")
    finally:
        logger.info("Strategist Section offline.")

if __name__ == "__main__":
    try:
        asyncio.run(run_strategist())
    except KeyboardInterrupt:
        pass
