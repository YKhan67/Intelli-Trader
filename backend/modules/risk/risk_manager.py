import yaml
import os
import logging
from datetime import datetime, timezone
from typing import Dict, Any, List, Optional
from backend.modules.models import RiskParameters, Strategy, Direction

from .position_sizer import PositionSizer
from .stop_loss_calculator import StopLossCalculator
from .take_profit_calculator import TakeProfitCalculator
from .circuit_breakers import CircuitBreakers
from .correlation_checker import CorrelationChecker
from backend.database.redis_client import get_redis_client

logger = logging.getLogger("RiskManager")

class RiskManager:
    def __init__(self):
        # Load configs
        config_dir = os.path.join(os.path.dirname(__file__), "../../config")
        with open(os.path.join(config_dir, "risk.yaml"), "r") as f:
            self.config = yaml.safe_load(f)
        with open(os.path.join(config_dir, "pairs.yaml"), "r") as f:
            self.pairs_config = yaml.safe_load(f)
        with open(os.path.join(config_dir, "learning.yaml"), "r") as f:
            self.learning_config = yaml.safe_load(f)
            
        self.sizer = PositionSizer(self.config, self.pairs_config)
        self.sl_calc = StopLossCalculator(self.config)
        self.tp_calc = TakeProfitCalculator(self.config)
        self.breakers = CircuitBreakers(self.config)
        self.correlation = CorrelationChecker(self.pairs_config)
        self.redis = get_redis_client()

    async def calculate(self, 
                        pair: str, 
                        direction: Direction,
                        strategy: Strategy, 
                        timeframe: str,
                        account_balance: float, 
                        open_trades: List[Dict],
                        trading_mode: str,
                        indicators: Dict[str, Any]) -> RiskParameters:
        """
        Orchestrates all risk calculations.
        """
        # 1. Circuit Breakers First
        halts = await self.breakers.check_all(account_balance)
        if halts['any_halt']:
            logger.critical(f"Risk Check: SYSTEM HALT ACTIVE for {pair}. Trade blocked.")
            return self._build_empty_risk(pair, strategy, halts)

        # 2. Get ATR from indicators
        atr = indicators.get('atr_14')
        if not atr:
            logger.error(f"Risk Check: ATR missing for {pair}. Trade blocked.")
            return self._build_empty_risk(pair, strategy, halts)

        # 3. Calculate Stop Loss
        sl_price, sl_pips = await self.sl_calc.calculate_stop_loss(
            pair, direction, strategy, indicators.get('close'), atr, timeframe
        )

        # 4. Calculate Take Profit
        tp_price, tp_pips, partial, be, rr_ok = self.tp_calc.calculate_take_profit(
            direction, strategy, indicators.get('close'), sl_price, atr
        )
        
        if not rr_ok:
            logger.warning(f"Risk Check: R:R ratio too low for {pair}. Trade blocked.")
            return self._build_empty_risk(pair, strategy, halts)

        # 5. Correlation Check
        open_pairs = [t['pair'] for t in open_trades]
        is_corr, corr_multiplier = self.correlation.check_exposure(pair, open_pairs)

        # 6. Calculate Position Size
        # Mock win rate for Kelly (in real system, would be from performance tracker)
        win_rate = 0.5 
        
        lot_size = self.sizer.calculate_lot_size(
            pair, account_balance, sl_pips, win_rate, trading_mode
        )
        
        if is_corr:
            lot_size *= corr_multiplier
            logger.info(f"Correlated exposure detected for {pair}. Reducing lot size to {lot_size}")

        # 7. Anomaly Check (From Continuous Learner)
        is_anomalous = await self.redis.get(f"circuit:anomaly_active:{pair}")
        if is_anomalous:
            multiplier = self.learning_config.get('learner', {}).get('anomaly', {}).get('risk_multiplier', 0.25)
            lot_size *= multiplier
            logger.warning(f"ANOMALY MODE ACTIVE for {pair}. Reducing lot size by {multiplier}x to {lot_size}")

        # 8. Final Risk Score (0.0 - 1.0)
        risk_score = self._calculate_risk_score(halts, is_corr, atr, indicators.get('close'))

        # 8. Build Result
        params = RiskParameters(
            timestamp=datetime.now(timezone.utc),
            pair=pair,
            strategy=strategy,
            lot_size=lot_size,
            stop_loss_price=sl_price,
            take_profit_price=tp_price,
            stop_loss_pips=sl_pips,
            take_profit_pips=tp_pips,
            partial_close_price=partial,
            breakeven_price=be,
            risk_percent=self.config.get('max_risk_per_trade', 0.01),
            atr_used=atr,
            rr_ratio=tp_pips / sl_pips if sl_pips > 0 else 0,
            daily_halt=halts['daily_halt'],
            hard_daily_halt=halts['hard_daily_halt'],
            weekly_review=halts['weekly_review'],
            correlated_exposure=is_corr,
            risk_score=risk_score
        )
        
        logger.info(f"Risk calculated for {pair}: {lot_size} lots, SL: {sl_price:.5f}, TP: {tp_price:.5f}")
        return params

    def _calculate_risk_score(self, halts, is_corr, atr, price) -> float:
        score = 0.0
        if halts['daily_halt']: score += 0.3
        if is_corr: score += 0.2
        # Add volatility component
        if atr and price:
            vol_score = (atr / price) * 100
            score += min(0.5, vol_score)
        return min(1.0, score)

    def _build_empty_risk(self, pair, strategy, halts) -> RiskParameters:
        return RiskParameters(
            timestamp=datetime.now(timezone.utc),
            pair=pair,
            strategy=strategy,
            lot_size=0,
            stop_loss_price=0,
            take_profit_price=0,
            stop_loss_pips=0,
            take_profit_pips=0,
            risk_percent=0,
            atr_used=0,
            rr_ratio=0,
            daily_halt=halts.get('daily_halt', False),
            hard_daily_halt=halts.get('hard_daily_halt', False),
            weekly_review=halts.get('weekly_review', False),
            correlated_exposure=False,
            risk_score=1.0
        )
