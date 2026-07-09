import logging
import pandas as pd
import numpy as np
from datetime import datetime, timezone, timedelta
from typing import Dict, Any, List
from backend.database.redis_client import get_redis_client
from backend.database.mongo import db

logger = logging.getLogger("AnomalyDetector")

class AnomalyDetector:
    def __init__(self, config: Dict[str, Any]):
        self.config = config.get('learner', {}).get('anomaly', {})
        self.redis = get_redis_client()
        # LOGICAL FIX 2: Stats is now Pair-Aware to prevent cross-instrument pollution
        self.pair_stats: Dict[str, Dict] = {} 

    async def check_anomaly(self, indicators: Dict[str, Any], pair: str):
        """
        Detects unusual market conditions based on indicator distributions.
        Partitioned by pair to ensure Gold isn't measured by EURUSD volatility.
        """
        if pair not in self.pair_stats:
            await self._build_profile(pair)
            
        stats = self.pair_stats.get(pair, {})
        if not stats: return False

        anomalous_indicators = []
        std_threshold = self.config.get('std_dev_threshold', 3.0)
        
        for key, value in indicators.items():
            if key in stats and (hasattr(value, '__add__') or isinstance(value, (int, float))):
                mean = stats[key]['mean']
                std = stats[key]['std']
                
                if std > 0 and abs(value - mean) > (std_threshold * std):
                    anomalous_indicators.append(key)

        is_anomalous = len(anomalous_indicators) >= self.config.get('indicator_count_threshold', 3)
        
        if is_anomalous:
            await self._trigger_anomaly_mode(pair, anomalous_indicators, indicators)
        else:
            await self._clear_anomaly_mode(pair)
            
        return is_anomalous

    async def _build_profile(self, pair: str):
        """Builds mean/std profile from last 90 days for a specific pair."""
        logger.info(f"Building anomaly profile for {pair}...")
        
        from backend.database.postgres import AsyncSessionLocal
        from backend.database.models_db import OHLCVBarDB, IndicatorDB, CurrencyPairDB
        from sqlalchemy import select, and_

        window_days = self.config.get('profile_window_days', 90)
        start_date = datetime.now(timezone.utc) - timedelta(days=window_days)
        
        async with AsyncSessionLocal() as session:
            pair_id = (await session.execute(select(CurrencyPairDB.id).where(CurrencyPairDB.symbol == pair))).scalar()
            if not pair_id: return

            stmt = select(IndicatorDB.data).join(
                OHLCVBarDB, OHLCVBarDB.id == IndicatorDB.bar_id
            ).where(
                and_(
                    OHLCVBarDB.pair_id == pair_id,
                    OHLCVBarDB.timestamp >= start_date
                )
            ).limit(2000)
            
            result = await session.execute(stmt)
            rows = result.scalars().all()
            
            if not rows:
                # Fallback to defaults unique to this pair
                self.pair_stats[pair] = {"rsi_14": {"mean": 50, "std": 15}, "atr_14": {"mean": 0.0015, "std": 0.0005}}
                return

            df = pd.DataFrame(rows)
            new_stats = {}
            for col in df.columns:
                # Use duck-typing for numeric check
                try:
                    mean_val = float(df[col].mean())
                    std_val = float(df[col].std())
                    new_stats[col] = {"mean": mean_val, "std": std_val}
                except:
                    continue
                    
            self.pair_stats[pair] = new_stats
            logger.info(f"Anomaly profile built for {pair} with {len(new_stats)} indicators.")

    async def _trigger_anomaly_mode(self, pair: str, anomalies: List[str], snapshot: Dict):
        logger.warning(f"ANOMALY DETECTED for {pair}: {anomalies}")
        try:
            await self.redis.set(f"circuit:anomaly_active:{pair}", "1", ex=3600)
            from backend.database.mongo import db
            await db.anomaly_logs.insert_one({
                "pair": pair,
                "timestamp": datetime.now(timezone.utc),
                "anomalous_indicators": anomalies,
                "snapshot": snapshot
            })
        except: pass

    async def _clear_anomaly_mode(self, pair: str):
        try:
            await self.redis.delete(f"circuit:anomaly_active:{pair}")
        except: pass
