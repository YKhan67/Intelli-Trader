import pandas as pd
from typing import List, Dict, Any

def detect_structure(df: pd.DataFrame, config: Dict[str, Any]) -> List[Dict]:
    """
    Detects Break of Structure (BOS) and Change of Character (CHoCH).
    """
    results = []
    lookback = config.get('swing_lookback', 5)
    
    if len(df) < lookback * 2: return []

    # Simple swing detection
    swings_high = []
    swings_low = []
    
    for i in range(lookback, len(df) - lookback):
        # Swing High
        if all(df['high'].iloc[i] > df['high'].iloc[i-j] for j in range(1, lookback+1)) and \
           all(df['high'].iloc[i] > df['high'].iloc[i+j] for j in range(1, lookback+1)):
            swings_high.append({"price": df['high'].iloc[i], "index": i, "time": df.index[i]})
            
        # Swing Low
        if all(df['low'].iloc[i] < df['low'].iloc[i-j] for j in range(1, lookback+1)) and \
           all(df['low'].iloc[i] < df['low'].iloc[i+j] for j in range(1, lookback+1)):
            swings_low.append({"price": df['low'].iloc[i], "index": i, "time": df.index[i]})

    # Detect BOS (simplified)
    # If current price breaks the most recent swing high in an uptrend
    if len(swings_high) > 1:
        last_high = swings_high[-1]
        for i in range(last_high['index'] + 1, len(df)):
            if df['close'].iloc[i] > last_high['price']:
                results.append({
                    "zone_type": "BOS_BULLISH",
                    "price_high": df['high'].iloc[i],
                    "price_low": last_high['price'],
                    "formed_at": df.index[i],
                    "strength": 0.8
                })
                break

    if len(swings_low) > 1:
        last_low = swings_low[-1]
        for i in range(last_low['index'] + 1, len(df)):
            if df['close'].iloc[i] < last_low['price']:
                results.append({
                    "zone_type": "BOS_BEARISH",
                    "price_high": last_low['price'],
                    "price_low": df['low'].iloc[i],
                    "formed_at": df.index[i],
                    "strength": 0.8
                })
                break

    return results
