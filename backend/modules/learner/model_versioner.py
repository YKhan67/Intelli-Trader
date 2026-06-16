import logging
from datetime import datetime, timezone, timedelta
from typing import Dict, Any, Optional
from sqlalchemy import select, update
from backend.database.postgres import AsyncSessionLocal
from backend.database.models_db import ModelVersionDB
from backend.modules.models import ModelStatus

logger = logging.getLogger("ModelVersioner")

class ModelVersioner:
    def __init__(self, config: Dict[str, Any]):
        self.config = config.get('learner', {})

    async def promote_models(self):
        """
        Evaluates PAPER models and promotes them to LIVE if they outperform.
        """
        logger.info("Evaluating PAPER models for promotion...")
        
        async with AsyncSessionLocal() as session:
            # 1. Fetch models in PAPER status older than evaluation period
            eval_days = self.config.get('paper_eval_days', 7)
            cutoff = datetime.now(timezone.utc) - timedelta(days=eval_days)
            
            stmt = select(ModelVersionDB).where(
                ModelVersionDB.status == ModelStatus.PAPER,
                ModelVersionDB.trained_at <= cutoff
            )
            result = await session.execute(stmt)
            paper_models = result.scalars().all()
            
            for model in paper_models:
                # 2. Compare against current LIVE model
                live_stmt = select(ModelVersionDB).where(
                    ModelVersionDB.module == model.module,
                    ModelVersionDB.status == ModelStatus.LIVE
                )
                live_model = (await session.execute(live_stmt)).scalar_one_or_none()
                
                # 3. Decision Logic
                should_promote = await self._should_promote(model, live_model)
                
                if should_promote:
                    await self._execute_promotion(session, model, live_model)
                else:
                    logger.info(f"Model {model.module} {model.version} failed promotion.")
                    # Keep in PAPER or retire if performance is terrible
                    
            await session.commit()

    async def _should_promote(self, new_model: ModelVersionDB, live_model: Optional[ModelVersionDB]) -> bool:
        thresholds = self.config.get('promotion_thresholds', {})
        
        # New model must meet minimums
        new_metrics = new_model.metrics or {}
        if new_metrics.get('sharpe', 0) < thresholds.get('min_sharpe', 1.5): return False
        if new_metrics.get('win_rate', 0) < thresholds.get('min_win_rate', 0.45): return False
        
        if not live_model: return True # First model
        
        # Must be better than live
        live_metrics = live_model.metrics or {}
        return new_metrics.get('sharpe', 0) > live_metrics.get('sharpe', 0)

    async def _execute_promotion(self, session, new_model: ModelVersionDB, old_model: Optional[ModelVersionDB]):
        # Retire old model
        if old_model:
            old_model.status = ModelStatus.RETIRED
            logger.info(f"Retiring old model {old_model.module} {old_model.version}")
            
        # Promote new model
        new_model.status = ModelStatus.LIVE
        logger.info(f"PROMOTED model {new_model.module} {new_model.version} to LIVE")
