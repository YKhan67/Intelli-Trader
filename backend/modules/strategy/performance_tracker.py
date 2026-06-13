from datetime import datetime, timedelta, timezone
from typing import Dict, Any, Optional
from sqlalchemy import select, func, and_
from backend.database.postgres import AsyncSessionLocal
from backend.database.models_db import TradeDB, PerformanceStrategyDB
from backend.modules.models import Strategy, Regime

class StrategyPerformanceTracker:
    def __init__(self, config: Dict[str, Any]):
        self.config = config.get('thresholds', {})

    async def get_performance(self, strategy: Strategy, regime: Any) -> Dict[str, Any]:
        """
        Calculates win rate for strategy/regime over last X days.
        """
        # Ensure we have string values for comparison in DB
        strategy_val = strategy.value if isinstance(strategy, Strategy) else strategy
        regime_val = regime.value if isinstance(regime, Regime) else regime

        async with AsyncSessionLocal() as session:
            window_days = self.config.get('performance_window_days', 30)
            since_date = datetime.now(timezone.utc) - timedelta(days=window_days)
            
            # Count total and winning trades
            stmt = select(
                func.count(TradeDB.trade_uuid).label('total'),
                func.count().filter(TradeDB.pips_result > 0).label('wins')
            ).where(
                and_(
                    TradeDB.strategy == strategy_val,
                    TradeDB.regime == regime_val,
                    TradeDB.entry_time >= since_date,
                    TradeDB.status == 'CLOSED'
                )
            )
            
            result = await session.execute(stmt)
            row = result.fetchone()
            
            total = row.total if row and row.total else 0
            wins = row.wins if row and row.wins else 0
            win_rate = wins / total if total > 0 else 1.0 # Assume 100% for new strategies
            
            return {
                "total_trades": total,
                "win_rate": win_rate,
                "is_underperforming": win_rate < self.config.get('underperforming_winrate', 0.40)
            }

    async def update_performance_table(self, strategy: Strategy, regime: Any):
        """
        Updates the performance_strategy table after a trade closes.
        """
        perf = await self.get_performance(strategy, regime)
        
        # Ensure we have string values for DB
        strategy_val = strategy.value if hasattr(strategy, 'value') else strategy
        regime_val = regime.value if hasattr(regime, 'value') else regime

        async with AsyncSessionLocal() as session:
            # Check if record exists
            stmt = select(PerformanceStrategyDB).where(
                and_(
                    PerformanceStrategyDB.strategy == strategy_val,
                    PerformanceStrategyDB.regime == regime_val
                )
            )
            result = await session.execute(stmt)
            db_perf = result.scalar_one_or_none()
            
            if db_perf:
                db_perf.total_trades = perf['total_trades']
                db_perf.win_rate = perf['win_rate']
            else:
                new_perf = PerformanceStrategyDB(
                    strategy=strategy_val,
                    regime=regime_val,
                    total_trades=perf['total_trades'],
                    win_rate=perf['win_rate']
                )
                session.add(new_perf)
            
            await session.commit()
