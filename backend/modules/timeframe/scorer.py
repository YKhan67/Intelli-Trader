from typing import Dict, Any
from backend.modules.models import Strategy, Session, Timeframe

class TimeframeScorer:
    def __init__(self, config: Dict[str, Any]):
        self.matrix = config.get('scoring_matrix', {})
        self.boosts = config.get('session_boosts', {})

    def score_all(self, strategy: Strategy, session: Session) -> Dict[str, float]:
        """
        Scores each timeframe for the current strategy and session.
        """
        scores = {}
        timeframes = ["M5", "M15", "M30", "H1", "H4"]
        
        # Get base scores for the strategy
        strategy_val = strategy.value if hasattr(strategy, 'value') else strategy
        strategy_scores = self.matrix.get(strategy_val, {})
        
        # Get session boosts
        session_val = session.value if hasattr(session, 'value') else session
        session_boosts = self.boosts.get(session_val, {})

        for tf in timeframes:
            base_score = strategy_scores.get(tf, 0)
            boost = session_boosts.get(tf, 0)
            
            # Combine score
            scores[tf] = float(base_score + boost)
            
        return scores
