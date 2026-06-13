import os
import sys
import asyncio
from datetime import datetime, timezone

# Add project root to path
project_root = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
if project_root not in sys.path:
    sys.path.append(project_root)

from backend.modules.ingestion import IngestionManager
from backend.modules.indicators import IndicatorCalculator
from backend.modules.smc import SMCManager

async def run_live_cycle():
    """
    Simulates a single real-time cycle: 
    Data -> Indicators -> SMC -> Decision (next module)
    """
    print("=== STARTING LIVE CYCLE ===")
    
    manager = IngestionManager()
    indicators = IndicatorCalculator()
    smc = SMCManager()
    
    pair = "EURUSD"
    timeframe = "H1"
    
    # 1. Update Price Data (Real-time polling)
    print(f"\n[1/3] Fetching latest price data for {pair}...")
    # In live mode, we usually fetch just the most recent bars
    await manager.price_dl.download_historical() 
    
    # 2. Update Indicators
    print(f"\n[2/3] Calculating indicators...")
    await indicators.calculate_all(pair, timeframe, lookback_bars=300)
    
    # 3. Update SMC Zones
    print(f"\n[3/3] Detecting SMC structure and zones...")
    active_zones = await smc.update_zones(pair, timeframe, lookback_bars=300)
    
    print(f"\nCycle complete. {len(active_zones)} active zones ready for decision engine.")
    print("==========================")

if __name__ == "__main__":
    asyncio.run(run_live_cycle())
