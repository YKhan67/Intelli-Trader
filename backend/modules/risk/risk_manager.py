import yaml
import os
import logging
import json
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

    async def _get_live_settings(self) -> Dict[str, Any]:
        """Fetches dynamic risk overrides from Redis."""
        try:
            raw = await self.redis.get("system:settings")
            if raw:
                return json.loads(raw)
        except: pass
        return {}

    async def calculate(self, 
                        pair: str, 
                        direction: Direction,
                        strategy: Strategy, 
                        timeframe: str,
                        account_balance: float, 
                        open_trades: List[Dict],
                        trading_mode: str,
                        indicators: Dict[str, Any]) -> RiskParameters:
        
        live_cfg = await self._get_live_settings()
        
        # 1. Circuit Breakers
        halts = await self.breakers.check_all(account_balance)
        if halts['any_halt']:
            return self._build_empty_risk(pair, strategy, halts)

        atr = indicators.get('atr_14')
        if not atr:
            return self._build_empty_risk(pair, strategy, halts)

        # 2. Stop Loss
        sl_price, sl_pips = await self.sl_calc.calculate_stop_loss(
            pair, direction, strategy, indicators.get('close'), atr, timeframe
        )

        # 3. Take Profit (with dynamic RR override)
        min_rr = float(live_cfg.get('min_rr_ratio', self.config.get('min_rr_ratio', 1.5)))
        
        # Temporarily override TP calc's internal min_rr
        original_rr = self.tp_calc.min_rr
        self.tp_calc.min_rr = min_rr
        
        tp_price, tp_pips, partial, be, rr_ok = self.tp_calc.calculate_take_profit(
            direction, strategy, indicators.get('close'), sl_price, atr
        )
        
        self.tp_calc.min_rr = original_rr # Restore

        if not rr_ok:
            logger.warning(f"Risk Check: R:R ratio ({tp_pips/sl_pips:.2f}) < threshold ({min_rr}). Blocked.")
            return self._build_empty_risk(pair, strategy, halts)

        # 4. Position Sizing (with dynamic risk % override)
        max_risk = float(live_cfg.get('max_risk_per_trade', self.config.get('max_risk_per_trade', 0.01)))
        
        # PositionSizer uses config internally, we pass the override via logic or temporary config edit
        original_max_risk = self.config['max_risk_per_trade']
        self.config['max_risk_per_trade'] = max_risk
        
        lot_size = self.sizer.calculate_lot_size(
            pair, account_balance, sl_pips, 0.5, trading_mode
        )
        
        self.config['max_risk_per_trade'] = original_max_risk # Restore

        # Final score & build
        risk_score = self._calculate_risk_score(halts, False, atr, indicators.get('close'))
        return RiskParameters(
            timestamp=datetime.now(timezone.utc),
            pair=pair, strategy=strategy, lot_size=lot_size,
            stop_loss_price=sl_price, take_profit_price=tp_price,
            stop_loss_pips=sl_pips, take_profit_pips=tp_pips,
            partial_close_price=partial, breakeven_price=be,
            risk_percent=max_risk, atr_used=atr,
            rr_ratio=tp_pips / sl_pips if sl_pips > 0 else 0,
            daily_halt=halts['daily_halt'], hard_daily_halt=halts['hard_daily_halt'],
            weekly_review=halts['weekly_review'], correlated_exposure=False,
            risk_score=risk_score
        )

    def _calculate_risk_score(self, halts, is_corr, atr, price) -> float:
        return 0.2 # Simplified

    def _build_empty_risk(self, pair, strategy, halts) -> RiskParameters:
        return RiskParameters(
            timestamp=datetime.now(timezone.utc),
            pair=pair, strategy=strategy, lot_size=0,
            stop_loss_price=0, take_profit_price=0, stop_loss_pips=0, take_profit_pips=0,
            risk_percent=0, atr_used=0, rr_ratio=0, daily_halt=halts.get('daily_halt', False),
            hard_daily_halt=halts.get('hard_daily_halt', False), weekly_review=halts.get('weekly_review', False),
            correlated_exposure=False, risk_score=1.0
        )
