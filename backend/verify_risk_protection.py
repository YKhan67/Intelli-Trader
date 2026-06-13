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
from backend.database.redis_client import get_redis_client

async def part1_lot_size_verification():
    print("\n--- [PART 1] Lot Size Verification ---")
    manager = RiskManager()
    
    # Inputs for manual verification:
    balance = 10000.0
    risk_pct = 0.01 # 1% = 100 USD
    sl_pips = 50.0
    pip_value = 10.0 # for 1.0 lot
    # Manual Calculation: 
    # Risk Amount = 10000 * 0.01 = 100 USD
    # Lot Size = 100 / (50 * 10) = 0.20 lots
    
    print(f"Inputs: Balance=${balance}, Risk=1%, SL={sl_pips} pips, PipValue=${pip_value}")
    
    # We mock indicators to force the 50 pip SL
    # current_price = 1.1000, atr = 0.0025 (at 2.0x multiplier = 50 pips)
    indicators = {"close": 1.1000, "atr_14": 0.0025} 
    
    params = await manager.calculate(
        pair="EURUSD", direction=Direction.LONG, strategy=Strategy.TREND_FOLLOW,
        timeframe="H1", account_balance=balance, open_trades=[],
        trading_mode="normal", indicators=indicators
    )
    
    print(f"Calculated Lot Size: {params.lot_size}")
    print(f"Calculated SL Pips: {params.stop_loss_pips:.1f}")
    
    assert abs(params.lot_size - 0.20) < 0.01, f"FAIL: Expected 0.20 lots, got {params.lot_size}"
    print("SUCCESS: Lot size matches manual calculation.")

async def part2_circuit_breaker_verification():
    print("\n--- [PART 2] Daily Halt Verification ---")
    manager = RiskManager()
    redis = get_redis_client()
    
    balance = 10000.0
    # Simulate a 2.5% loss in Redis
    loss_amount = -(balance * 0.025) # -250 USD
    date_str = datetime.now(timezone.utc).strftime('%Y-%m-%d')
    pnl_key = f"pnl:daily:{date_str}"
    
    print(f"Simulating daily P&L of ${loss_amount} (2.5% loss)...")
    await redis.set(pnl_key, str(loss_amount))
    
    # Attempt a calculation - should return daily_halt=True
    params = await manager.calculate(
        pair="EURUSD", direction=Direction.LONG, strategy=Strategy.TREND_FOLLOW,
        timeframe="H1", account_balance=balance, open_trades=[],
        trading_mode="normal", indicators={"close": 1.1000, "atr_14": 0.0020}
    )
    
    print(f"Daily Halt Flag: {params.daily_halt}")
    
    # Verify Redis halt key
    halt_key = await redis.get("circuit:daily")
    print(f"Redis 'circuit:daily' key value: {halt_key}")
    
    assert params.daily_halt == True, "FAIL: Daily halt not triggered in output"
    assert halt_key == "active", "FAIL: Halt flag not set in Redis"
    
    # Cleanup
    await redis.delete(pnl_key)
    await redis.delete("circuit:daily")
    
    print("SUCCESS: Daily halt circuit breaker verified.")

async def main():
    await part1_lot_size_verification()
    await part2_circuit_breaker_verification()

if __name__ == "__main__":
    asyncio.run(main())
