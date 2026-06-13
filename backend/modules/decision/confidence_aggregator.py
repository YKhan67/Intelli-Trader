from typing import Dict, Any, Tuple
import yaml
import os

class ConfidenceAggregator:
    def __init__(self, config: Dict[str, Any]):
        self.weights = config.get('weights', {})
        self.min_confidence = config.get('minimum_signal_confidence', 0.70)

    def calculate_final_confidence(self, 
                                   regime_conf: float,
                                   strategy_conf: float,
                                   timeframe_score: float, # 0-100
                                   sentiment_score: float, # -1 to 1, normalized to 0-1
                                   risk_score: float # 0-1
                                   ) -> Tuple[float, Dict[str, float]]:
        """
        Combines confidence scores from all modules.
        """
        # Normalize inputs
        tf_norm = timeframe_score / 100.0
        sent_norm = (sentiment_score + 1.0) / 2.0
        risk_inverted = 1.0 - risk_score
        
        # Apply weights
        w = self.weights
        final_score = (
            (regime_conf * w.get('regime_confidence', 0.30)) +
            (strategy_conf * w.get('strategy_confidence', 0.25)) +
            (tf_norm * w.get('timeframe_score', 0.15)) +
            (sent_norm * w.get('sentiment_alignment', 0.20)) +
            (risk_inverted * w.get('risk_score_inverted', 0.10))
        )
        
        breakdown = {
            "regime": regime_conf,
            "strategy": strategy_conf,
            "timeframe": tf_norm,
            "sentiment": sent_norm,
            "risk_inverted": risk_inverted
        }
        
        return round(final_score, 4), breakdown
