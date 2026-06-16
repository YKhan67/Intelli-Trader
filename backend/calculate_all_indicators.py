import asyncio
import os
import sys

# Add project root to path
project_root = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
if project_root not in sys.path:
    sys.path.append(project_root)

from backend.modules.indicators import IndicatorCalculator

async def main():
    print("Calculating all indicators for EURUSD H1...")
    calculator = IndicatorCalculator()
    # Process all available bars
    await calculator.calculate_all("EURUSD", "H1", lookback_bars=7000)
    print("DONE.")

if __name__ == "__main__":
    asyncio.run(main())
