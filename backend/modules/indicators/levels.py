import pandas as pd
import numpy as np
from typing import Dict, Any

def calculate_level_indicators(df: pd.DataFrame, config: Dict[str, Any]) -> pd.DataFrame:
    """Calculates Daily Pivot Points and VWAP with daily resets."""
    result = pd.DataFrame(index=df.index)
    
    # 1. Pivot Points (Classic)
    # Need to group by date to get daily High, Low, Close
    # Since Forex is 24h, we use the previous day's data for today's pivots.
    
    # Ensure index is datetime and UTC
    df_daily = df.resample('1D').agg({'high': 'max', 'low': 'min', 'close': 'last'})
    df_daily_shifted = df_daily.shift(1) # Previous day's data
    
    # Map previous day's HLC back to the intraday dataframe
    merged = df.assign(date=df.index.date).merge(
        df_daily_shifted.assign(date=df_daily_shifted.index.date),
        on='date', 
        how='left', 
        suffixes=('', '_prev')
    )
    merged.index = df.index
    
    p = (merged['high_prev'] + merged['low_prev'] + merged['close_prev']) / 3
    result['pivot'] = p
    result['r1'] = 2 * p - merged['low_prev']
    result['s1'] = 2 * p - merged['high_prev']
    result['r2'] = p + (merged['high_prev'] - merged['low_prev'])
    result['s2'] = p - (merged['high_prev'] - merged['low_prev'])
    result['r3'] = merged['high_prev'] + 2 * (p - merged['low_prev'])
    result['s3'] = merged['low_prev'] - 2 * (merged['high_prev'] - p)
    
    # 2. VWAP
    # VWAP = sum(price * volume) / sum(volume) reset daily
    df['pv'] = df['close'] * df['volume']
    grouped = df.groupby(df.index.date)
    
    cumulative_pv = grouped['pv'].cumsum()
    cumulative_vol = grouped['volume'].cumsum()
    
    result['vwap'] = cumulative_pv / cumulative_vol
    
    return result
