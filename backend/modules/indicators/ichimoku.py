import pandas as pd
from ta.trend import IchimokuIndicator
from typing import Dict, Any

def calculate_ichimoku_indicators(df: pd.DataFrame, config: Dict[str, Any]) -> pd.DataFrame:
    """Calculates full Ichimoku system."""
    result = pd.DataFrame(index=df.index)
    
    tenkan_period = config.get('tenkan_period', 9)
    kijun_period = config.get('kijun_period', 26)
    senkou_b_period = config.get('senkou_b_period', 52)
    displacement = config.get('displacement', 26)
    
    ichimoku = IchimokuIndicator(
        high=df['high'], 
        low=df['low'], 
        window1=tenkan_period, 
        window2=kijun_period, 
        window3=senkou_b_period
    )
    
    result['tenkan'] = ichimoku.ichimoku_a()
    result['kijun'] = ichimoku.ichimoku_b()
    # Senkou Span A and B are usually plotted 26 periods ahead.
    # The ta library provides them at the current bar (un-shifted).
    result['senkou_a'] = ichimoku.ichimoku_a().shift(displacement)
    result['senkou_b'] = ichimoku.ichimoku_b().shift(displacement)
    # Chikou Span is close price shifted 26 periods back.
    result['chikou'] = df['close'].shift(-displacement)
    
    return result
