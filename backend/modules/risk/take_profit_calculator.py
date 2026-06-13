from typing import Dict, Any, Tuple, Optional
from backend.modules.models import Strategy, Direction

class TakeProfitCalculator:
    def __init__(self, config: Dict[str, Any]):
        self.multipliers = config.get('atr_tp_multipliers', {})
        self.min_rr = config.get('min_rr_ratio', 1.5)

    def calculate_take_profit(self, 
                              direction: Direction,
                              strategy: Strategy, 
                              entry_price: float, 
                              sl_price: float,
                              atr: float) -> Tuple[float, float, float, float, bool]:
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
        rr_ratio = tp_distance / sl_distance if sl_distance > 0 else 0
        rr_acceptable = rr_ratio >= self.min_rr

        # 3. Partial Exit & Breakeven
        # Partial close at 50% of TP distance
        partial_dist = tp_distance * 0.5
        if direction == Direction.LONG:
            partial_price = entry_price + partial_dist
            # Breakeven is usually entry price
            be_price = entry_price + (2 * 0.0001) # Small buffer
        else:
            partial_price = entry_price - partial_dist
            be_price = entry_price - (2 * 0.0001)

        tp_pips = tp_distance / 0.0001 # Approximation
        
        return tp_price, tp_pips, partial_price, be_price, rr_acceptable
