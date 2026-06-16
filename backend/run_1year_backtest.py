import asyncio
import os
import sys
from datetime import datetime, timezone

# Add project root to path
project_root = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
if project_root not in sys.path:
    sys.path.append(project_root)

from backend.modules.backtesting import BacktestRunner

async def main():
    print("=== STARTING 1-YEAR BACKTEST (EURUSD H1 2022) ===")
    runner = BacktestRunner()
    
    # 2022 Data Range
    start_date = datetime(2022, 1, 1, tzinfo=timezone.utc)
    end_date = datetime(2022, 12, 31, 23, 59, tzinfo=timezone.utc)
    
    results = await runner.run_full_backtest(
        start_date=start_date,
        end_date=end_date,
        pairs=["EURUSD"],
        starting_balance=10000.0
    )
    
    print("\n" + "="*40)
    print("        BACKTEST RESULTS REPORT")
    print("="*40)
    
    metrics = results['metrics']
    print(f"Total Trades:     {results['trade_count']}")
    print(f"Win Rate:         {metrics.get('win_rate', 0):.2%}")
    print(f"Net PnL:         ${metrics.get('net_pnl', 0):,.2f}")
    print(f"Profit Factor:    {metrics.get('profit_factor', 0)}")
    print(f"Max Drawdown:     {metrics.get('max_drawdown_pct', 0)}%")
    print(f"Sharpe Ratio:     {metrics.get('sharpe_ratio', 0)}")
    
    print("\nMonte Carlo Analysis:")
    mc = results['monte_carlo']
    print(f"  Worst Case DD (95%): {mc.get('worst_case_drawdown_95', 0)}%")
    
    print("\nRecommendation:")
    print(f"  STATUS: {results['recommendation']}")
    if results['reasons']:
        for r in results['reasons']:
            print(f"  - {r}")
            
    print("="*40)

if __name__ == "__main__":
    asyncio.run(main())
