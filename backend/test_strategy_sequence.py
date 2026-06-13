import asyncio
import os
import sys
from datetime import datetime, timezone

# Add project root to path
project_root = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
if project_root not in sys.path:
    sys.path.append(project_root)

from backend.modules.strategy import StrategySelector
from backend.modules.models import MarketRegimeResult, Regime, Timeframe, Session, Strategy

async def main():
    print("=== STRATEGY SELECTOR SEQUENCE SIMULATION ===")
    selector = StrategySelector()
    pair = "EURUSD"
    
    # 1. Start with TRENDING_UP (Confirmed regime > 3 bars)
    print("\n--- STEP 1: Trending Up (Clean State) ---")
    regime_up = MarketRegimeResult(
        timestamp=datetime.now(timezone.utc), pair=pair, timeframe=Timeframe.H1,
        regime=Regime.TRENDING_UP, confidence=0.85, h4_bias="LONG",
        h1_regime=Regime.TRENDING_UP, bars_in_regime=5, regime_changed=False,
        duration_warning=False, indicators_agreed=5
    )
    
    decision1 = await selector.select(
        regime_result=regime_up, is_trade_open=False, last_trade_result=None,
        pair=pair, session=Session.LONDON, bars_since_regime_start=5, bars_since_last_loss=10
    )
    print(f"  Regime: {regime_up.regime} -> Strategy: {decision1.strategy}")
    assert decision1.strategy == Strategy.TREND_FOLLOW

    # 2. Simulate Trade Open (Block switch)
    print("\n--- STEP 2: Regime Change while Trade Open ---")
    regime_range = MarketRegimeResult(
        timestamp=datetime.now(timezone.utc), pair=pair, timeframe=Timeframe.H1,
        regime=Regime.RANGING, confidence=0.80, h4_bias="NEUTRAL",
        h1_regime=Regime.RANGING, bars_in_regime=1, regime_changed=True,
        duration_warning=False, indicators_agreed=4
    )
    
    decision2 = await selector.select(
        regime_result=regime_range, is_trade_open=True, last_trade_result=None,
        pair=pair, session=Session.LONDON, bars_since_regime_start=1, bars_since_last_loss=10
    )
    print(f"  Regime: {regime_range.regime} (Attempt while trade open)")
    print(f"  Result: {decision2.strategy} | Blocked: {decision2.blocked_reason}")
    assert decision2.strategy == Strategy.SKIP
    assert "Trade is currently open" in decision2.blocked_reason

    # 3. Simulate Recent Loss (Higher confidence requirement)
    print("\n--- STEP 3: Attempt Switch After Loss (Medium Confidence) ---")
    decision3 = await selector.select(
        regime_result=regime_range, is_trade_open=False, last_trade_result=-50.0,
        pair=pair, session=Session.LONDON, bars_since_regime_start=10, bars_since_last_loss=2
    )
    print(f"  Regime: {regime_range.regime} (Confidence: {regime_range.confidence:.2f})")
    print(f"  Result: {decision3.strategy} | Blocked: {decision3.blocked_reason}")
    assert "Higher confidence" in decision3.blocked_reason or "Cooldown" in decision3.blocked_reason

    # 4. Successful Switch (Loss cooldown over + High confidence)
    print("\n--- STEP 4: Successful Switch to Mean Reversion ---")
    regime_range.confidence = 0.85
    decision4 = await selector.select(
        regime_result=regime_range, is_trade_open=False, last_trade_result=-50.0,
        pair=pair, session=Session.LONDON, bars_since_regime_start=10, bars_since_last_loss=10
    )
    print(f"  Regime: {regime_range.regime} (Confidence: {regime_range.confidence:.2f})")
    print(f"  Result: {decision4.strategy} | Reason: {decision4.switch_reason}")
    assert decision4.strategy == Strategy.MEAN_REVERSION

    print("\n=== SIMULATION COMPLETE: ALL RULES VERIFIED ===")

if __name__ == "__main__":
    asyncio.run(main())
