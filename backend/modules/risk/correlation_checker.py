from typing import List, Dict, Any, Tuple
import yaml
import os

class CorrelationChecker:
    def __init__(self, pairs_config: Dict[str, Any]):
        self.corr_map = {p['symbol']: p.get('correlations', []) for p in pairs_config['pairs']}

    def check_exposure(self, pair: str, open_trade_pairs: List[str]) -> Tuple[bool, float]:
        """
        Checks if opening 'pair' would create too much correlated exposure.
        Returns (is_correlated, size_multiplier)
        """
        correlations = self.corr_map.get(pair, [])
        
        for open_pair in open_trade_pairs:
            if open_pair in correlations:
                return True, 0.5 # Reduce size by 50%
                
        return False, 1.0
