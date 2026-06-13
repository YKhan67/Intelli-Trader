from typing import List, Dict, Any, Tuple
from backend.modules.models import (
    SignalAction, 
    Regime, 
    Strategy, 
    Direction, 
    SMCZone, 
    MarketRegimeResult, 
    SentimentResult
)

class SignalGenerator:
    def generate_raw_signal(self, 
                             regime_res: MarketRegimeResult,
                             strategy_res: Any, # StrategyDecision
                             sentiment_res: SentimentResult,
                             indicators: Dict[str, Any],
                             active_zones: List[SMCZone]) -> Tuple[SignalAction, str]:
        """
        Generates raw directional signal from combined module outputs.
        """
        regime = regime_res.regime
        strategy = strategy_res.strategy
        
        # 1. TREND_FOLLOW logic
        if strategy == Strategy.TREND_FOLLOW:
            if regime == Regime.TRENDING_UP and sentiment_res.pair_score > 0 and sentiment_res.cot_bias == Direction.LONG:
                return SignalAction.BUY, "TREND_FOLLOW: Aligned with Bullish Regime, Sentiment and COT."
            if regime == Regime.TRENDING_DOWN and sentiment_res.pair_score < 0 and sentiment_res.cot_bias == Direction.SHORT:
                return SignalAction.SELL, "TREND_FOLLOW: Aligned with Bearish Regime, Sentiment and COT."

        # 2. MEAN_REVERSION logic
        if strategy == Strategy.MEAN_REVERSION and regime == Regime.RANGING:
            rsi = indicators.get('rsi_14')
            price = indicators.get('close')
            
            # Check for support zone
            at_support = any(z.zone_type == "BULLISH_OB" or z.zone_type == "BULLISH_FVG" for z in active_zones if z.price_low <= price <= z.price_high)
            # Check for resistance zone
            at_resistance = any(z.zone_type == "BEARISH_OB" or z.zone_type == "BEARISH_FVG" for z in active_zones if z.price_low <= price <= z.price_high)

            if rsi and rsi < 30 and at_support:
                return SignalAction.BUY, "MEAN_REVERSION: Oversold RSI at SMC Support zone."
            if rsi and rsi > 70 and at_resistance:
                return SignalAction.SELL, "MEAN_REVERSION: Overbought RSI at SMC Resistance zone."

        # 3. BREAKOUT logic
        if strategy == Strategy.BREAKOUT and regime == Regime.BREAKOUT:
            # Check for BOS (Break of Structure) - this would be in active_zones or indicators
            has_bos_bullish = any(z.zone_type == "BOS_BULLISH" for z in active_zones)
            has_bos_bearish = any(z.zone_type == "BOS_BEARISH" for z in active_zones)

            if has_bos_bullish and sentiment_res.pair_score > 0:
                return SignalAction.BUY, "BREAKOUT: Confirmed BOS Bullish with positive sentiment."
            if has_bos_bearish and sentiment_res.pair_score < 0:
                return SignalAction.SELL, "BREAKOUT: Confirmed BOS Bearish with negative sentiment."

        # 4. REVERSAL logic
        if strategy == Strategy.REVERSAL and regime == Regime.REVERSAL:
            # Check for CHoCH (Change of Character)
            has_choch = any("CHoCH" in z.zone_type for z in active_zones) # Assuming structure detected it
            # Sentiment turning: Improving for long, deteriorating for short
            if sentiment_res.sentiment_trend == "IMPROVING" and indicators.get('rsi_14', 50) < 40:
                return SignalAction.BUY, "REVERSAL: Sentiment improving from oversold conditions."
            if sentiment_res.sentiment_trend == "DETERIORATING" and indicators.get('rsi_14', 50) > 60:
                return SignalAction.SELL, "REVERSAL: Sentiment deteriorating from overbought conditions."

        return SignalAction.HOLD, "No clear high-probability setup identified."
