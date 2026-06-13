from typing import Tuple, Dict, Any
from backend.modules.models import Regime, Direction

def confirm_macro_bias(h1_regime: Regime, h4_regime: Regime) -> Tuple[Regime, Direction]:
    """
    Ensures H1 and H4 agree on direction.
    Returns (Confirmed Regime, Macro Bias)
    """
    # Define directional bias for H4
    h4_bias = Direction.NEUTRAL
    if h4_regime == Regime.TRENDING_UP:
        h4_bias = Direction.LONG
    elif h4_regime == Regime.TRENDING_DOWN:
        h4_bias = Direction.SHORT

    # Agreement Logic
    if h1_regime == Regime.TRENDING_UP and h4_bias == Direction.LONG:
        return Regime.TRENDING_UP, h4_bias
    elif h1_regime == Regime.TRENDING_DOWN and h4_bias == Direction.SHORT:
        return Regime.TRENDING_DOWN, h4_bias
    
    # If H4 is Ranging, H1 can be anything but we stay cautious
    if h4_regime == Regime.RANGING:
        return h1_regime, Direction.NEUTRAL
        
    # If they completely conflict (H1 Up, H4 Down) -> UNKNOWN
    if (h1_regime == Regime.TRENDING_UP and h4_bias == Direction.SHORT) or \
       (h1_regime == Regime.TRENDING_DOWN and h4_bias == Direction.LONG):
        return Regime.UNKNOWN, h4_bias

    return h1_regime, h4_bias
