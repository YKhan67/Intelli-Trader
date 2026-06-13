import asyncio
import os
import sys
from datetime import datetime, timezone
import logging
import pandas as pd
from typing import List, Dict, Any, Tuple

from backend.modules.ingestion import IngestionManager
from backend.modules.indicators import IndicatorCalculator
from backend.modules.smc import SMCManager
from backend.modules.regime import RegimeClassifier
from backend.modules.strategy import StrategySelector
from backend.modules.timeframe import TimeframeSelector
from backend.modules.sentiment import SentimentManager
from backend.modules.risk import RiskManager
from backend.modules.decision.decision_engine import DecisionEngine

from backend.modules.models import Session, CurrencyPair, Timeframe, SignalAction
from backend.database.postgres import AsyncSessionLocal
from backend.database.models_db import TradeDB, RegimeHistoryDB, OHLCVBarDB, IndicatorDB
from sqlalchemy import select, func, and_

logger = logging.getLogger("LiveEngine")

class ForexAIEngine:
    def __init__(self):
        self.ingestion = IngestionManager()
        self.indicators = IndicatorCalculator()
        self.smc = SMCManager()
        self.decision_engine = DecisionEngine()
        self.active_pairs = ["EURUSD", "GBPUSD", "USDJPY", "AUDUSD", "USDCHF", "USDCAD", "NZDUSD"]

    async def run_pair_cycle(self, pair: str, timeframe: str):
        """
        Executes the full real-time pipeline for a single pair.
        Supports MTF dependencies (H4 for H1 decisions).
        """
        try:
            logger.info(f"--- Starting Live Cycle: {pair} {timeframe} ---")

            # 1. LIVE DATA INGESTION
            await self.ingestion.price_dl.download_historical()

            # 2. MTF PREPARATION (If H1, we also need H4 for macro bias)
            if timeframe == "H1":
                await self.indicators.calculate_all(pair, "H4", lookback_bars=100)
                h4_df, h4_ind = await self._fetch_latest_state(pair, "H4")
                if h4_ind:
                    await self.decision_engine.regime_classifier.classify(pair, "H4", h4_df, h4_ind)
            
            # 3. CALCULATE MAIN INDICATORS
            await self.indicators.calculate_all(pair, timeframe, lookback_bars=300)

            # 4. DETECT SMC ZONES
            active_zones = await self.smc.update_zones(pair, timeframe, lookback_bars=200)

            # 5. FETCH LATEST DATA FOR PIPELINE
            df, latest_indicators = await self._fetch_latest_state(pair, timeframe)
            if df is None or latest_indicators is None:
                logger.warning(f"Insufficient data to run pipeline for {pair}")
                return

            # 6. RUN DECISION ENGINE
            is_open, last_result, bars_regime, bars_loss, open_trades = await self._get_trading_context(pair)
            
            signal = await self.decision_engine.run_pipeline(
                pair=pair,
                df=df,
                indicators=latest_indicators,
                active_zones=active_zones,
                account_balance=10000.0,
                open_trades=open_trades,
                trading_mode="normal"
            )

            logger.info(f"Signal for {pair}: {signal.trade_decision.action} (Confidence: {signal.trade_decision.confidence:.4f})")
            
            if signal.trade_decision.action != SignalAction.HOLD:
                logger.info(f">>> TRADE SIGNAL ISSUED: {signal.trade_decision.action} {pair} @ {signal.trade_decision.entry_price}")

        except Exception as e:
            logger.error(f"Error in Live Cycle for {pair}: {e}", exc_info=True)

    async def _fetch_latest_state(self, pair: str, timeframe: str) -> Tuple[Optional[pd.DataFrame], Optional[Dict]]:
        async with AsyncSessionLocal() as session:
            stmt = select(OHLCVBarDB, IndicatorDB.data).join(
                IndicatorDB, OHLCVBarDB.id == IndicatorDB.bar_id
            ).where(
                and_(OHLCVBarDB.timeframe == timeframe)
            ).order_by(OHLCVBarDB.timestamp.desc()).limit(100)
            
            result = await session.execute(stmt)
            rows = result.all()
            
            if len(rows) < 50: return None, None

            rows = rows[::-1]
            df = pd.DataFrame([{
                'close': r[0].close, 'high': r[0].high, 'low': r[0].low, 
                'open': r[0].open, 'volume': r[0].volume, 'timestamp': r[0].timestamp
            } for r in rows])
            df.set_index('timestamp', inplace=True)
            latest_indicators = rows[-1][1]
            return df, latest_indicators

    async def _get_trading_context(self, pair: str):
        """Fetches dynamic context from database."""
        async with AsyncSessionLocal() as session:
            # 1. Open Trades
            stmt = select(TradeDB).where(TradeDB.status == 'OPEN')
            db_trades = (await session.execute(stmt)).scalars().all()
            open_trades = [{"pair": t.pair_id, "action": t.direction} for t in db_trades] # Simplified
            is_open = any(t['pair'] == pair for t in open_trades)
            
            # 2. Last Trade Result
            stmt_last = select(TradeDB.pips_result).where(
                and_(TradeDB.status == 'CLOSED')
            ).order_by(TradeDB.exit_time.desc()).limit(1)
            last_result = (await session.execute(stmt_last)).scalar()

            # 3. Bars in Regime
            # For simplicity, we default to 5. Real logic would query regime_history.
            bars_regime = 5
            
            # 4. Bars since last loss
            bars_loss = 10 
            
            return is_open, last_result, bars_regime, bars_loss, open_trades
