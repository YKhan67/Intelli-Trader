import asyncio
import logging
from datetime import datetime, timezone, timedelta
from typing import Dict, Any, List

from backend.database.postgres import AsyncSessionLocal
from backend.database.models_db import TradeDB, RegimeHistoryDB
from backend.database.redis_client import get_redis_client
from sqlalchemy import select, func, and_

logger = logging.getLogger("ContinuousLearner")

class ContinuousLearner:
    def __init__(self, config: Dict[str, Any] = None):
        self.config = config or {}
        self.redis = get_redis_client()
        self._running = False
        self.min_retrain_accuracy = self.config.get('min_retrain_accuracy', 0.65)

    async def start(self):
        """Starts the background auditing loop."""
        self._running = True
        logger.info("Auditor Loop active. Monitoring regime stability and signal accuracy...")
        
        while self._running:
            try:
                # 1. Check for Regime Stability
                await self._audit_regimes()
                
                # 2. Check for Signal Accuracy (Post-Analysis)
                await self._audit_performance()
                
                # Sleep for 15 minutes between deep audits
                await asyncio.sleep(900)
            except Exception as e:
                logger.error(f"Error in Auditor Loop: {e}")
                await asyncio.sleep(60)

    async def _audit_regimes(self):
        """Detects if multiple pairs are entering UNKNOWN or conflicting regimes."""
        logger.info("[AUDITOR] Checking market regime stability...")
        async with AsyncSessionLocal() as session:
            # Look at last 1 hour of regime history
            hour_ago = datetime.now(timezone.utc) - timedelta(hours=1)
            stmt = select(RegimeHistoryDB).where(RegimeHistoryDB.timestamp >= hour_ago)
            res = await session.execute(stmt)
            history = res.scalars().all()
            
            unknowns = [r for r in history if r.regime == "UNKNOWN"]
            if len(unknowns) > 5:
                logger.warning(f"[ALERT] High number of UNKNOWN regimes ({len(unknowns)}). Market may be in high-volatility flux.")

    async def _audit_performance(self):
        """Triggers retraining if recent trade accuracy is too low."""
        logger.info("[AUDITOR] Calculating rolling accuracy...")
        async with AsyncSessionLocal() as session:
            # Look at last 50 closed trades
            stmt = select(TradeDB).where(TradeDB.status == "CLOSED").order_by(TradeDB.exit_time.desc()).limit(50)
            res = await session.execute(stmt)
            trades = res.scalars().all()
            
            if len(trades) < 10: return
            
            wins = [t for t in trades if (t.pips_result or 0) > 0]
            accuracy = len(wins) / len(trades)
            
            logger.info(f"[AUDITOR] Current 50-trade accuracy: {accuracy:.2%}")
            
            if accuracy < self.min_retrain_accuracy:
                logger.warning(f"[TRIGGER] Accuracy ({accuracy:.2%}) below threshold ({self.min_retrain_accuracy:.2%}). Signaling Brain for retraining.")
                await self.redis.set("system:retrain_needed", "true")

    def stop(self):
        self._running = False
