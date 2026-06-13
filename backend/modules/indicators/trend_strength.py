import pandas as pd
from ta.trend import ADXIndicator
from typing import Dict, Any

def calculate_trend_strength_indicators(df: pd.DataFrame, config: Dict[str, Any]) -> pd.DataFrame:
    """Calculates ADX, DI+, and DI-."""
    result = pd.DataFrame(index=df.index)
    
    adx_period = config.get('adx_period', 14)
    adx_indicator = ADXIndicator(high=df['high'], low=df['low'], close=df['close'], window=adx_period)
    
    result['adx_14'] = adx_indicator.adx()
    result['di_plus'] = adx_indicator.adx_pos()
    result['di_minus'] = adx_indicator.adx_neg()
    
    return result
