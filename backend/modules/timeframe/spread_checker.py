from typing import Dict, Any, Tuple, Optional
import yaml
import os

class SpreadChecker:
    def __init__(self):
        # Load spread limits from risk.yaml
        config_path = os.path.join(os.path.dirname(__file__), "../../config/risk.yaml")
        if os.path.exists(config_path):
            with open(config_path, "r") as f:
                self.limits = yaml.safe_load(f).get('spread_limits', {})
        else:
            self.limits = {}

    def is_acceptable(self, timeframe: str, current_spread: float) -> Tuple[bool, Optional[str]]:
        """
        Checks if the current spread is acceptable for the given timeframe.
        """
        limit = self.limits.get(timeframe)
        
        if limit is None:
            return True, None # No limit defined
            
        if current_spread > limit:
            return False, f"Spread {current_spread:.1f} exceeds limit {limit:.1f} for {timeframe}"
            
        return True, None
