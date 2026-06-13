import asyncio
import os
import sys
from datetime import datetime, timezone, time

# Add project root to path
project_root = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
if project_root not in sys.path:
    sys.path.append(project_root)

from backend.modules.timeframe import TimeframeSelector
from backend.modules.timeframe.session_detector import SessionDetector
from backend.modules.models import (
    StrategyDecision, 
    MarketRegimeResult, 
    Regime, 
    Strategy, 
    Timeframe, 
    Session,
    Direction
)

async def test_sessions():
    print("=== SESSION DETECTION & BLOCKING TEST ===")
    detector = SessionDetector()
    selector = TimeframeSelector()
    
    # Test cases: (UTC Hour, Expected Session)
    test_times = [
        (2, Session.ASIAN),
        (10, Session.LONDON),
        (14, Session.OVERLAP),
        (18, Session.NEW_YORK),
        (23, Session.DEAD_ZONE)
    ]
    
    # Mock inputs
    regime_res = MarketRegimeResult(
        timestamp=datetime.now(timezone.utc), pair="EURUSD", timeframe=Timeframe.H1,
        regime=Regime.TRENDING_UP, confidence=0.85, h4_bias=Direction.LONG,
        h1_regime=Regime.TRENDING_UP, bars_in_regime=5, regime_changed=False,
        duration_warning=False, indicators_agreed=5
    )
    
    strategy_dec = StrategyDecision(
        timestamp=datetime.now(timezone.utc), pair="EURUSD", regime=Regime.TRENDING_UP,
        strategy=Strategy.TREND_FOLLOW, timeframe=Timeframe.H1, confidence=0.85,
        session=Session.LONDON, switch_occurred=True, switch_reason="Primary",
        alternative_strategy=None, blocked_reason=None
    )

    for hour, expected in test_times:
        test_dt = datetime(2023, 10, 25, hour, 0, tzinfo=timezone.utc)
        detected = await detector.get_current_session(dt=test_dt)
        print(f"\nTime: {test_dt.strftime('%H:%M')} UTC | Expected: {expected.value} | Detected: {detected.value}")
        
        assert detected == expected, f"Session mismatch at {hour}:00"

        # Check Selector behavior
        selection = await selector.select(
            strategy_decision=strategy_dec,
            regime_result=regime_res,
            current_spread_pips=1.0,
            is_trade_open=False,
            dt=test_dt
        )
        
        if expected == Session.DEAD_ZONE:
            print(f"  DEAD_ZONE check: Selected={selection.selected_timeframe}, BlockReason='{selection.block_reason}'")
            assert selection.block_reason is not None and "blocked" in selection.block_reason.lower()
        else:
            print(f"  Active Session check: Selected={selection.selected_timeframe}, BlockReason='{selection.block_reason}'")
            if selection.block_reason:
                print(f"    Warning: Block reason present: {selection.block_reason}")

    print("\n=== ALL SESSION TESTS PASSED ===")

if __name__ == "__main__":
    asyncio.run(test_sessions())
