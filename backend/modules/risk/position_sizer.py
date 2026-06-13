from typing import Dict, Any, Optional
import math
import logging

logger = logging.getLogger("PositionSizer")

class PositionSizer:
    def __init__(self, config: Dict[str, Any], pairs_config: Dict[str, Any]):
        self.config = config
        self.pairs_config = {p['symbol']: p for p in pairs_config['pairs']}

    def calculate_lot_size(self, 
                          pair: str, 
                          account_balance: float, 
                          stop_loss_pips: float, 
                          win_rate: float,
                          trading_mode: str = "normal",
                          consecutive_losses: int = 0,
                          consecutive_wins: int = 0) -> float:
        """
        Calculates position size in lots.
        """
        if stop_loss_pips <= 0:
            return 0.0

        pair_info = self.pairs_config.get(pair)
        if not pair_info:
            logger.error(f"Pair {pair} not found in pairs config")
            return 0.0

        # 1. Base Risk Amount
        risk_pct = self.config.get('max_risk_per_trade', 0.01)
        
        # 2. Kelly Criterion Adjustment (Simplified)
        # Kelly % = W - [(1 - W) / R] 
        # For simplicity, we use win_rate to scale the base risk
        # if win_rate > 0.5, we might increase risk slightly, but here we just use it for Kelly-like adjustment
        # We'll use a conservative fractional Kelly (e.g., 0.2 of Kelly)
        # For now, let's just use it as a simple multiplier if win_rate is known
        if win_rate > 0:
            kelly_adj = max(0.5, min(1.5, win_rate / 0.5))
            risk_pct *= kelly_adj

        risk_amount = account_balance * risk_pct

        # 3. Mode Multipliers
        mode_multipliers = self.config.get('mode_multipliers', {})
        multiplier = mode_multipliers.get(trading_mode, 1.0)
        risk_amount *= multiplier

        # 4. Streak Adjustments
        streak_cfg = self.config.get('streak_adjustments', {})
        if consecutive_losses >= streak_cfg.get('loss_streak_threshold', 3):
            risk_amount *= streak_cfg.get('loss_reduction', 0.5)
            logger.info(f"Reducing risk by 50% due to {consecutive_losses} consecutive losses")
        elif consecutive_wins >= streak_cfg.get('win_streak_threshold', 5):
            risk_amount *= streak_cfg.get('win_increase', 1.25)
            logger.info(f"Increasing risk by 25% due to {consecutive_wins} consecutive wins")

        # 5. Pip Value Calculation
        # risk_amount = lot_size * stop_loss_pips * pip_value_per_lot
        # lot_size = risk_amount / (stop_loss_pips * pip_value_per_lot)
        pip_value = pair_info.get('pip_value', 10.0)
        
        if stop_loss_pips * pip_value == 0:
            return 0.0
            
        lot_size = risk_amount / (stop_loss_pips * pip_value)

        # 6. Apply Limits
        min_lot = pair_info.get('min_lot', 0.01)
        max_lot = pair_info.get('max_lot', 10.0)
        lot_step = pair_info.get('lot_step', 0.01)

        lot_size = max(0.0, lot_size)
        
        # Round to lot_step
        lot_size = math.floor(lot_size / lot_step) * lot_step
        
        if lot_size < min_lot:
            logger.warning(f"Calculated lot size {lot_size} below min_lot {min_lot}. Setting to 0.")
            return 0.0
            
        if lot_size > max_lot:
            logger.warning(f"Calculated lot size {lot_size} above max_lot {max_lot}. Capping.")
            lot_size = max_lot

        return round(lot_size, 2)
