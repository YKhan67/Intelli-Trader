from typing import Dict, Any, Optional
import math
import logging

logger = logging.getLogger("PositionSizer")

class PositionSizer:
    def __init__(self, config: Dict[str, Any], pairs_config: Dict[str, Any]):
        self.config = config
        self.pairs_config = {p['symbol'].upper(): p for p in pairs_config['pairs']}

    def calculate_lot_size(self, 
                          pair: str, 
                          account_balance: float, 
                          stop_loss_distance: float, 
                          risk_scale: float = 1.0,
                          trading_mode: str = "normal",
                          consecutive_losses: int = 0,
                          consecutive_wins: int = 0) -> float:
        """
        Institutional Position Sizing.
        Uses absolute price distance ($5.00) instead of 'Pips' for cross-asset accuracy.
        """
        if stop_loss_distance <= 0:
            return 0.0

        pair_up = pair.upper()
        pair_info = self.pairs_config.get(pair_up)
        if not pair_info:
            logger.error(f"Pair {pair_up} not found in pairs config")
            return 0.0

        # 1. Base Risk Amount (User Setting from Redis/Config)
        risk_pct = self.config.get('max_risk_per_trade', 0.01)
        risk_amount = account_balance * risk_pct

        # 2. Institutional Multipliers
        # Applies global scale (Risk %) AND local scale (e.g. 50% reduction for correlation)
        risk_amount *= risk_scale

        # 3. Mode Multipliers (Conservative / Aggressive)
        mode_multipliers = self.config.get('mode_multipliers', {})
        risk_amount *= mode_multipliers.get(trading_mode, 1.0)

        # 4. Streak Mitigation
        if consecutive_losses >= 3:
            risk_amount *= 0.5 # Force-halve risk on losing streaks

        # 5. Contract Value Calibration
        # We calculate: How much USD do we profit per $1.00 move per 1.0 lot?
        if "XAU" in pair_up or "GOLD" in pair_up:
            price_move_value = 100.0 # Standard Gold Contract
        elif "BTC" in pair_up:
            price_move_value = 1.0 # 1 BTC per lot
        elif "JPY" in pair_up:
            price_move_value = 915.0 # USDJPY approx move value
        else:
            price_move_value = 100000.0 # Standard 100k Forex Contract

        # 6. The Calculation
        # lot_size = risk_usd / (move_distance_usd * unit_value)
        lot_size = risk_amount / (stop_loss_distance * price_move_value)

        # 7. Apply Broker Limits
        min_lot = pair_info.get('min_lot', 0.01)
        max_lot = pair_info.get('max_lot', 10.0)
        lot_step = pair_info.get('lot_step', 0.01)

        lot_size = max(0.0, lot_size)
        lot_size = math.floor(lot_size / lot_step) * lot_step
        
        if lot_size < min_lot:
            return 0.0
            
        if lot_size > max_lot:
            lot_size = max_lot

        return round(lot_size, 2)
