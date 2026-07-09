import logging
from typing import Dict, Any, Tuple, Optional
from backend.modules.models import Strategy, Direction

logger = logging.getLogger("TPCalc")

class TakeProfitCalculator:
    def __init__(self, config: Dict[str, Any]):
        self.multipliers = config.get('atr_tp_multipliers', {})
        self.min_rr = config.get('min_rr_ratio', 1.5)

    def calculate_take_profit(self, 
                              direction: Direction,
                              strategy: Strategy, 
                              entry_price: float, 
                              sl_price: float,
                              atr: float,
                              pip_size: float = 0.0001) -> Tuple[float, float, float, float, bool]:
        """
        Calculates ATR-based take profit and partial exit levels.
        Returns (tp_price, tp_pips, partial_price, be_price, rr_acceptable)
        """
        # 1. Base ATR Take Profit
        multiplier = self.multipliers.get(strategy, 3.0)
        tp_distance = atr * multiplier
        
        sl_distance = abs(entry_price - sl_price)
        
        if direction == Direction.LONG:
            tp_price = entry_price + tp_distance
        else:
            tp_price = entry_price - tp_distance

        # 2. Risk:Reward Ratio Check
        # Institutional safety: if sl_distance is 0 or extremely small, block trade
        if sl_distance < (pip_size * 2):
            logger.warning(f"Rejecting trade: Stop Loss too tight ({sl_distance/pip_size:.1f} pips)")
            return 0, 0, 0, 0, False

        rr_ratio = tp_distance / sl_distance
        rr_acceptable = rr_ratio >= self.min_rr

        # 3. Partial Exit & Breakeven
        # Partial close at 50% of TP distance
        partial_dist = tp_distance * 0.5
        if direction == Direction.LONG:
            partial_price = entry_price + partial_dist
            be_price = entry_price + (2 * pip_size) # Institutional buffer
        else:
            partial_price = entry_price - partial_dist
            be_price = entry_price - (2 * pip_size)

        tp_pips = tp_distance / pip_size
        
        return tp_price, tp_pips, partial_price, be_price, rr_acceptable
