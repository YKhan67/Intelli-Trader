import logging
from datetime import datetime, timezone, timedelta
from typing import Dict, Any, List
from sqlalchemy import select, func
from backend.database.postgres import AsyncSessionLocal
from backend.database.models_db import TradeDB, ModelVersionDB, SystemAlertDB
from backend.modules.models import ModelStatus, AlertSeverity
import uuid
import numpy as np

logger = logging.getLogger("PerformanceMonitor")

class PerformanceMonitor:
    def __init__(self, config: Dict[str, Any]):
        self.config = config.get('learner', {})
        self.thresholds = self.config.get('emergency_thresholds', {})

    async def daily_check(self):
        """
        Monitors live performance and triggers alerts/retrains.
        """
        logger.info("Running daily performance monitor...")
        
        async with AsyncSessionLocal() as session:
            # 1. Strategy Win Rate Check
            await self._check_strategy_decay(session)
            
            # 2. Sharpe Ratio Check (Rolling 7 days)
            await self._check_sharpe_emergency(session)
            
            # 3. Regime Classifier Accuracy (if feedback available)
            # Placeholder: In a real system, we'd compare predicted regime vs actual following price action
            
            await session.commit()

    async def _check_strategy_decay(self, session):
        # Fetch rolling 30-day win rate per strategy
        cutoff = datetime.now(timezone.utc) - timedelta(days=30)
        
        # Simplified query: count wins/losses from TradeDB
        # In production, we'd group by strategy
        min_wr = self.thresholds.get('min_strategy_winrate', 0.35)
        
        # Mocking finding a decaying strategy
        decaying_strat = None # "TREND_FOLLOW"
        
        if decaying_strat:
            alert = SystemAlertDB(
                alert_id=uuid.uuid4(),
                timestamp=datetime.now(timezone.utc),
                alert_type="STRATEGY_DECAY",
                severity=AlertSeverity.HIGH,
                message=f"Strategy {decaying_strat} win rate below {min_wr:.2%}. Retirement recommended."
            )
            session.add(alert)
            logger.warning(f"Decay detected for {decaying_strat}")

    async def _check_sharpe_emergency(self, session):
        min_sharpe = self.thresholds.get('min_sharpe', 1.0)
        
        # Calculate rolling 7-day Sharpe from TradeDB
        cutoff = datetime.now(timezone.utc) - timedelta(days=7)
        stmt = select(TradeDB).where(
            TradeDB.exit_time >= cutoff,
            TradeDB.status == 'CLOSED'
        )
        trades = (await session.execute(stmt)).scalars().all()
        
        if len(trades) < 5: return # Need a minimum sample
        
        returns = [t.net_profit_loss for t in trades]
        sharpe = (np.mean(returns) / np.std(returns)) if np.std(returns) > 0 else 0
        
        if sharpe < min_sharpe:
            alert = SystemAlertDB(
                alert_id=uuid.uuid4(),
                timestamp=datetime.now(timezone.utc),
                alert_type="EMERGENCY_RETRAIN",
                severity=AlertSeverity.CRITICAL,
                message=f"Live 7-day Sharpe ratio ({sharpe:.2f}) dropped below {min_sharpe}. Triggering emergency retrain."
            )
            session.add(alert)
            logger.critical(f"EMERGENCY: Sharpe {sharpe:.2f} too low. Alert created.")
