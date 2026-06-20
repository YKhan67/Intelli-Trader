import asyncio
import os
import yaml
import logging
import uuid
import json
from datetime import datetime, timezone, timedelta
from typing import Dict, Any, Optional

from backend.modules.models import (
    TradeDecision, 
    BackendSignal, 
    SignalAction, 
    Strategy, 
    Session,
    Timeframe
)
from backend.database.redis_client import get_redis_client

from backend.modules.regime import RegimeClassifier
from backend.modules.strategy import StrategySelector
from backend.modules.timeframe import TimeframeSelector
from backend.modules.sentiment import SentimentManager
from backend.modules.risk import RiskManager
from backend.modules.learner import AnomalyDetector

from .signal_generator import SignalGenerator
from .confidence_aggregator import ConfidenceAggregator
from .validation import SignalValidator

from backend.modules.learner.model_versioner import ModelVersioner

logger = logging.getLogger("DecisionEngine")

class DecisionEngine:
    def __init__(self):
        config_path = os.path.join(os.path.dirname(__file__), "../../config/trading.yaml")
        with open(config_path, "r") as f:
            self.config = yaml.safe_load(f)
            
        self.regime_classifier = RegimeClassifier()
        self.strategy_selector = StrategySelector()
        self.timeframe_selector = TimeframeSelector()
        self.sentiment_manager = SentimentManager()
        self.risk_manager = RiskManager()
        
        self.signal_gen = SignalGenerator()
        self.confidence_aggregator = ConfidenceAggregator(self.config)
        self.validator = SignalValidator()
        self.anomaly_detector = AnomalyDetector(self.config)
        
        self.redis = get_redis_client()
        self._current_versions = {}

    async def reload_models(self):
        """Loads latest LIVE versions of all module models."""
        modules = ["Regime Classifier", "Strategy Selector", "Timeframe Scorer"]
        for m in modules:
            ver = await ModelVersioner.get_latest_live_model(m)
            if ver:
                self._current_versions[m] = ver.version
                logger.info(f"Loaded {m} version {ver.version}")

    async def run_pipeline(self, 
                            pair: str, 
                            df: Any, 
                            indicators: Dict[str, Any],
                            active_zones: Any,
                            account_balance: float,
                            open_trades: Any,
                            trading_mode: str) -> BackendSignal:
        """
        Orchestrates the full decision pipeline for one pair.
        """
        start_time = asyncio.get_event_loop().time()
        is_backtest = trading_mode == "backtest"
        
        try:
            current_ts = df.index[-1]
            if 'close' not in indicators:
                indicators['close'] = df['close'].iloc[-1]
            
            # Safety: Ensure ATR exists for risk management
            if 'atr_14' not in indicators or indicators['atr_14'] is None:
                indicators['atr_14'] = 0.0020 if "JPY" not in pair else 0.20

            # 1. Pipeline Analysis
            is_anomalous = await self.anomaly_detector.check_anomaly(indicators, pair)
            regime_res = await self.regime_classifier.classify(pair, "H1", df, indicators)
            
            bars_since_last_loss = 99
            last_trade_result = None
            try:
                raw_cooldown = await self.redis.get(f"state:loss_cooldown:{pair}")
                if raw_cooldown: bars_since_last_loss = int(raw_cooldown)
                raw_res = await self.redis.get(f"state:last_result:{pair}")
                if raw_res: last_trade_result = float(raw_res)
            except: pass
            
            from backend.modules.timeframe.session_detector import SessionDetector
            session_detector = SessionDetector()
            current_session = await session_detector.get_current_session(current_ts)

            # 2. Decision Logic
            strategy_decision = await self.strategy_selector.select(
                regime_result=regime_res, is_trade_open=len(open_trades) > 0,
                last_trade_result=last_trade_result, pair=pair, session=current_session,
                bars_since_regime_start=regime_res.bars_in_regime, bars_since_last_loss=bars_since_last_loss
            )

            current_spread = indicators.get('spread_pips', 1.5)
            tf_selection = await self.timeframe_selector.select(
                strategy_decision=strategy_decision, regime_result=regime_res,
                current_spread_pips=current_spread, is_trade_open=len(open_trades) > 0, dt=current_ts
            )

            sentiment_res = await self.sentiment_manager.get_sentiment(pair)
            
            risk_params = await self.risk_manager.calculate(
                pair=pair, direction=SignalAction.HOLD, strategy=strategy_decision.strategy,
                timeframe=tf_selection.selected_timeframe, account_balance=account_balance,
                open_trades=open_trades, trading_mode=trading_mode, indicators=indicators
            )

            raw_action, raw_reason = self.signal_gen.generate_raw_signal(
                regime_res=regime_res, strategy_res=strategy_decision,
                sentiment_res=sentiment_res, indicators=indicators,
                active_zones=active_zones, trading_mode=trading_mode
            )
            
            if raw_action != SignalAction.HOLD:
                risk_params = await self.risk_manager.calculate(
                    pair=pair, direction=raw_action, strategy=strategy_decision.strategy,
                    timeframe=tf_selection.selected_timeframe, account_balance=account_balance,
                    open_trades=open_trades, trading_mode=trading_mode, indicators=indicators
                )

            # Fix: Handle both Enum and String for selected_timeframe
            tf_key = str(tf_selection.selected_timeframe)
            if hasattr(tf_selection.selected_timeframe, 'value'):
                tf_key = tf_selection.selected_timeframe.value

            final_conf, _ = self.confidence_aggregator.calculate_final_confidence(
                regime_conf=regime_res.confidence, strategy_conf=strategy_decision.confidence,
                timeframe_score=tf_selection.score_breakdown.get(tf_key, 0),
                sentiment_score=sentiment_res.pair_score, risk_score=risk_params.risk_score
            )
            
            is_dup = any(t['pair'] == pair and t['action'] == raw_action for t in open_trades)
            validation_passed, failed_checks = self.validator.validate_signal(
                action=raw_action, regime_res=regime_res, tf_selection=tf_selection,
                sentiment_res=sentiment_res, risk_params=risk_params, is_duplicate=is_dup
            )

            min_conf = self.config.get('minimum_signal_confidence', 0.70)
            if is_anomalous: min_conf = 0.85
            final_action = raw_action if validation_passed and final_conf >= min_conf else SignalAction.HOLD

            reason = f"{raw_reason} Validation Passed: {validation_passed}. "
            if failed_checks:
                reason += f"Blocks: {', '.join(failed_checks)}"

            # 3. Assemble Signal
            # For Pydantic gt=0 fields, ensure we pass None instead of 0.0 if HOLD
            sl_price = risk_params.stop_loss_price if final_action != SignalAction.HOLD else None
            tp_price = risk_params.take_profit_price if final_action != SignalAction.HOLD else None
            l_size = risk_params.lot_size if final_action != SignalAction.HOLD else None
            e_price = indicators.get('close') if indicators.get('close', 0) > 0 else None

            trade_decision = TradeDecision(
                timestamp=datetime.now(timezone.utc),
                pair=pair, action=final_action, strategy=strategy_decision.strategy,
                timeframe=tf_selection.selected_timeframe, session=tf_selection.session,
                entry_price=e_price, 
                stop_loss=sl_price if sl_price and sl_price > 0 else None,
                take_profit=tp_price if tp_price and tp_price > 0 else None,
                lot_size=l_size if l_size and l_size > 0 else None,
                confidence=final_conf, reason=reason, timeframe_scores=tf_selection.score_breakdown,
                regime_confidence=regime_res.confidence, strategy_confidence=strategy_decision.confidence,
                sentiment_score=sentiment_res.pair_score, risk_score=risk_params.risk_score,
                bars_in_regime=regime_res.bars_in_regime, duration_warning=regime_res.duration_warning
            )

            signal = BackendSignal(
                signal_id=uuid.uuid4(), generated_at=datetime.now(timezone.utc),
                pair=pair, trade_decision=trade_decision, regime_result=regime_res,
                sentiment_result=sentiment_res, risk_params=risk_params,
                model_version="1.0.0", is_valid=validation_passed,
                expires_at=datetime.now(timezone.utc) + timedelta(minutes=120)
            )

            try:
                cache_key = f"signal:{pair}:{tf_key}"
                signal_json = signal.model_dump_json()
                await self.redis.set(cache_key, signal_json, ex=7200)
                await self.redis.set(f"signal:{pair}:latest", signal_json)
                
                # PUBLISH to WebSocket channel
                await self.redis.publish(f"channel:signals:{pair}", signal_json)
            except: pass

            return signal

        except Exception as e:
            logger.error(f"Error in Decision Pipeline for {pair}: {e}", exc_info=True)
            return self._build_hold_signal(pair, str(e))

    def _build_hold_signal(self, pair: str, error_msg: str) -> BackendSignal:
        now = datetime.now(timezone.utc)
        decision = TradeDecision(
            timestamp=now, pair=pair, action=SignalAction.HOLD, strategy=Strategy.SKIP,
            timeframe=Timeframe.H1, session=Session.DEAD_ZONE, confidence=0.0,
            reason=f"ERROR: {error_msg}", regime_confidence=0.0, strategy_confidence=0.0,
            sentiment_score=0.0, risk_score=1.0
        )
        return BackendSignal(
            signal_id=uuid.uuid4(), generated_at=now, pair=pair, trade_decision=decision,
            model_version="error", is_valid=False, expires_at=now + timedelta(minutes=60)
        )
