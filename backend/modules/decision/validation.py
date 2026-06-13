from typing import List, Tuple, Dict, Any
from backend.modules.models import (
    SignalAction, 
    Direction, 
    MarketRegimeResult, 
    SentimentResult, 
    RiskParameters,
    TimeframeSelection
)

class SignalValidator:
    def validate_signal(self, 
                        action: SignalAction,
                        regime_res: MarketRegimeResult,
                        tf_selection: TimeframeSelection,
                        sentiment_res: SentimentResult,
                        risk_params: RiskParameters,
                        is_duplicate: bool) -> Tuple[bool, List[str]]:
        """
        Runs final validation checks.
        """
        failed_checks = []

        if action == SignalAction.HOLD:
            return False, ["Signal action is HOLD."]

        # 1. H4 Macro Bias Alignment
        # If signal is BUY but H4 is SHORT, block
        if action == SignalAction.BUY and regime_res.h4_bias == Direction.SHORT:
            failed_checks.append("Macro alignment: Signal is BUY but H4 bias is SHORT.")
        if action == SignalAction.SELL and regime_res.h4_bias == Direction.LONG:
            failed_checks.append("Macro alignment: Signal is SELL but H4 bias is LONG.")

        # 2. Spread Check
        if not tf_selection.spread_acceptable:
            failed_checks.append(f"Spread block: {tf_selection.block_reason}")

        # 3. Circuit Breakers
        if risk_params.hard_daily_halt:
            failed_checks.append("Circuit Breaker: Hard Daily Halt active.")
        if risk_params.daily_halt:
            failed_checks.append("Circuit Breaker: Daily Loss Limit reached.")

        # 4. Sentiment Blocks
        if sentiment_res.hard_block:
            failed_checks.append("Sentiment block: Extreme negative sentiment or volatility detected.")
        if sentiment_res.pre_news_block:
            failed_checks.append("News block: High-impact news event approaching within 2 hours.")

        # 5. Duplicate Trade
        if is_duplicate:
            failed_checks.append(f"Duplicate check: A trade in the same direction is already open for {regime_res.pair}.")

        # 6. Lot Size Check
        if risk_params.lot_size <= 0:
            failed_checks.append("Risk block: Calculated lot size is 0.")

        validation_passed = len(failed_checks) == 0
        return validation_passed, failed_checks
