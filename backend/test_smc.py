import asyncio
import os
import sys
from collections import Counter

# Add project root to path
project_root = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
if project_root not in sys.path:
    sys.path.append(project_root)

from backend.modules.smc import SMCManager

async def main():
    print("Initializing SMC Manager...")
    manager = SMCManager()
    
    pair = "EURUSD"
    timeframe = "H1"
    lookback = 1000
    
    print(f"Updating SMC zones for {pair} {timeframe} (Lookback: {lookback})...")
    try:
        active_zones = await manager.update_zones(pair, timeframe, lookback_bars=lookback)
        
        # Count zone types
        counts = Counter(z.zone_type for z in active_zones)
        
        print(f"\n--- SMC Detection Summary: {pair} {timeframe} ---")
        print(f"Total Active Zones: {len(active_zones)}")
        for zone_type, count in counts.items():
            print(f"  {zone_type}: {count}")
            
        print("\n--- Sample Active Zones (Verification) ---")
        # Display up to 10 zones
        for zone in active_zones[:10]:
            print(f"Type: {zone.zone_type:12} | High: {zone.price_high:.5f} | Low: {zone.price_low:.5f} | Strength: {zone.strength:.2f}")
            
    except Exception as e:
        print(f"Error during SMC detection: {e}")
        import traceback
        traceback.print_exc()

if __name__ == "__main__":
    asyncio.run(main())
