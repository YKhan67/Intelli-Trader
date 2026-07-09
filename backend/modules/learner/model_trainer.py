import os
import logging
import pandas as pd
import numpy as np
import joblib
import asyncio
from datetime import datetime, timedelta, timezone
from typing import Dict, Any, List
from sqlalchemy import select, and_

# Production AI Libraries
from sklearn.ensemble import RandomForestClassifier, GradientBoostingRegressor
from xgboost import XGBClassifier
from sklearn.model_selection import train_test_split

from backend.database.postgres import AsyncSessionLocal
from backend.database.models_db import OHLCVBarDB, IndicatorDB, ModelVersionDB, CurrencyPairDB
from backend.modules.models import ModelStatus

logger = logging.getLogger("ModelTrainer")

class ModelTrainer:
    def __init__(self, config: Dict[str, Any]):
        self.config = config.get('learner', {})
        self.save_dir = os.path.join(os.getcwd(), "models/saved")
        if not os.path.exists(self.save_dir):
            os.makedirs(self.save_dir, exist_ok=True)

    async def retrain_all(self, pairs: List[str]):
        """Runs the 56-Core Optimized Decade-Scale AI Training Pipeline."""
        logger.info(f"Initializing High-Performance Training for pairs: {pairs}")
        
        # 1. Parallel Data Fetching
        df = await self._fetch_training_data_parallel(pairs, timeframe="H1")
        
        if df.empty:
            logger.error("Training Aborted: No data found in database.")
            return {"status": "FAILED", "reason": "No data"}

        logger.info(f"Dataset Loaded: {len(df)} samples. Features: {len(df.columns)}")

        # 2. Parallel Training of Models (RandomForest uses all cores via n_jobs=-1)
        results = {}
        
        # We run these sequentially as each already uses all 56 cores internally (n_jobs=-1 / XGB parallel)
        # Running them in parallel would cause massive context switching.
        results['regime'] = await self._train_regime_model(df)
        results['strategy'] = await self._train_strategy_model(df)
        
        return results

    async def _train_regime_model(self, df: pd.DataFrame):
        logger.info("Training Regime Classifier (Parallel RandomForest)...")
        features = [col for col in df.columns if col not in ['target_regime', 'target_close', 'pair', 'timestamp']]
        X = df[features].fillna(0)
        y = np.where(df['rsi_14'] > 60, 1, np.where(df['rsi_14'] < 40, 2, 0))
        
        # n_jobs=-1 uses all 56 cores for tree building
        model = RandomForestClassifier(n_estimators=300, max_depth=15, n_jobs=-1, verbose=1)
        model.fit(X, y)
        
        metrics = {"accuracy": float(model.score(X, y))}
        version = await self._save_model_file(model, "regime_rf", metrics, "Regime Classifier")
        return {"status": "SUCCESS", "version": version, "metrics": metrics}

    async def _train_strategy_model(self, df: pd.DataFrame):
        logger.info("Training Strategy Selector (High-Speed XGBoost)...")
        features = [col for col in df.columns if col not in ['target_regime', 'target_close', 'pair', 'timestamp']]
        X = df[features].fillna(0)
        y = (df['target_close'].shift(-4) - df['target_close'] > 0.0050).astype(int).fillna(0)
        
        # XGBoost handles parallelism internally
        model = XGBClassifier(n_estimators=500, learning_rate=0.03, max_depth=8, n_jobs=-1, tree_method='hist')
        model.fit(X, y)
        
        metrics = {"accuracy": float(model.score(X, y))}
        version = await self._save_model_file(model, "strategy_xgb", metrics, "Strategy Selector")
        return {"status": "SUCCESS", "version": version, "metrics": metrics}

    async def _fetch_training_data_parallel(self, pairs: List[str], timeframe: str) -> pd.DataFrame:
        """Fetches both Price History and Error DNA for recursive learning."""
        tasks = [self._fetch_pair_data(pair, timeframe) for pair in pairs]
        results = await asyncio.gather(*tasks)
        
        # Also fetch Error DNA (Mistakes)
        error_dna_rows = await self._fetch_error_dna()
        
        all_rows = []
        for r in results:
            all_rows.extend(r)
        
        # Duplicate the "Mistake" data 3x to give it higher importance (Recursive Weighting)
        if error_dna_rows:
            logger.info(f"Recursive Learning: Injecting {len(error_dna_rows)} penalty patterns.")
            for _ in range(3):
                all_rows.extend(error_dna_rows)
            
        return pd.DataFrame(all_rows)

    async def _fetch_error_dna(self) -> List[Dict]:
        from backend.database.models_db import ModelFeedbackDB
        async with AsyncSessionLocal() as session:
            stmt = select(ModelFeedbackDB.indicator_dna)
            res = await session.execute(stmt)
            return [{"data": r[0], "is_mistake": 1} for r in res.all()]

    async def _fetch_pair_data(self, pair: str, timeframe: str) -> List[Dict]:
        window_days = self.config.get('retrain_window_days', 3650)
        start_date = datetime.now(timezone.utc) - timedelta(days=window_days)
        
        rows_data = []
        async with AsyncSessionLocal() as session:
            pair_id_res = await session.execute(select(CurrencyPairDB.id).where(CurrencyPairDB.symbol == pair))
            pair_id = pair_id_res.scalar()
            if not pair_id: return []

            stmt = select(OHLCVBarDB, IndicatorDB.data).join(
                IndicatorDB, OHLCVBarDB.id == IndicatorDB.bar_id
            ).where(
                and_(
                    OHLCVBarDB.pair_id == pair_id,
                    OHLCVBarDB.timeframe == timeframe,
                    OHLCVBarDB.timestamp >= start_date
                )
            ).order_by(OHLCVBarDB.timestamp.asc())
            
            result = await session.execute(stmt)
            rows = result.all()
            
            for bar, ind_data in rows:
                if not ind_data: continue
                rows_data.append({**ind_data, 'target_close': bar.close, 'pair': pair, 'timestamp': bar.timestamp})
        
        return rows_data

    async def _save_model_file(self, model: Any, name: str, metrics: Dict, module: str) -> str:
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        version_str = f"v1.0.{timestamp}"
        filename = f"{name}_{timestamp}.joblib"
        path = os.path.join(self.save_dir, filename)
        
        joblib.dump(model, path)
        
        async with AsyncSessionLocal() as session:
            db_version = ModelVersionDB(
                version=version_str,
                module=module,
                status=ModelStatus.LIVE,
                metrics=metrics
            )
            session.add(db_version)
            await session.commit()
            
        logger.info(f"Deployed {module} {version_str}")
        return version_str
