from typing import Tuple, Optional
from backend.modules.models import MarketRegimeResult, Direction, Regime

class AlignmentChecker:
    def check_alignment(self, 
                        signal_direction: Direction, 
                        regime_result: MarketRegimeResult) -> Tuple[bool, Optional[str]]:
        """
        Verifies entry timeframe signal aligns with H1 and H4 bias.
        """
        # Get H1 direction from regime
        h1_direction = self._regime_to_direction(regime_result.h1_regime)
        h4_direction = regime_result.h4_bias
        
        # Check alignment
        if signal_direction == h1_direction == h4_direction:
            return True, None
            
        reason = f"Direction misalignment: Signal={signal_direction.value}, H1={h1_direction.value}, H4={h4_direction.value}"
        return False, reason

    def _regime_to_direction(self, regime: Regime) -> Direction:
        if regime == Regime.TRENDING_UP:
            return Direction.LONG
        elif regime == Regime.TRENDING_DOWN:
            return Direction.SHORT
        return Direction.NEUTRAL
