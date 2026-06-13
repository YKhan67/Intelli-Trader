from typing import List, Dict, Any

def calculate_confidence(agreeing_indicators: List[str], total_checked: int, config: Dict[str, Any]) -> float:
    """
    Calculates confidence score (0.0-1.0).
    Based on agreement between rule-based, ML, and indicator counts.
    """
    if total_checked == 0: return 0.0
    
    # Base score from rule-based agreement
    score = len(agreeing_indicators) / total_checked
    
    # Penalty if minimum count not met
    min_needed = config.get('min_indicators_for_confidence', 3)
    if len(agreeing_indicators) < min_needed:
        score *= 0.5
        
    return min(1.0, score)
