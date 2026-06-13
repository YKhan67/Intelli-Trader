import yaml
import os
import pandas as pd
from typing import Dict, Any, List
from datetime import datetime, timezone
from sqlalchemy import select

from backend.database.postgres import AsyncSessionLocal
from backend.database.models_db import RegimeHistoryDB, CurrencyPairDB
from backend.database.redis_client import get_redis_client
from backend.modules.models import MarketRegimeResult, Regime, Direction

from .rules import evaluate_regime_rules
from .multi_timeframe import confirm_macro_bias
from .confidence import calculate_confidence
from .duration_tracker import track_regime_duration
from .ml_classifier import MLRegimeClassifier

class RegimeClassifier:
    def __init__(self):
        config_path = os.path.join(os.path.dirname(__file__), "../../config/regimes.yaml")
        with open(config_path, "r") as f:
            self.config = yaml.safe_load(f)
        
        self.ml_classifier = MLRegimeClassifier(self.config.get('ml_model_path', ''))

    async def classify(self, pair: str, timeframe: str, df: pd.DataFrame, indicators: Dict[str, Any]) -> MarketRegimeResult:
        """
        Main entry point for regime classification.
        """
        # 1. Rule-based classification
        rule_regime, rule_agreement, agreeing_indicators = evaluate_regime_rules(df, indicators, self.config)
        
        # 2. Macro Confirmation (H4 vs H1)
        h4_bias = Direction.NEUTRAL
        if timeframe == "H1":
            redis = get_redis_client()
            h4_regime_val = await redis.get(f"regime:{pair}:H4")
            if h4_regime_val:
                # Use multi-timeframe module to confirm
                confirmed_regime, h4_bias = confirm_macro_bias(rule_regime, Regime(h4_regime_val))
            else:
                confirmed_regime = rule_regime
        else:
            confirmed_regime = rule_regime
        
        # 3. Confidence Calculation
        total_checks = 5 # Number of rules/indicators we verified
        confidence = calculate_confidence(agreeing_indicators, total_checks, self.config)
        
        # 4. Duration Tracking
        bars_in_regime, duration_warning = await track_regime_duration(pair, confirmed_regime, self.config)
        
        # 5. Check if regime changed
        redis = get_redis_client()
        cache_key = f"regime:{pair}:{timeframe}"
        prev_regime_val = await redis.get(cache_key)
        regime_changed = prev_regime_val != confirmed_regime.value if prev_regime_val else True
        
        # 6. Build Result
        result = MarketRegimeResult(
            timestamp=datetime.now(timezone.utc),
            pair=pair,
            timeframe=timeframe,
            regime=confirmed_regime,
            confidence=confidence,
            h4_bias=h4_bias,
            h1_regime=rule_regime,
            bars_in_regime=bars_in_regime,
            regime_changed=regime_changed,
            duration_warning=duration_warning,
            indicators_agreed=len(agreeing_indicators)
        )
        
        # 7. Persistence & Caching
        if regime_changed:
            await self._log_regime_change(result, indicators)
            
        await redis.set(cache_key, confirmed_regime.value, ex=120)
        
        return result

    async def _log_regime_change(self, result: MarketRegimeResult, indicators: Dict[str, Any]):
        async with AsyncSessionLocal() as session:
            pair_id = (await session.execute(
                select(CurrencyPairDB.id).where(CurrencyPairDB.symbol == result.pair)
            )).scalar()
            
            if pair_id:
                history = RegimeHistoryDB(
                    pair_id=pair_id,
                    timestamp=result.timestamp,
                    regime=result.regime,
                    confidence=result.confidence,
                    h4_bias=result.h4_bias,
                    h1_regime=result.h1_regime,
                    bars_in_regime=result.bars_in_regime,
                    regime_changed=True,
                    duration_warning=result.duration_warning,
                    indicators_agreed=result.indicators_agreed
                )
                session.add(history)
                await session.commit()
