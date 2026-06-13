import asyncio
import os
import sys
from datetime import datetime, timezone

# Add project root to path
project_root = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
if project_root not in sys.path:
    sys.path.append(project_root)

from backend.modules.strategy import StrategySelector
from backend.modules.models import MarketRegimeResult, Regime, Timeframe, Session

async def main():
    print("Initializing Strategy Selector...")
    selector = StrategySelector()
    
    # Mock a regime result
    regime_res = MarketRegimeResult(
        timestamp=datetime.now(timezone.utc),
        pair="EURUSD",
        timeframe=Timeframe.H1,
        regime=Regime.TRENDING_UP,
        confidence=0.85,
        h4_bias="LONG",
        h1_regime=Regime.TRENDING_UP,
        bars_in_regime=5,
        regime_changed=True,
        duration_warning=False,
        indicators_agreed=5
    )
    
    print(f"Selecting strategy for {regime_res.regime} (Confidence: {regime_res.confidence})...")
    
    try:
        decision = await selector.select(
            regime_result=regime_res,
            is_trade_open=False,
            last_trade_result=10.0,
            pair="EURUSD",
            session=Session.LONDON,
            bars_since_regime_start=5,
            bars_since_last_loss=10
        )
        
        print(f"\n--- Strategy Decision ---")
        print(f"Selected Strategy: {decision.strategy}")
        print(f"Switch Occurred: {decision.switch_occurred}")
        print(f"Switch Reason: {decision.switch_reason}")
        print(f"Blocked Reason: {decision.blocked_reason}")
        
        # Test blocked switch (confidence too low)
        print("\nTesting Blocked Switch (Low Confidence)...")
        regime_res.confidence = 0.50
        decision_low_conf = await selector.select(
            regime_result=regime_res,
            is_trade_open=False,
            last_trade_result=None,
            pair="EURUSD",
            session=Session.LONDON,
            bars_since_regime_start=5,
            bars_since_last_loss=10
        )
        print(f"Selected Strategy: {decision_low_conf.strategy}")
        print(f"Blocked Reason: {decision_low_conf.blocked_reason}")

    except Exception as e:
        print(f"Error during strategy selection: {e}")
        import traceback
        traceback.print_exc()

if __name__ == "__main__":
    asyncio.run(main())
