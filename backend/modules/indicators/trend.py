import pandas as pd
from ta.trend import EMAIndicator
from typing import Dict, Any

def calculate_trend_indicators(df: pd.DataFrame, config: Dict[str, Any]) -> pd.DataFrame:
    """Calculates EMA 9, 21, 50, 200."""
    result = pd.DataFrame(index=df.index)
    periods = config.get('ema_periods', [9, 21, 50, 200])
    
    for period in periods:
        col_name = f'ema_{period}'
        ema = EMAIndicator(close=df['close'], window=period)
        result[col_name] = ema.ema_indicator()
    
    return result
