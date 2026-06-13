import pandas as pd
import numpy as np
from typing import List, Dict, Any
from datetime import datetime
from backend.modules.models import SMCZone, CurrencyPair, Timeframe

def detect_order_blocks(df: pd.DataFrame, indicators: pd.DataFrame, config: Dict[str, Any]) -> List[Dict]:
    """
    Detects Bullish and Bearish Order Blocks.
    df: OHLCV data
    indicators: Indicator data (needs 'atr_14')
    """
    zones = []
    multiplier = config.get('impulse_atr_multiplier', 3.0)
    lookback = config.get('lookback_bars', 50)
    
    # We only process the recent part of the dataframe for speed
    # but need enough history for ATR and impulse detection.
    if len(df) < lookback + 5: return []

    atr = indicators['atr_14']
    
    for i in range(len(df) - lookback, len(df)):
        if i < 1: continue
        
        # Current bar is at index i
        # We check if there was a strong impulse move ending at i
        # Impulse = Price difference over last few bars > multiplier * ATR
        move = df['close'].iloc[i] - df['open'].iloc[i-3] # 3-bar impulse check
        current_atr = atr.iloc[i]
        
        if pd.isna(current_atr): continue

        # Bullish Order Block Detection
        if move > (multiplier * current_atr):
            # The last bearish candle before the move started
            for j in range(i-3, i- lookback, -1):
                if j < 0: break
                if df['close'].iloc[j] < df['open'].iloc[j]:
                    zone = {
                        "zone_type": "BULLISH_OB",
                        "price_high": df['high'].iloc[j],
                        "price_low": df['low'].iloc[j],
                        "formed_at": df.index[j],
                        "strength": min(1.0, move / (multiplier * current_atr * 2))
                    }
                    zones.append(zone)
                    break
                    
        # Bearish Order Block Detection
        elif move < -(multiplier * current_atr):
            # The last bullish candle before the move started
            for j in range(i-3, i- lookback, -1):
                if j < 0: break
                if df['close'].iloc[j] > df['open'].iloc[j]:
                    zone = {
                        "zone_type": "BEARISH_OB",
                        "price_high": df['high'].iloc[j],
                        "price_low": df['low'].iloc[j],
                        "formed_at": df.index[j],
                        "strength": min(1.0, abs(move) / (multiplier * current_atr * 2))
                    }
                    zones.append(zone)
                    break
    
    return zones
