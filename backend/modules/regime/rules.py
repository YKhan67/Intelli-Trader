import pandas as pd
from typing import Dict, Any, Tuple, List
from backend.modules.models import Regime

def evaluate_regime_rules(df: pd.DataFrame, indicators: Dict[str, Any], config: Dict[str, Any]) -> Tuple[Regime, float, List[str]]:
    """
    LOGICAL FIX: Zero-Fog Regime Rules.
    Reduces 'UNKNOWN' states by providing clear fallbacks for neutral markets.
    """
    if df is None or df.empty:
        return Regime.UNKNOWN, 0.0, []

    required = ['ema_200', 'adx_14', 'di_plus', 'di_minus', 'rsi_14']
    for k in required:
        if indicators.get(k) is None:
            return Regime.UNKNOWN, 0.0, ["WAITING_FOR_INDICATORS"]

    close = float(df['close'].iloc[-1])
    ema_200 = float(indicators.get('ema_200'))
    adx = float(indicators.get('adx_14'))
    di_plus = float(indicators.get('di_plus'))
    di_minus = float(indicators.get('di_minus'))
    rsi = float(indicators.get('rsi_14'))
    bb_upper = indicators.get('bb_upper')
    bb_lower = indicators.get('bb_lower')
    atr = indicators.get('atr_14')
    macd_hist = indicators.get('macd_histogram')
    
    adx_threshold = config.get('adx_threshold', 25)
    agreeing_indicators = []
    
    # 1. VOLATILE (Institutional Guard)
    if atr and len(df) > 14:
        # Measure current ATR against trailing average
        hist_atr = df['high'].rolling(14).max() - df['low'].rolling(14).min()
        avg_v = hist_atr.mean()
        if atr > 2.0 * avg_v:
            return Regime.VOLATILE, 0.8, ["EXTREME_VOLATILITY"]
            
    # 2. TRENDING_UP (Strict Institutional)
    if adx > adx_threshold and di_plus > di_minus and close > ema_200:
        agreeing_indicators = ["ADX_HIGH", "DI_PLUS_LEAD", "PRICE_ABOVE_EMA200"]
        if macd_hist and macd_hist > 0: agreeing_indicators.append("MACD_POSITIVE")
        return Regime.TRENDING_UP, 1.0, agreeing_indicators
        
    # 3. TRENDING_DOWN (Strict Institutional)
    if adx > adx_threshold and di_minus > di_plus and close < ema_200:
        agreeing_indicators = ["ADX_HIGH", "DI_MINUS_LEAD", "PRICE_BELOW_EMA200"]
        if macd_hist and macd_hist < 0: agreeing_indicators.append("MACD_NEGATIVE")
        return Regime.TRENDING_DOWN, 1.0, agreeing_indicators
        
    # 4. RANGING / CONSOLIDATION (The 'Zero-Fog' Fallback)
    # If the market isn't trending, it is by definition ranging or reversing.
    if bb_lower is not None and bb_upper is not None:
        if bb_lower < close < bb_upper:
            return Regime.RANGING, 0.9, ["BB_INSIDE", "TREND_ABSENT"]
        
    # 5. REVERSAL (Edge Case)
    if bb_upper is not None and bb_lower is not None:
        if close >= bb_upper or close <= bb_lower:
            return Regime.REVERSAL, 0.7, ["BB_EXTREME"]

    # LOGICAL FIX: Never return UNKNOWN if we have price data. 
    # Default to RANGING to allow the AI to look for mean-reversion setups.
    return Regime.RANGING, 0.5, ["DEFAULT_CONSOLIDATION"]
