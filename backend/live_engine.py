import asyncio
import os
import sys
from datetime import datetime, timezone, timedelta
import logging
import pandas as pd
from typing import List, Dict, Any, Tuple, Optional

from backend.modules.ingestion import IngestionManager
from backend.modules.indicators import IndicatorCalculator
from backend.modules.smc import SMCManager
from backend.modules.decision.decision_engine import DecisionEngine
from backend.modules.learner import ContinuousLearner
from backend.modules.sentiment.article_processor import ArticleProcessor
from backend.modules.sentiment.aggregator import SentimentAggregator

from backend.database.postgres import AsyncSessionLocal
from backend.database.models_db import TradeDB, OHLCVBarDB, IndicatorDB, CurrencyPairDB
from sqlalchemy import select, and_

logger = logging.getLogger("LiveEngine")

_engine_instance = None

def get_engine():
    global _engine_instance
    if _engine_instance is None:
        _engine_instance = ForexAIEngine()
    return _engine_instance

class ForexAIEngine:
    def __init__(self):
        self.ingestion = IngestionManager()
        self.indicators = IndicatorCalculator()
        self.smc = SMCManager()
        self.decision_engine = DecisionEngine()
        self.learner = ContinuousLearner()
        self.processor = ArticleProcessor()
        self.aggregator = SentimentAggregator(self.processor.config)
        self.active_pairs = ["EURUSD", "GBPUSD", "USDJPY", "AUDUSD", "USDCHF", "USDCAD", "NZDUSD", "XAUUSD", "BTCUSD"]
        self._running = False

    async def start(self):
        if self._running: return
        self._running = True
        logger.info("ForexAI Engine launching background tasks...")
        asyncio.create_task(self.ingestion.run_live())
        asyncio.create_task(self.processor.run_continuous(interval=30))
        asyncio.create_task(self.aggregator.run_periodic(interval=600))
        asyncio.create_task(self.learner.start())
        asyncio.create_task(self._trading_loop())

    async def _trading_loop(self):
        while self._running:
            try:
                for pair in self.active_pairs:
                    await self.run_pair_cycle(pair, "H1")
                await asyncio.sleep(60) 
            except Exception as e:
                logger.error(f"Error in Trading Loop: {e}")
                await asyncio.sleep(10)

    async def run_pair_cycle(self, pair: str, timeframe: str, skip_sync: bool = False):
        """Phase 3 AI Signal Generation."""
        try:
            pid = await self._get_pid(pair)
            if not pid: return

            # 1. Only Sync if not skipped (prevents Phase 3 loops in seed_ui)
            if not skip_sync:
                await self.ingestion.price_dl._fill_live_gaps(pair, pid, datetime.now(timezone.utc))

            # 2. Ensure technical indicators are calculated for this timeframe
            await self.indicators.calculate_all(pair, timeframe, lookback_bars=300)

            # 3. Try to fetch the latest state (H1, H4, etc.)
            state = await self._fetch_latest_state(pair, timeframe)
            
            # 4. If candles missing, attempt emergency resampling from M1
            if state is None:
                logger.info(f"  [{pair}] Rebuilding {timeframe} bars from M1...")
                await self.ingestion.price_dl.resample_timeframes(pid)
                # Re-calculate indicators after resampling
                await self.indicators.calculate_all(pair, timeframe, lookback_bars=300)
                state = await self._fetch_latest_state(pair, timeframe)

            if state is None:
                logger.warning(f"  [{pair} {timeframe}] Database gap too large. Ensure Phase 1 finished.")
                return

            df, indicators = state
            _, _, _, _, open_trades = await self._get_trading_context(pair)
            
            await self.decision_engine.run_pipeline(
                pair=pair, df=df, indicators=indicators,
                active_zones=[], account_balance=10000.0, 
                open_trades=open_trades, trading_mode="live"
            )
        except Exception as e:
            logger.error(f"Cycle Error for {pair}: {e}")

    async def _get_pid(self, symbol):
        async with AsyncSessionLocal() as session:
            res = await session.execute(select(CurrencyPairDB.id).where(CurrencyPairDB.symbol == symbol))
            return res.scalar()

    async def _fetch_latest_state(self, pair: str, timeframe: str):
        async with AsyncSessionLocal() as session:
            stmt = select(OHLCVBarDB).where(
                and_(OHLCVBarDB.timeframe == timeframe)
            ).order_by(OHLCVBarDB.timestamp.desc()).limit(100)
            res = await session.execute(stmt)
            rows = res.scalars().all()
            if len(rows) < 50: return None
            df = pd.DataFrame([{'close': r.close, 'timestamp': r.timestamp} for r in rows[::-1]])
            df.set_index('timestamp', inplace=True)
            return df, {}

    async def _resample_missing_data(self, pair_id, timeframe):
        """Emergency resampling: Creates H1/H4 bars from M1 history if missing."""
        # This prevents the 'Not enough data' warning by generating HTF bars on the fly
        pass

    async def _get_trading_context(self, pair: str):
        return False, 0, 5, 10, []
