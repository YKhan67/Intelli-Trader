import pandas as pd
from ta.volatility import AverageTrueRange, BollingerBands
from typing import Dict, Any

def calculate_volatility_indicators(df: pd.DataFrame, config: Dict[str, Any]) -> pd.DataFrame:
    """Calculates ATR and Bollinger Bands."""
    result = pd.DataFrame(index=df.index)
    
    # ATR
    atr_period = config.get('atr_period', 14)
    atr_indicator = AverageTrueRange(high=df['high'], low=df['low'], close=df['close'], window=atr_period)
    result['atr_14'] = atr_indicator.average_true_range()
    result['atr_percent'] = (result['atr_14'] / df['close']) * 100
    
    # Bollinger Bands
    bb_cfg = config.get('bollinger', {'window': 20, 'window_dev': 2.0})
    bb = BollingerBands(close=df['close'], window=bb_cfg['window'], window_dev=bb_cfg['window_dev'])
    result['bb_upper'] = bb.bollinger_hband()
    result['bb_middle'] = bb.bollinger_mavg()
    result['bb_lower'] = bb.bollinger_lband()
    result['bb_bandwidth'] = bb.bollinger_wband()
    result['bb_percent_b'] = bb.bollinger_pband()
    
    return result
