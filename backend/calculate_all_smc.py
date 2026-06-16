import asyncio
import os
import sys

# Add project root to path
project_root = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
if project_root not in sys.path:
    sys.path.append(project_root)

from backend.modules.smc import SMCManager

async def main():
    print("Detecting all SMC zones for EURUSD H1...")
    manager = SMCManager()
    # Process history
    # The current update_zones limits to 200, so I'll create a new method for bulk update
    # or just loop through history.
    # For now, let's just run it for a large lookback.
    await manager.update_zones("EURUSD", "H1", lookback_bars=7000)
    print("DONE.")

if __name__ == "__main__":
    asyncio.run(main())
