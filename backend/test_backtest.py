import asyncio
import os
import sys
from datetime import datetime, timezone, timedelta

# Add project root to path
project_root = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
if project_root not in sys.path:
    sys.path.append(project_root)

from backend.modules.backtesting import BacktestRunner

async def main():
    print("=== BACKTEST RUNNER INITIALIZATION TEST ===")
    try:
        runner = BacktestRunner()
        print("SUCCESS: BacktestRunner initialized correctly.")
        
        # Define range
        end_date = datetime.now(timezone.utc)
        start_date = end_date - timedelta(days=30)
        pairs = ["EURUSD"]
        
        print(f"Testing runner configuration for {pairs} from {start_date.date()} to {end_date.date()}...")
        # Note: A full run requires real data in DB. 
        # For this scaffold test, we just verify initialization and config loading.
        
        print("\nBacktesting Engine components:")
        print(f" - Data Replay: Ready")
        print(f" - Trade Simulator: Ready (Commission: ${runner.simulator.commission}/lot)")
        print(f" - Monte Carlo: Ready ({runner.mc.simulations} sims)")
        print(f" - Walk Forward: Ready ({runner.wfo.roll_days} day roll)")
        
    except Exception as e:
        print(f"Error during backtest test: {e}")
        import traceback
        traceback.print_exc()

if __name__ == "__main__":
    asyncio.run(main())
