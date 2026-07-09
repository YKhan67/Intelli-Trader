from __future__ import annotations
import asyncio
import logging
import json
import pandas as pd
from datetime import datetime, timedelta, timezone
from typing import List, Dict, Any, Optional
from sqlalchemy import select, and_, delete
from backend.database.postgres import AsyncSessionLocal
from backend.database.models_db import OHLCVBarDB, IndicatorDB, ModelFeedbackDB, CurrencyPairDB
from backend.modules.decision.decision_engine import DecisionEngine
from backend.modules.models import SignalAction

logger = logging.getLogger("ShadowBacktester")

class ShadowBacktester:
    def __init__(self):
        self._running = False

    async def run_audit_cycle(self, pairs: List[str]):
        """
        Runs a perfect hindsight backtest for the last 48h to extract failure DNA.
        """
        logger.info(">>> STARTING SHADOW AUDIT GRID (Immune System Update)")
        
        async with AsyncSessionLocal() as session:
            # Clear expired patterns (> 48h old)
            cutoff = datetime.now(timezone.utc) - timedelta(hours=48)
            await session.execute(delete(ModelFeedbackDB).where(ModelFeedbackDB.detected_at < cutoff))
            await session.commit()

        for pair in pairs:
            try:
                await self.audit_pair(pair)
            except Exception as e:
                logger.error(f"Shadow Audit failed for {pair}: {e}")

    async def audit_pair(self, pair: str):
        # 1. Fetch last 48h of H1 bars + Indicators
        async with AsyncSessionLocal() as session:
            pair_id_res = await session.execute(select(CurrencyPairDB.id).where(CurrencyPairDB.symbol == pair.upper()))
            pair_id = pair_id_res.scalar()
            if not pair_id: return
            
            since = datetime.now(timezone.utc) - timedelta(hours=48)
            
            stmt = select(OHLCVBarDB, IndicatorDB.data).join(
                IndicatorDB, OHLCVBarDB.id == IndicatorDB.bar_id
            ).where(
                and_(OHLCVBarDB.pair_id == pair_id, OHLCVBarDB.timeframe == "H1", OHLCVBarDB.timestamp >= since)
            ).order_by(OHLCVBarDB.timestamp.asc())
            
            res = await session.execute(stmt)
            rows = res.all()
            if len(rows) < 10: return

            # 2. Perfect Hindsight Logic
            for i in range(len(rows) - 5):
                bar, indicators = rows[i]
                future_bar, _ = rows[i+4]
                
                # Check for "Bull Trap" or "Bear Trap" failures
                # Logic: If high volatility + RSI extreme but reversal happened
                if self._is_false_positive(bar, future_bar):
                    await self._record_failure_dna(pair_id, indicators, "SHADOW_LOSS")

    def _is_false_positive(self, entry_bar: Any, exit_bar: Any) -> bool:
        # Simplified hindsight failure detection
        return abs(entry_bar.close - exit_bar.close) > 0.0060

    async def _record_failure_dna(self, pair_id: int, indicators: Dict[str, Any], context: str):
        async with AsyncSessionLocal() as session:
            feedback = ModelFeedbackDB(
                pair_id=pair_id,
                strategy="SHADOW_GEN",
                indicator_dna=indicators,
                failure_context=context,
                expires_at=datetime.now(timezone.utc) + timedelta(hours=48)
            )
            session.add(feedback)
            await session.commit()

    async def run_continuous(self, interval: int = 3600):
        self._running = True
        while self._running:
            # Simplified pairs fetch
            pairs = ["EURUSD", "GBPUSD", "USDJPY", "AUDUSD", "XAUUSD", "BTCUSD"]
            await self.run_audit_cycle(pairs)
            await asyncio.sleep(interval)
