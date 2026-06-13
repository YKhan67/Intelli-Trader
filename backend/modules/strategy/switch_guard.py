from typing import Tuple, Optional, Dict, Any
from backend.modules.models import Strategy, MarketRegimeResult

class SwitchGuard:
    def __init__(self, config: Dict[str, Any]):
        self.config = config.get('thresholds', {})

    def can_switch(self, 
                   current_strategy: Strategy,
                   regime_result: MarketRegimeResult, 
                   is_trade_open: bool, 
                   last_trade_result: Optional[float],
                   bars_since_regime_start: int,
                   bars_since_last_loss: int) -> Tuple[bool, Optional[str]]:
        """
        Enforces strategy switching rules.
        Returns (is_blocked, reason)
        """
        
        # 1. Never switch while a trade is open
        if is_trade_open:
            return True, "Trade is currently open. Finish trade before switching strategy."

        # 2. Minimum bar confirmation for new regime
        min_bars = self.config.get('switch_bars_confirmation', 3)
        if bars_since_regime_start < min_bars:
            return True, f"New regime only active for {bars_since_regime_start} bars. Need {min_bars} for confirmation."

        # 3. Confidence threshold
        base_threshold = self.config.get('switch_confidence', 0.75)
        if regime_result.confidence < base_threshold:
            return True, f"Regime confidence {regime_result.confidence:.2f} is below switch threshold {base_threshold}."

        # 4. After a losing trade, higher confidence required
        if last_trade_result is not None and last_trade_result < 0:
            loss_threshold = self.config.get('post_loss_confidence', 0.80)
            if regime_result.confidence < loss_threshold:
                return True, f"Higher confidence ({loss_threshold}) required after a loss. Current: {regime_result.confidence:.2f}."
            
            # Cooldown bars after a loss
            cooldown = self.config.get('loss_cooldown_bars', 5)
            if bars_since_last_loss < cooldown:
                return True, f"Cooldown period after loss. {bars_since_last_loss}/{cooldown} bars elapsed."

        return False, None
