import pandas as pd
from ta.momentum import RSIIndicator, StochasticOscillator
from ta.trend import MACD
from typing import Dict, Any

def calculate_momentum_indicators(df: pd.DataFrame, config: Dict[str, Any]) -> pd.DataFrame:
    """Calculates RSI, MACD, and Stochastic indicators."""
    result = pd.DataFrame(index=df.index)
    
    # RSI
    rsi_periods = config.get('rsi_periods', [7, 14])
    for period in rsi_periods:
        result[f'rsi_{period}'] = RSIIndicator(close=df['close'], window=period).rsi()
        
    # MACD
    macd_cfg = config.get('macd', {'fast': 12, 'slow': 26, 'signal': 9})
    macd = MACD(
        close=df['close'], 
        window_fast=macd_cfg['fast'], 
        window_slow=macd_cfg['slow'], 
        window_sign=macd_cfg['signal']
    )
    result['macd_line'] = macd.macd()
    result['macd_signal'] = macd.macd_signal()
    result['macd_histogram'] = macd.macd_diff()
    
    # Stochastic Fast
    stoch_fast_cfg = config.get('stoch_fast', {'window': 5, 'smooth_window': 3})
    stoch_fast = StochasticOscillator(
        high=df['high'], 
        low=df['low'], 
        close=df['close'], 
        window=stoch_fast_cfg['window'], 
        smooth_window=stoch_fast_cfg['smooth_window']
    )
    result['stoch_k_fast'] = stoch_fast.stoch()
    result['stoch_d_fast'] = stoch_fast.stoch_signal()
    
    # Stochastic Slow
    stoch_slow_cfg = config.get('stoch_slow', {'window': 14, 'smooth_window': 3})
    stoch_slow = StochasticOscillator(
        high=df['high'], 
        low=df['low'], 
        close=df['close'], 
        window=stoch_slow_cfg['window'], 
        smooth_window=stoch_slow_cfg['smooth_window']
    )
    result['stoch_k_slow'] = stoch_slow.stoch()
    result['stoch_d_slow'] = stoch_slow.stoch_signal()
    
    return result
