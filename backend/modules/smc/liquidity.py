import pandas as pd
from typing import List, Dict, Any

def detect_liquidity(df: pd.DataFrame, config: Dict[str, Any]) -> List[Dict]:
    """
    Detects Liquidity Zones (Equal Highs and Equal Lows).
    """
    results = []
    tolerance_pips = config.get('pip_tolerance', 2.0)
    lookback = 50 # bars to look back for equal levels
    
    if len(df) < lookback: return []

    # Check for Equal Highs (Liquidity above)
    recent_highs = df['high'].iloc[-lookback:].values
    for i in range(len(recent_highs)):
        for j in range(i + 10, len(recent_highs)): # Minimum 10 bars apart
            diff = abs(recent_highs[i] - recent_highs[j])
            if diff < (tolerance_pips * 0.0001):
                results.append({
                    "zone_type": "EQUAL_HIGHS",
                    "price_high": max(recent_highs[i], recent_highs[j]),
                    "price_low": min(recent_highs[i], recent_highs[j]),
                    "formed_at": df.index[j - lookback],
                    "strength": 0.7
                })
                break

    # Check for Equal Lows (Liquidity below)
    recent_lows = df['low'].iloc[-lookback:].values
    for i in range(len(recent_lows)):
        for j in range(i + 10, len(recent_lows)):
            diff = abs(recent_lows[i] - recent_lows[j])
            if diff < (tolerance_pips * 0.0001):
                results.append({
                    "zone_type": "EQUAL_LOWS",
                    "price_high": max(recent_lows[i], recent_lows[j]),
                    "price_low": min(recent_lows[i], recent_lows[j]),
                    "formed_at": df.index[j - lookback],
                    "strength": 0.7
                })
                break
                
    return results
