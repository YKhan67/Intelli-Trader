import asyncio
import os
import sys
import json
import logging
import pandas as pd
from datetime import datetime, timezone, timedelta
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
from backend.database.redis_client import get_redis_client
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
        # LOGICAL FIX: Expanded to 10 pairs including BTCEUR
        self.active_pairs = ["EURUSD", "GBPUSD", "USDJPY", "AUDUSD", "USDCHF", "USDCAD", "NZDUSD", "XAUUSD", "BTCUSD", "BTCEUR"]
        self.redis = get_redis_client()
        self._running = False
        self._tasks = []

    async def _refresh_settings(self):
        try:
            raw = await self.redis.get("system:settings")
            if raw:
                data = raw
                for _ in [1, 2]:
                    if hasattr(data, 'decode'): data = data.decode()
                    if hasattr(data, 'startswith') and data.startswith("{"):
                        try: data = json.loads(data)
                        except: break
                if hasattr(data, 'items') and "active_pairs" in data:
                    self.active_pairs = [str(p).upper() for p in data["active_pairs"]]
        except: pass

    async def start(self):
        if self._running: return
        self._running = True
        logger.info(">>> EXECUTIONER: Launching 10-Pair AI Portfolio tracks...")
        await self.decision_engine.reload_models()
        self._tasks.append(asyncio.create_task(self.ingestion.run_live()))
        self._tasks.append(asyncio.create_task(self.processor.run_continuous(interval=30)))
        self._tasks.append(asyncio.create_task(self.aggregator.run_periodic(interval=600)))
        self._tasks.append(asyncio.create_task(self._trading_loop()))

    async def stop(self):
        if not self._running: return
        self._running = False
        logger.info("ForexAI Engine stopping background tasks...")
        try:
            await self.ingestion.stop()
        except Exception as e:
            logger.error(f"Error stopping IngestionManager: {e}")
        for task in self._tasks:
            if not task.done(): task.cancel()
        if self._tasks:
            await asyncio.gather(*self._tasks, return_exceptions=True)
        self._tasks = []
        logger.info("ForexAI Engine shutdown complete.")

    async def _trading_loop(self):
        """56-Core Parallel Cycle Orchestrator for 10-Pair Portfolio."""
        while self._running:
            try:
                await self._refresh_settings()
                if self._is_market_open():
                    logger.info("--- Starting Multi-Timeframe AI Cycle (10-Pair Parallel) ---")
                    # Simultaneous processing of all pairs (including BTCUSD/BTCEUR)
                    tasks = [self.run_pair_multi_tf(pair) for pair in self.active_pairs]
                    await asyncio.gather(*tasks)
                    logger.info("--- Cycle Complete. Waiting 1 minute ---")
                for _ in range(60):
                    if not self._running: break
                    await asyncio.sleep(1)
            except asyncio.CancelledError: break
            except Exception as e:
                logger.error(f"Error in Trading Loop: {e}")
                await asyncio.sleep(10)

    def _is_market_open(self):
        now = datetime.now(timezone.utc)
        wd = now.weekday()
        if wd == 4 and now.hour >= 22: return False
        if wd == 5: return False
        if wd == 6 and now.hour < 22: return False
        return True

    async def run_pair_multi_tf(self, pair: str):
        """Processes all relevant timeframes for a single pair sequentially."""
        for tf in ["M15", "H1", "H4"]:
            if not self._running: break
            await self.run_pair_cycle(pair, tf)

    async def run_pair_cycle(self, pair: str, timeframe: str, skip_sync: bool = False):
        try:
            pid = await self._get_pid(pair)
            if not pid: return
            if not skip_sync:
                await self.ingestion.price_dl._fill_live_gaps(pair, pid, datetime.now(timezone.utc))
            
            await self.indicators.calculate_all(pair, timeframe, lookback_bars=1000)
            active_zones = await self.smc.update_zones(pair, timeframe, lookback_bars=500)
            state = await self._fetch_latest_state(pid, timeframe, fetch_bars=500)
            
            if state is None:
                await self.ingestion.price_dl.resample_native_sql(pid, pair, recent_only=True)
                await self.indicators.calculate_all(pair, timeframe, lookback_bars=1000)
                state = await self._fetch_latest_state(pid, timeframe, fetch_bars=500)
            
            if state is None: return
            df, indicators = state
            
            # Indicator Freshness Gate
            if not indicators:
                await asyncio.sleep(1.0)
                state = await self._fetch_latest_state(pid, timeframe, fetch_bars=500)
                if state: df, indicators = state
            
            acc_raw = await self.redis.get("state:account")
            pos_raw = await self.redis.get("state:positions")
            account_balance = 10000.0
            open_trades = []
            if acc_raw:
                try: 
                    d = json.loads(acc_raw)
                    account_balance = float(d.get('balance', 10000.0))
                except: pass
            if pos_raw:
                try: open_trades = json.loads(pos_raw)
                except: pass
                
            await self.decision_engine.run_pipeline(
                pair=pair, df=df, indicators=indicators,
                active_zones=active_zones, account_balance=account_balance, 
                open_trades=open_trades, trading_mode="live"
            )
        except asyncio.CancelledError: raise
        except Exception as e:
            logger.error(f"Cycle Error for {pair} {timeframe}: {e}")

    async def _get_pid(self, symbol):
        async with AsyncSessionLocal() as session:
            res = await session.execute(select(CurrencyPairDB.id).where(CurrencyPairDB.symbol == symbol))
            return res.scalar()

    async def _fetch_latest_state(self, pair_id, timeframe: str, fetch_bars: int = 500):
        async with AsyncSessionLocal() as session:
            stmt = select(OHLCVBarDB, IndicatorDB.data).outerjoin(
                IndicatorDB, OHLCVBarDB.id == IndicatorDB.bar_id
            ).where(
                and_(OHLCVBarDB.pair_id == pair_id, OHLCVBarDB.timeframe == timeframe)
            ).order_by(OHLCVBarDB.timestamp.desc()).limit(fetch_bars)
            
            res = await session.execute(stmt)
            rows = res.all()
            if len(rows) < 100: return None
            
            rows = rows[::-1]
            df = pd.DataFrame([{
                'timestamp': r[0].timestamp, 'open': r[0].open, 'high': r[0].high, 
                'low': r[0].low, 'close': r[0].close, 'volume': r[0].volume
            } for r in rows])
            df.set_index('timestamp', inplace=True)
            return df, (rows[-1][1] if rows[-1][1] else {})
