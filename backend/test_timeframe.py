import asyncio
import os
import sys
from datetime import datetime, timezone

# Add project root to path
project_root = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
if project_root not in sys.path:
    sys.path.append(project_root)

from backend.modules.timeframe import TimeframeSelector
from backend.modules.models import (
    StrategyDecision, 
    MarketRegimeResult, 
    Regime, 
    Strategy, 
    Timeframe, 
    Session,
    Direction
)

async def main():
    print("=== TIMEFRAME SELECTOR TEST ===")
    selector = TimeframeSelector()
    
    # 1. Mock inputs
    regime_res = MarketRegimeResult(
        timestamp=datetime.now(timezone.utc),
        pair="EURUSD",
        timeframe=Timeframe.H1,
        regime=Regime.TRENDING_UP,
        confidence=0.85,
        h4_bias=Direction.LONG,
        h1_regime=Regime.TRENDING_UP,
        bars_in_regime=5,
        regime_changed=False,
        duration_warning=False,
        indicators_agreed=5
    )
    
    strategy_dec = StrategyDecision(
        timestamp=datetime.now(timezone.utc),
        pair="EURUSD",
        regime=Regime.TRENDING_UP,
        strategy=Strategy.TREND_FOLLOW,
        timeframe=Timeframe.H1,
        confidence=0.85,
        session=Session.LONDON,
        switch_occurred=True,
        switch_reason="Primary",
        alternative_strategy=None,
        blocked_reason=None
    )

    london_time = datetime(2023, 10, 25, 10, 0, tzinfo=timezone.utc)
    print(f"Testing selection for {strategy_dec.strategy} in {regime_res.regime} at {london_time}...")
    
    try:
        # Case A: Normal conditions
        selection = await selector.select(
            strategy_decision=strategy_dec,
            regime_result=regime_res,
            current_spread_pips=1.2,
            is_trade_open=False,
            dt=london_time
        )
        print(f"\n--- Result: Normal ---")
        print(f"Selected TF: {selection.selected_timeframe}")
        print(f"Session: {selection.session}")
        print(f"Block Reason: {selection.block_reason}")
        print(f"Scores: {selection.score_breakdown}")
        
        # Case B: High Spread
        print("\nTesting High Spread (Should move up TF)...")
        selection_high_spread = await selector.select(
            strategy_decision=strategy_dec,
            regime_result=regime_res,
            current_spread_pips=4.0, # High for M5, M15, M30
            is_trade_open=False,
            dt=london_time
        )
        print(f"Selected TF: {selection_high_spread.selected_timeframe}")
        print(f"Block Reason: {selection_high_spread.block_reason}")

        # Case C: Locked TF (Trade Open)
        print("\nTesting Locked TF (Trade Open)...")
        # First select H1
        await selector.select(strategy_dec, regime_res, 1.0, False, dt=london_time)
        # Now simulate trade open
        selection_locked = await selector.select(
            strategy_decision=strategy_dec,
            regime_result=regime_res,
            current_spread_pips=10.0, # Even with huge spread
            is_trade_open=True,
            dt=london_time
        )
        print(f"Selected TF: {selection_locked.selected_timeframe}")
        print(f"Block Reason: {selection_locked.block_reason}")

        # Case D: Asian Session (Penalty & Block)
        print("\nTesting Asian Session (M5 should be blocked/penalized)...")
        asian_time = datetime(2023, 10, 25, 2, 0, tzinfo=timezone.utc)
        strategy_dec.strategy = Strategy.SCALP # SCALP usually prefers M5
        selection_asian = await selector.select(
            strategy_decision=strategy_dec,
            regime_result=regime_res,
            current_spread_pips=1.0,
            is_trade_open=False,
            dt=asian_time
        )
        print(f"Session: {selection_asian.session}")
        print(f"Selected TF: {selection_asian.selected_timeframe}")
        print(f"M5 Score: {selection_asian.score_breakdown.get('M5')}")
        print(f"Scores: {selection_asian.score_breakdown}")

    except Exception as e:
        print(f"Error during timeframe selection: {e}")
        import traceback
        traceback.print_exc()

if __name__ == "__main__":
    asyncio.run(main())
