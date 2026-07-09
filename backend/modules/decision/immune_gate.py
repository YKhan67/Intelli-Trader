from __future__ import annotations
import logging
import numpy as np
from typing import Tuple, Dict, Any
from sqlalchemy import select, and_, func
from backend.database.postgres import AsyncSessionLocal
from backend.database.models_db import ModelFeedbackDB, CurrencyPairDB

logger = logging.getLogger("ImmuneGate")

class ImmuneGate:
    def __init__(self):
        self.similarity_threshold = 0.85 
        self.weights = {'rsi_14': 0.4, 'ema_50': 0.2, 'ema_200': 0.2, 'atr_14': 0.2}

    async def check_immunity(self, pair: str, current_indicators: Dict[str, Any]) -> Tuple[bool, float, str]:
        """
        Determines if current market conditions are too similar to recent AI failures.
        """
        symbol_up = pair.upper()
        
        async with AsyncSessionLocal() as session:
            # 1. Get Pair ID safely
            pair_res = await session.execute(
                select(CurrencyPairDB.id).where(func.upper(CurrencyPairDB.symbol) == symbol_up)
            )
            pair_id = pair_res.scalar()
            
            if not pair_id:
                return False, 1.0, "Pair unknown."

            # 2. Get recent failure patterns
            stmt = select(ModelFeedbackDB).where(ModelFeedbackDB.pair_id == pair_id)
            res = await session.execute(stmt)
            patterns = res.scalars().all()
            
            if not patterns:
                return False, 1.0, "No failure history."

            # 3. Compare current DNA
            max_sim = 0.0
            for p in patterns:
                sim = self._calculate_similarity(current_indicators, p.indicator_dna)
                if sim > max_sim: max_sim = sim

            if max_sim >= self.similarity_threshold:
                return True, 0.0, f"VETO: {max_sim:.1%} similarity to recent failure"
            
            if max_sim > 0.65:
                return False, 0.5, f"CAUTION: {max_sim:.1%} similarity to recent failure"

            return False, 1.0, "Immune system cleared."

    def _calculate_similarity(self, current: Dict[str, Any], pattern: Dict[str, Any]) -> float:
        matches = []
        for key, weight in self.weights.items():
            v1 = current.get(key)
            v2 = pattern.get(key)
            
            if v1 is not None and v2 is not None:
                if key == 'rsi_14':
                    diff = abs(float(v1) - float(v2)) / 100.0
                else:
                    base = max(abs(float(v1)), abs(float(v2)), 0.0001)
                    diff = abs(float(v1) - float(v2)) / base
                
                # Match calculation
                match = max(0.0, 1.0 - (diff * 8))
                matches.append(match * weight)
        
        return float(sum(matches)) if matches else 0.0
