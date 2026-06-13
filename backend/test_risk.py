import asyncio
import os
import sys
from datetime import datetime, timezone

# Add project root to path
project_root = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
if project_root not in sys.path:
    sys.path.append(project_root)

from backend.modules.risk import RiskManager
from backend.modules.models import Strategy, Direction

async def main():
    print("=== RISK MANAGER TEST ===")
    manager = RiskManager()
    
    # 1. Mock inputs
    pair = "EURUSD"
    direction = Direction.LONG
    strategy = Strategy.TREND_FOLLOW
    timeframe = "H1"
    balance = 10000.0
    open_trades = [] # No open trades
    mode = "normal"
    
    # Latest indicators
    indicators = {
        "close": 1.1000,
        "atr_14": 0.0020 # 20 pips
    }
    
    print(f"Calculating risk for {pair} {direction.value} {strategy.value}...")
    
    try:
        # Case A: Normal trade
        params = await manager.calculate(
            pair=pair,
            direction=direction,
            strategy=strategy,
            timeframe=timeframe,
            account_balance=balance,
            open_trades=open_trades,
            trading_mode=mode,
            indicators=indicators
        )
        
        print(f"\n--- Result: Normal Trade ---")
        print(f"Lot Size: {params.lot_size}")
        print(f"SL Price: {params.stop_loss_price:.5f} ({params.stop_loss_pips:.1f} pips)")
        print(f"TP Price: {params.take_profit_price:.5f} ({params.take_profit_pips:.1f} pips)")
        print(f"R:R Ratio: {params.rr_ratio:.2f}")
        print(f"Risk Score: {params.risk_score:.2f}")
        
        # Case B: Correlated Trade
        print("\nTesting Correlated Exposure (GBPUSD already open)...")
        open_trades = [{"pair": "GBPUSD"}]
        params_corr = await manager.calculate(
            pair=pair,
            direction=direction,
            strategy=strategy,
            timeframe=timeframe,
            account_balance=balance,
            open_trades=open_trades,
            trading_mode=mode,
            indicators=indicators
        )
        print(f"Lot Size (Correlated): {params_corr.lot_size}")
        print(f"Correlated Exposure Flag: {params_corr.correlated_exposure}")

        # Case C: Extreme Volatility
        print("\nTesting High Volatility...")
        indicators['atr_14'] = 0.0100 # 100 pips ATR
        params_vol = await manager.calculate(
            pair=pair,
            direction=direction,
            strategy=strategy,
            timeframe=timeframe,
            account_balance=balance,
            open_trades=[],
            trading_mode=mode,
            indicators=indicators
        )
        print(f"Lot Size (High Vol): {params_vol.lot_size}")
        print(f"Risk Score: {params_vol.risk_score:.2f}")

    except Exception as e:
        print(f"Error during risk calculation: {e}")
        import traceback
        traceback.print_exc()

if __name__ == "__main__":
    asyncio.run(main())
