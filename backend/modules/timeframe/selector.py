import yaml
import os
from datetime import datetime, timezone
from typing import Dict, Any, List, Optional
from backend.modules.models import (
    TimeframeSelection, 
    StrategyDecision, 
    MarketRegimeResult, 
    Timeframe, 
    Session
)
from backend.database.redis_client import get_redis_client

from .session_detector import SessionDetector
from .scorer import TimeframeScorer
from .spread_checker import SpreadChecker

class TimeframeSelector:
    def __init__(self):
        config_path = os.path.join(os.path.dirname(__file__), "../../config/timeframes.yaml")
        with open(config_path, "r") as f:
            self.config = yaml.safe_load(f)
            
        self.session_detector = SessionDetector()
        self.scorer = TimeframeScorer(self.config)
        self.spread_checker = SpreadChecker()
        self.redis = get_redis_client()

    async def select(self, 
                     strategy_decision: StrategyDecision, 
                     regime_result: MarketRegimeResult, 
                     current_spread_pips: float, 
                     is_trade_open: bool,
                     dt: datetime = None) -> TimeframeSelection:
        """
        Selects the optimal trading timeframe.
        """
        pair = strategy_decision.pair
        redis_key = f"timeframe:locked:{pair}"

        # 1. Lock timeframe if trade is open
        if is_trade_open:
            locked = await self.redis.get(redis_key)
            if locked:
                return await self._build_selection(
                    pair, Timeframe(locked), "Trade open", {}, current_spread_pips, True, dt
                )

        # 2. Detect Session
        session = await self.session_detector.get_current_session(dt)
        
        # 3. Get Scores
        scores = self.scorer.score_all(strategy_decision.strategy, session)
        
        # 4. Filter and Select
        allowed_timeframes = ["M5", "M15", "M30", "H1", "H4"]
        
        # Session Blocks
        session_val = session.value if hasattr(session, 'value') else session
        blocks = self.config.get('session_blocks', {}).get(session_val, [])
        allowed_timeframes = [tf for tf in allowed_timeframes if tf not in blocks]
        
        if not allowed_timeframes:
            return await self._build_selection(
                pair, Timeframe.H1, f"All timeframes blocked in {session_val}", scores, current_spread_pips, False, dt
            )

        # Spread Check & Scoring
        best_tf = None
        best_score = -1
        block_reason = None
        
        # Sort timeframes by score descending
        sorted_tfs = sorted(allowed_timeframes, key=lambda x: scores.get(x, 0), reverse=True)
        
        for tf in sorted_tfs:
            score = scores.get(tf, 0)
            
            # Minimum score check
            min_score = self.config.get('minimum_selection_score', 60)
            if score < min_score:
                continue
                
            # Spread check
            acceptable, reason = self.spread_checker.is_acceptable(tf, current_spread_pips)
            if not acceptable:
                # Try moving up one timeframe if spread is too high
                continue
                
            best_tf = tf
            best_score = score
            break

        if not best_tf:
            return await self._build_selection(
                pair, Timeframe.H1, "No timeframe met minimum score and spread requirements", scores, current_spread_pips, False, dt
            )

        # 5. Build and Cache Result
        selection = await self._build_selection(
            pair, Timeframe(best_tf), None, scores, current_spread_pips, True, dt
        )
        
        # Cache for next call if trade opens
        await self.redis.set(redis_key, best_tf, ex=3600) # 1 hour cache
        
        return selection

    async def _build_selection(self, 
                               pair: str, 
                               timeframe: Timeframe, 
                               block_reason: Optional[str], 
                               scores: Dict[str, float],
                               spread: float,
                               acceptable: bool,
                               dt: datetime = None) -> TimeframeSelection:
        return TimeframeSelection(
            timestamp=dt if dt else datetime.now(timezone.utc),
            pair=pair,
            selected_timeframe=timeframe,
            session=await self.session_detector.get_current_session(dt),
            score_breakdown=scores,
            block_reason=block_reason,
            spread_acceptable=acceptable,
            confirmation_bars_needed=3 # Default
        )
