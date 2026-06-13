import asyncio
import os
import yaml
import logging
import uuid
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

from .signal_generator import SignalGenerator
from .confidence_aggregator import ConfidenceAggregator
from .validation import SignalValidator

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
        
        self.redis = get_redis_client()

    async def run_pipeline(self, 
                            pair: str, 
                            df: Any, # OHLCV DataFrame
                            indicators: Dict[str, Any],
                            active_zones: Any,
                            account_balance: float,
                            open_trades: Any,
                            trading_mode: str) -> BackendSignal:
        """
        Orchestrates the full decision pipeline for one pair.
        """
        start_time = asyncio.get_event_loop().time()
        
        try:
            # 0. Ensure indicators has 'close' for risk calculations
            if 'close' not in indicators:
                indicators['close'] = df['close'].iloc[-1]

            # 1. Regime Classifier
            regime_res = await self.regime_classifier.classify(pair, "H1", df, indicators)
            
            # 2. Strategy Selector
            # Need to get context for selector
            # (In production we'd fetch this from DB, but for now we assume it's passed or mocked)
            strategy_decision = await self.strategy_selector.select(
                regime_result=regime_res,
                is_trade_open=len(open_trades) > 0,
                last_trade_result=None, # To be fetched
                pair=pair,
                session=Session.LONDON, # To be detected
                bars_since_regime_start=regime_res.bars_in_regime,
                bars_since_last_loss=10
            )

            # 3. Timeframe Selector
            current_spread = 1.5 # Mock spread for now
            tf_selection = await self.timeframe_selector.select(
                strategy_decision=strategy_decision,
                regime_result=regime_res,
                current_spread_pips=current_spread,
                is_trade_open=len(open_trades) > 0
            )

            # 4. Sentiment Manager
            sentiment_res = await self.sentiment_manager.get_sentiment(pair)

            # 5. Risk Manager
            risk_params = await self.risk_manager.calculate(
                pair=pair,
                direction=SignalAction.HOLD, # Dummy direction for initial calculation
                strategy=strategy_decision.strategy,
                timeframe=tf_selection.selected_timeframe,
                account_balance=account_balance,
                open_trades=open_trades,
                trading_mode=trading_mode,
                indicators=indicators
            )

            # 6. Signal Generator
            raw_action, raw_reason = self.signal_gen.generate_raw_signal(
                regime_res=regime_res,
                strategy_res=strategy_decision,
                sentiment_res=sentiment_res,
                indicators=indicators,
                active_zones=active_zones
            )
            
            # Update risk params if we have a real action
            if raw_action != SignalAction.HOLD:
                risk_params = await self.risk_manager.calculate(
                    pair=pair,
                    direction=raw_action,
                    strategy=strategy_decision.strategy,
                    timeframe=tf_selection.selected_timeframe,
                    account_balance=account_balance,
                    open_trades=open_trades,
                    trading_mode=trading_mode,
                    indicators=indicators
                )

            # 7. Confidence Aggregator
            final_conf, breakdown = self.confidence_aggregator.calculate_final_confidence(
                regime_conf=regime_res.confidence,
                strategy_conf=strategy_decision.confidence,
                timeframe_score=tf_selection.score_breakdown.get(tf_selection.selected_timeframe, 0),
                sentiment_score=sentiment_res.pair_score,
                risk_score=risk_params.risk_score
            )

            # 8. Validation
            # Check if duplicate (same pair and direction already open)
            is_dup = any(t['pair'] == pair and t['action'] == raw_action for t in open_trades)
            
            validation_passed, failed_checks = self.validator.validate_signal(
                action=raw_action,
                regime_res=regime_res,
                tf_selection=tf_selection,
                sentiment_res=sentiment_res,
                risk_params=risk_params,
                is_duplicate=is_dup
            )

            # Final Action Decision
            final_action = raw_action if validation_passed and final_conf >= self.config.get('minimum_signal_confidence', 0.70) else SignalAction.HOLD
            
            reason = f"{raw_reason} Validation Passed: {validation_passed}. "
            if failed_checks:
                reason += f"Blocks: {', '.join(failed_checks)}"

            # 9. Assemble Result
            trade_decision = TradeDecision(
                timestamp=datetime.now(timezone.utc),
                pair=pair,
                action=final_action,
                strategy=strategy_decision.strategy,
                timeframe=tf_selection.selected_timeframe,
                session=tf_selection.session,
                entry_price=indicators.get('close'),
                stop_loss=risk_params.stop_loss_price,
                take_profit=risk_params.take_profit_price,
                lot_size=risk_params.lot_size,
                confidence=final_conf,
                reason=reason,
                regime_confidence=regime_res.confidence,
                strategy_confidence=strategy_decision.confidence,
                sentiment_score=sentiment_res.pair_score,
                risk_score=risk_params.risk_score
            )

            signal = BackendSignal(
                signal_id=uuid.uuid4(),
                generated_at=datetime.now(timezone.utc),
                pair=pair,
                trade_decision=trade_decision,
                regime_result=regime_res,
                sentiment_result=sentiment_res,
                risk_params=risk_params,
                model_version="1.0.0",
                is_valid=validation_passed,
                expires_at=datetime.now(timezone.utc) + timedelta(minutes=120) # 2 hours
            )

            # Store in Redis
            await self.redis.set(f"signal:{pair}", signal.model_dump_json(), ex=3600)
            
            end_time = asyncio.get_event_loop().time()
            processing_duration = end_time - start_time
            if processing_duration > self.config.get('processing_timeout_seconds', 10):
                logger.warning(f"Processing for {pair} took {processing_duration:.2f}s (Limit: 10s)")

            return signal

        except Exception as e:
            logger.error(f"Error in Decision Pipeline for {pair}: {e}", exc_info=True)
            return self._build_hold_signal(pair, str(e))

    def _build_hold_signal(self, pair: str, error_msg: str) -> BackendSignal:
        """Builds a placeholder signal with HOLD action on error."""
        now = datetime.now(timezone.utc)
        
        # We create a minimal TradeDecision
        decision = TradeDecision(
            timestamp=now,
            pair=pair,
            action=SignalAction.HOLD,
            strategy=Strategy.SKIP,
            timeframe=Timeframe.H1,
            session=Session.DEAD_ZONE,
            confidence=0.0,
            reason=f"PIPELINE_ERROR: {error_msg}",
            regime_confidence=0.0,
            strategy_confidence=0.0,
            sentiment_score=0.0,
            risk_score=1.0
        )
        
        return BackendSignal(
            signal_id=uuid.uuid4(),
            generated_at=now,
            pair=pair,
            trade_decision=decision,
            regime_result=None, # This will require model update to allow None
            sentiment_result=None,
            risk_params=None,
            model_version="error",
            is_valid=False,
            expires_at=now + timedelta(minutes=60)
        )
