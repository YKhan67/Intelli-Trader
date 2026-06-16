import pandas as pd
from typing import List, Dict, Any, Tuple
from datetime import datetime, timedelta

class WalkForwardOptimizer:
    def __init__(self, config: Dict[str, Any]):
        self.BT_CFG = config.get('backtesting', {}).get('walk_forward', {})
        self.train_years = self.BT_CFG.get('train_years', 3)
        self.val_years = self.BT_CFG.get('validate_years', 1)
        self.test_years = self.BT_CFG.get('test_years', 1)
        self.roll_days = self.BT_CFG.get('roll_days', 90)

    def generate_windows(self, start_date: datetime, end_date: datetime) -> List[Dict[str, datetime]]:
        """
        Splits data into overlapping train/test windows.
        """
        windows = []
        current_test_start = start_date + timedelta(days=365 * self.train_years)
        
        while current_test_start + timedelta(days=self.roll_days) <= end_date:
            train_start = current_test_start - timedelta(days=365 * self.train_years)
            test_end = current_test_start + timedelta(days=self.roll_days)
            
            windows.append({
                "train_start": train_start,
                "train_end": current_test_start,
                "test_start": current_test_start,
                "test_end": test_end
            })
            
            current_test_start += timedelta(days=self.roll_days)
            
        return windows
