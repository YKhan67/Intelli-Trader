import asyncio
import logging
import pandas as pd
from typing import Dict, Any, List
from backend.database.postgres import AsyncSessionLocal
from backend.database.models_db import OHLCVBarDB, IndicatorDB
from sqlalchemy import select, and_

from backend.modules.indicators import IndicatorCalculator
from backend.modules.smc import SMCManager
from .decision_engine import DecisionEngine

logger = logging.getLogger("BarProcessor")

class BarProcessor:
    def __init__(self):
        self.indicator_calc = IndicatorCalculator()
        self.smc_manager = SMCManager()
        self.engine = DecisionEngine()
        self.processing_queue = asyncio.Queue()

    async def process_new_bar(self, pair: str, timeframe: str):
        """
        Triggered when a new bar closes.
        """
        logger.info(f"New bar detected for {pair} {timeframe}. Queuing for processing...")
        await self.processing_queue.put((pair, timeframe))

    async def worker(self):
        """
        Background worker that processes the queue.
        """
        logger.info("Decision worker started.")
        while True:
            pair, timeframe = await self.processing_queue.get()
            try:
                await self._execute_pipeline(pair, timeframe)
            except Exception as e:
                logger.error(f"Error processing bar for {pair} {timeframe}: {e}")
            finally:
                self.processing_queue.task_done()

    async def _execute_pipeline(self, pair: str, timeframe: str):
        start_time = asyncio.get_event_loop().time()
        
        # 1. Update Indicators
        await self.indicator_calc.calculate_all(pair, timeframe, lookback_bars=300)
        
        # 2. Update SMC Zones
        active_zones = await self.smc_manager.update_zones(pair, timeframe, lookback_bars=200)
        
        # 3. Fetch data for engine
        async with AsyncSessionLocal() as session:
            stmt = select(OHLCVBarDB, IndicatorDB.data).join(
                IndicatorDB, OHLCVBarDB.id == IndicatorDB.bar_id
            ).where(
                and_(OHLCVBarDB.timeframe == timeframe)
            ).order_by(OHLCVBarDB.timestamp.desc()).limit(100)
            
            result = await session.execute(stmt)
            rows = result.all()
            
            if not rows: return

            rows = rows[::-1]
            df = pd.DataFrame([{
                'close': r[0].close, 'high': r[0].high, 'low': r[0].low, 'timestamp': r[0].timestamp, 'open': r[0].open, 'volume': r[0].volume
            } for r in rows])
            df.set_index('timestamp', inplace=True)
            latest_indicators = rows[-1][1]

        # 4. Run Decision Engine
        # Mocking account balance and open trades for now
        signal = await self.engine.run_pipeline(
            pair=pair,
            df=df,
            indicators=latest_indicators,
            active_zones=active_zones,
            account_balance=10000.0,
            open_trades=[],
            trading_mode="normal"
        )
        
        duration = asyncio.get_event_loop().time() - start_time
        logger.info(f"Bar processed for {pair} {timeframe} in {duration:.2f}s. Action: {signal.trade_decision.action}")
