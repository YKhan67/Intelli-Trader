import pandas as pd
from typing import Dict, Any, Tuple, List
from backend.modules.models import Regime

def evaluate_regime_rules(df: pd.DataFrame, indicators: Dict[str, Any], config: Dict[str, Any]) -> Tuple[Regime, float, List[str]]:
    """
    Evaluates rule-based logic for market regimes with safety checks for None values.
    """
    if df is None or df.empty:
        return Regime.UNKNOWN, 0.0, []

    # Critical indicators check - manual loop to avoid built-in shadowing issues if any
    required = ['ema_200', 'adx_14', 'di_plus', 'di_minus', 'rsi_14']
    for k in required:
        if indicators.get(k) is None:
            return Regime.UNKNOWN, 0.0, ["WAITING_FOR_INDICATORS"]

    close = df['close'].iloc[-1]
    ema_200 = indicators.get('ema_200')
    adx = indicators.get('adx_14')
    di_plus = indicators.get('di_plus')
    di_minus = indicators.get('di_minus')
    rsi = indicators.get('rsi_14')
    bb_upper = indicators.get('bb_upper')
    bb_lower = indicators.get('bb_lower')
    bb_bandwidth = indicators.get('bb_bandwidth')
    atr = indicators.get('atr_14')
    macd_hist = indicators.get('macd_histogram')
    
    adx_threshold = config.get('adx_threshold', 25)
    agreeing_indicators = []
    
    # 1. VOLATILE
    if atr and len(df) > 14:
        avg_atr = df['high'].iloc[-14:].max() - df['low'].iloc[-14:].min() 
        if atr > 2.0 * (avg_atr / 14):
            agreeing_indicators.append("ATR_VOLATILITY")
            
    # 2. TRENDING_UP
    if adx > adx_threshold and di_plus > di_minus and close > ema_200:
        agreeing_indicators = ["ADX_HIGH", "DI_PLUS_LEAD", "PRICE_ABOVE_EMA200"]
        if macd_hist and macd_hist > 0: agreeing_indicators.append("MACD_POSITIVE")
        if rsi and rsi > 50: agreeing_indicators.append("RSI_BULLISH")
        return Regime.TRENDING_UP, 1.0, agreeing_indicators
        
    # 3. TRENDING_DOWN
    if adx > adx_threshold and di_minus > di_plus and close < ema_200:
        agreeing_indicators = ["ADX_HIGH", "DI_MINUS_LEAD", "PRICE_BELOW_EMA200"]
        if macd_hist and macd_hist < 0: agreeing_indicators.append("MACD_NEGATIVE")
        if rsi and rsi < 50: agreeing_indicators.append("RSI_BEARISH")
        return Regime.TRENDING_DOWN, 1.0, agreeing_indicators
        
    # 4. RANGING
    if adx < adx_threshold and rsi and 35 < rsi < 65 and bb_lower is not None and bb_upper is not None and bb_lower < close < bb_upper:
        agreeing_indicators = ["ADX_LOW", "RSI_NEUTRAL", "BB_INSIDE"]
        return Regime.RANGING, 0.9, agreeing_indicators
        
    # 5. BREAKOUT
    if bb_bandwidth and bb_bandwidth < config.get('bb_squeeze_threshold', 0.001):
        agreeing_indicators = ["BB_SQUEEZE"]
        return Regime.BREAKOUT, 0.8, agreeing_indicators

    # 6. REVERSAL
    if bb_upper is not None and bb_lower is not None:
        if (close >= bb_upper or close <= bb_lower) and macd_hist:
            agreeing_indicators = ["BB_EXTREME", "MACD_SHRINKING"]
            return Regime.REVERSAL, 0.7, agreeing_indicators

    return Regime.UNKNOWN, 0.0, []
