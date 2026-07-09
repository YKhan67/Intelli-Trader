import yaml
import os
import logging
import json
import asyncio
from datetime import datetime, timezone
from typing import Dict, Any, List, Optional
from backend.modules.models import RiskParameters, Strategy, Direction, SignalAction

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
        self.pip_map = {p['symbol'].upper(): float(p.get('pip_size', 0.0001)) for p in self.pairs_config['pairs']}

    @staticmethod
    def _normalize_direction(direction: Any) -> Direction:
        if isinstance(direction, SignalAction):
            if direction == SignalAction.BUY:
                return Direction.LONG
            if direction == SignalAction.SELL:
                return Direction.SHORT
            return Direction.NEUTRAL
        if isinstance(direction, Direction):
            return direction
        return Direction.NEUTRAL

    async def _get_live_settings(self) -> Dict[str, Any]:
        try:
            raw = await self.redis.get("system:settings")
            if not raw: return {}
            settings = raw
            for _ in [1, 2, 3]:
                if hasattr(settings, 'encode') or hasattr(settings, 'decode'):
                    try: settings = json.loads(settings)
                    except: break
                else: break
            return settings if hasattr(settings, 'items') else {}
        except: return {}

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
        Price-Point Risk Core.
        """
        direction = self._normalize_direction(direction)

        live_cfg = await self._get_live_settings()
        pair_up = pair.upper()
        pip_size = self.pip_map.get(pair_up, 0.0001)
        
        pair_risk_map = live_cfg.get('pair_risk', {})
        normalized_map = {str(k).upper(): v for k, v in pair_risk_map.items() if hasattr(v, 'items')}
        pair_settings = normalized_map.get(pair_up, {})
        
        halts = await self.breakers.check_all(account_balance)
        if halts['any_halt']: return self._build_empty_risk(pair, strategy, halts)

        if direction == Direction.NEUTRAL:
            return self._build_empty_risk(pair, strategy, halts)

        atr = indicators.get('atr_14')
        # Institutional Guard: If ATR is missing or microscopic, block entry
        # Relaxed from 50% of pip size to 20% to avoid rejecting valid setups too aggressively.
        if not atr or atr < (pip_size * 0.2): return self._build_empty_risk(pair, strategy, halts)

        # LOGICAL FIX: Institutional Spread Guard
        # Relaxed from 50% of ATR to 80% of ATR so slightly wider spreads do not block entries prematurely.
        spread_pips = float(indicators.get('spread_pips', 1.5))
        if spread_pips * pip_size > (atr * 0.8):
            if direction != Direction.NEUTRAL:
                logger.warning(f"SPREAD GUARD [{pair_up}]: Spread too wide for ATR. Skipping.")
            return self._build_empty_risk(pair, strategy, halts)

        open_pairs = [t.get('pair') for t in open_trades if t.get('pair')]
        is_corr, corr_multiplier = self.correlation.check_exposure(pair, open_pairs)

        sl_price, sl_pips = await self.sl_calc.calculate_stop_loss(
            pair, direction, strategy, indicators.get('close'), atr, timeframe, pip_size
        )
        price = float(indicators.get('close'))
        if direction == Direction.LONG and sl_price >= price:
            sl_price = price - (atr * 1.5)
        elif direction == Direction.SHORT and sl_price <= price:
            sl_price = price + (atr * 1.5)
            
        sl_dist_price = (price - sl_price) if (price - sl_price) > 0 else (sl_price - price)

        min_rr = float(pair_settings.get('min_rr', live_cfg.get('min_rr_ratio', self.config.get('min_rr_ratio', 1.5))))
        orig_rr = self.tp_calc.min_rr
        self.tp_calc.min_rr = min_rr
        tp_price, tp_pips, partial, be, rr_ok = self.tp_calc.calculate_take_profit(
            direction, strategy, price, sl_price, atr, pip_size
        )
        self.tp_calc.min_rr = orig_rr

        tp_dist_price = (price - tp_price) if (price - tp_price) > 0 else (tp_price - price)
        actual_rr = tp_dist_price / sl_dist_price if sl_dist_price > 0 else 0

        if not rr_ok:
            if direction != Direction.NEUTRAL:
                logger.warning(f"Risk Check [{pair_up}]: R:R {actual_rr:.2f} < threshold {min_rr}. Blocked.")
            return self._build_empty_risk(pair, strategy, halts)

        max_risk = float(pair_settings.get('max_risk', live_cfg.get('max_risk_per_trade', self.config.get('max_risk_per_trade', 0.01))))
        orig_risk = self.config['max_risk_per_trade']
        self.config['max_risk_per_trade'] = max_risk
        
        lot_size = self.sizer.calculate_lot_size(
            pair=pair, account_balance=account_balance, stop_loss_distance=sl_dist_price, 
            risk_scale=corr_multiplier, trading_mode=trading_mode
        )
        self.config['max_risk_per_trade'] = orig_risk

        if pair_settings:
            logger.info(f"RISK OVERRIDE ENFORCED for {pair_up}: R:R {min_rr} | Risk {max_risk*100:.1f}%")

        return RiskParameters(
            timestamp=datetime.now(timezone.utc), pair=pair, strategy=strategy, lot_size=lot_size,
            stop_loss_price=sl_price, take_profit_price=tp_price, stop_loss_pips=sl_pips, take_profit_pips=tp_pips,
            partial_close_price=partial, breakeven_price=be, risk_percent=max_risk, atr_used=atr,
            rr_ratio=actual_rr, daily_halt=halts['daily_halt'],
            hard_daily_halt=halts['hard_daily_halt'], weekly_review=halts['weekly_review'],
            correlated_exposure=is_corr, risk_score=self._calculate_risk_score(halts, is_corr, atr, price)
        )

    def _calculate_risk_score(self, halts, is_corr, atr, price) -> float:
        score = 0.2
        if is_corr: score += 0.3
        if halts.get('consecutive_pause'): score += 0.2
        return score if score < 1.0 else 1.0

    def _build_empty_risk(self, pair, strategy, halts) -> RiskParameters:
        return RiskParameters(
            timestamp=datetime.now(timezone.utc), pair=pair, strategy=strategy, lot_size=0,
            stop_loss_price=0, take_profit_price=0, stop_loss_pips=0, take_profit_pips=0,
            risk_percent=0, atr_used=0, rr_ratio=0, daily_halt=halts.get('daily_halt', False),
            hard_daily_halt=halts.get('hard_daily_halt', False), weekly_review=halts.get('weekly_review', False),
            correlated_exposure=False, risk_score=1.0
        )
