import yaml
import os
from datetime import datetime, timezone
from typing import Dict, Any, Optional, List
from sqlalchemy import select
from backend.database.postgres import AsyncSessionLocal
from backend.database.models_db import StrategyDecisionDB, CurrencyPairDB
from backend.modules.models import StrategyDecision, Strategy, MarketRegimeResult, Session

from .switch_guard import SwitchGuard
from .performance_tracker import StrategyPerformanceTracker
from .selector_ml import MLStrategySelector

class StrategySelector:
    def __init__(self):
        config_path = os.path.join(os.path.dirname(__file__), "../../config/strategies.yaml")
        with open(config_path, "r") as f:
            self.config = yaml.safe_load(f)
            
        self.guard = SwitchGuard(self.config)
        self.tracker = StrategyPerformanceTracker(self.config)
        self.ml_selector = MLStrategySelector(self.config.get('thresholds', {}).get('ml_model_path', ''))

    async def select(self, 
                     regime_result: MarketRegimeResult, 
                     is_trade_open: bool, 
                     last_trade_result: Optional[float],
                     pair: str,
                     session: Session,
                     bars_since_regime_start: int,
                     bars_since_last_loss: int) -> StrategyDecision:
        """
        Main strategy selection logic.
        """
        
        # 1. Look up primary/secondary mapping for this regime
        regime_map = self.config.get('strategy_regime_map', {}).get(regime_result.regime, {})
        primary_strategy = Strategy(regime_map.get('primary', 'SKIP'))
        secondary_strategy = Strategy(regime_map.get('secondary', 'SKIP'))
        
        # 2. Check performance of primary strategy
        perf = await self.tracker.get_performance(primary_strategy, regime_result.regime)
        
        selected_strategy = primary_strategy
        reason = f"Primary strategy for {regime_result.regime}"
        blocked_reason = None
        
        if perf['is_underperforming']:
            selected_strategy = secondary_strategy
            reason = f"Primary ({primary_strategy}) underperforming (WR: {perf['win_rate']:.2%}). Falling back to secondary."
            
        # 3. Apply Switch Guard
        is_blocked, guard_reason = self.guard.can_switch(
            selected_strategy, 
            regime_result, 
            is_trade_open, 
            last_trade_result,
            bars_since_regime_start,
            bars_since_last_loss
        )
        
        if is_blocked:
            # If blocked, we usually stay with current or SKIP if no choice
            # For the decision object, we mark why it was blocked
            blocked_reason = guard_reason
            # In live mode, we would likely return the CURRENT strategy if blocked, 
            # but for this logic we'll mark as SKIP if forced switch is needed but blocked.
            # result_strategy = current_strategy (passed as arg)
            
        # 4. Build Decision Object
        decision = StrategyDecision(
            timestamp=datetime.now(timezone.utc),
            pair=pair,
            regime=regime_result.regime,
            strategy=selected_strategy if not is_blocked else Strategy.SKIP,
            timeframe=regime_result.timeframe,
            confidence=regime_result.confidence,
            session=session,
            switch_occurred=not is_blocked,
            switch_reason=reason if not is_blocked else None,
            alternative_strategy=secondary_strategy if selected_strategy == primary_strategy else None,
            blocked_reason=blocked_reason
        )
        
        # 5. Log to DB
        await self._log_decision(decision)
        
        return decision

    async def _log_decision(self, decision: StrategyDecision):
        async with AsyncSessionLocal() as session:
            pair_id = (await session.execute(
                select(CurrencyPairDB.id).where(CurrencyPairDB.symbol == decision.pair)
            )).scalar()
            
            if pair_id:
                db_decision = StrategyDecisionDB(
                    pair_id=pair_id,
                    timestamp=decision.timestamp,
                    strategy=decision.strategy,
                    timeframe=decision.timeframe,
                    regime=decision.regime,
                    confidence=decision.confidence,
                    session=decision.session,
                    switch_occurred=decision.switch_occurred,
                    switch_reason=decision.switch_reason,
                    alternative_strategy=decision.alternative_strategy,
                    blocked_reason=decision.blocked_reason
                )
                session.add(db_decision)
                await session.commit()
