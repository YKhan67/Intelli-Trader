import pandas as pd
from typing import List, Dict, Any

def detect_fvgs(df: pd.DataFrame, config: Dict[str, Any]) -> List[Dict]:
    """
    Detects Bullish and Bearish Fair Value Gaps (FVG).
    df: OHLCV data
    """
    zones = []
    min_gap_pips = config.get('min_gap_pips', 3.0)
    
    # We need at least 3 bars for an FVG
    if len(df) < 3: return []

    for i in range(2, len(df)):
        # Candle 1: df.iloc[i-2]
        # Candle 2: df.iloc[i-1]
        # Candle 3: df.iloc[i]
        
        # Bullish FVG: Low of candle 3 > High of candle 1
        gap_up = df['low'].iloc[i] - df['high'].iloc[i-2]
        if gap_up > 0:
            # Check pip size (approximate using price * 0.0001 logic or just absolute)
            # For simplicity, we assume price is around 1.0 (Forex)
            if gap_up > (min_gap_pips * 0.0001):
                zones.append({
                    "zone_type": "BULLISH_FVG",
                    "price_high": df['low'].iloc[i],
                    "price_low": df['high'].iloc[i-2],
                    "formed_at": df.index[i-1],
                    "strength": min(1.0, gap_up / 0.001) # Normalized strength
                })
                
        # Bearish FVG: High of candle 3 < Low of candle 1
        gap_down = df['low'].iloc[i-2] - df['high'].iloc[i]
        if gap_down > 0:
            if gap_down > (min_gap_pips * 0.0001):
                zones.append({
                    "zone_type": "BEARISH_FVG",
                    "price_high": df['low'].iloc[i-2],
                    "price_low": df['high'].iloc[i],
                    "formed_at": df.index[i-1],
                    "strength": min(1.0, gap_down / 0.001)
                })
                
    return zones
