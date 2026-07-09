from backend.modules.decision.decision_engine import DecisionEngine
from backend.modules.models import Direction, SignalAction


def test_map_signal_to_risk_direction_for_hold_and_trade_actions():
    assert DecisionEngine._map_signal_to_risk_direction(SignalAction.HOLD) == Direction.NEUTRAL
    assert DecisionEngine._map_signal_to_risk_direction(SignalAction.BUY) == Direction.LONG
    assert DecisionEngine._map_signal_to_risk_direction(SignalAction.SELL) == Direction.SHORT
