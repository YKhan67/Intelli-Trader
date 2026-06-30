from datetime import datetime
from enum import Enum
from typing import Optional, Dict, List, Any
from uuid import UUID
from pydantic import BaseModel, Field, ConfigDict

# --- Enums ---

class CurrencyPair(str, Enum):
    EURUSD = "EURUSD"
    GBPUSD = "GBPUSD"
    USDJPY = "USDJPY"
    USDCHF = "USDCHF"
    AUDUSD = "AUDUSD"
    NZDUSD = "NZDUSD"
    USDCAD = "USDCAD"
    XAUUSD = "XAUUSD"
    BTCUSD = "BTCUSD"

class Timeframe(str, Enum):
    M1 = "M1"
    M5 = "M5"
    M15 = "M15"
    M30 = "M30"
    H1 = "H1"
    H4 = "H4"
    D1 = "D1"

class Regime(str, Enum):
    TRENDING_UP = "TRENDING_UP"
    TRENDING_DOWN = "TRENDING_DOWN"
    RANGING = "RANGING"
    BREAKOUT = "BREAKOUT"
    REVERSAL = "REVERSAL"
    VOLATILE = "VOLATILE"
    UNKNOWN = "UNKNOWN"

class Strategy(str, Enum):
    TREND_FOLLOW = "TREND_FOLLOW"
    MEAN_REVERSION = "MEAN_REVERSION"
    BREAKOUT = "BREAKOUT"
    REVERSAL = "REVERSAL"
    SCALP = "SCALP"
    SKIP = "SKIP"

class Session(str, Enum):
    ASIAN = "ASIAN"
    LONDON = "LONDON"
    LONDON_OPEN = "LONDON_OPEN"
    NEW_YORK = "NEW_YORK"
    NEW_YORK_OPEN = "NEW_YORK_OPEN"
    OVERLAP = "OVERLAP"
    DEAD_ZONE = "DEAD_ZONE"

class Direction(str, Enum):
    LONG = "LONG"
    SHORT = "SHORT"
    NEUTRAL = "NEUTRAL"

class OrderStatus(str, Enum):
    PENDING = "PENDING"
    OPEN = "OPEN"
    PARTIAL = "PARTIAL"
    CLOSED = "CLOSED"
    CANCELLED = "CANCELLED"

class SignalAction(str, Enum):
    BUY = "BUY"
    SELL = "SELL"
    HOLD = "HOLD"
    CLOSE = "CLOSE"

class TradeType(str, Enum):
    PAPER = "PAPER"
    LIVE = "LIVE"
    SEEDED = "SEEDED"

class ImpactLevel(str, Enum):
    HIGH = "HIGH"
    MEDIUM = "MEDIUM"
    LOW = "LOW"

class ModelStatus(str, Enum):
    PAPER = "PAPER"
    LIVE = "LIVE"
    RETIRED = "RETIRED"
    FAILED = "FAILED"

class AlertSeverity(str, Enum):
    LOW = "LOW"
    MEDIUM = "MEDIUM"
    HIGH = "HIGH"
    CRITICAL = "CRITICAL"

class ExitReason(str, Enum):
    TAKE_PROFIT = "TAKE_PROFIT"
    STOP_LOSS = "STOP_LOSS"
    PARTIAL_CLOSE = "PARTIAL_CLOSE"
    MANUAL_CLOSE = "MANUAL_CLOSE"
    CIRCUIT_BREAKER = "CIRCUIT_BREAKER"
    REGIME_CHANGE = "REGIME_CHANGE"

# --- Pydantic Models ---

class OHLCVBar(BaseModel):
    model_config = ConfigDict(use_enum_values=True)

    pair: CurrencyPair = Field(..., description="Currency pair of the bar")
    timeframe: Timeframe = Field(..., description="Timeframe of the bar")
    timestamp: datetime = Field(..., description="Timezone-aware UTC timestamp")
    open: float = Field(..., gt=0, description="Opening price")
    high: float = Field(..., gt=0, description="Highest price during the interval")
    low: float = Field(..., gt=0, description="Lowest price during the interval")
    close: float = Field(..., gt=0, description="Closing price")
    volume: float = Field(..., description="Trading volume")
    spread_pips: float = Field(..., description="Spread in pips")

    @classmethod
    def from_db_row(cls, row: Any):
        """Stub for future database mapping"""
        pass

class IndicatorSet(BaseModel):
    model_config = ConfigDict(use_enum_values=True)

    bar_id: Optional[str] = Field(None, description="Unique identifier for the corresponding OHLCV bar")
    pair: CurrencyPair = Field(..., description="Currency pair")
    timeframe: Timeframe = Field(..., description="Timeframe")
    timestamp: datetime = Field(..., description="Timezone-aware UTC timestamp")

    # EMA
    ema_9: Optional[float] = Field(None, description="9-period Exponential Moving Average")
    ema_21: Optional[float] = Field(None, description="21-period Exponential Moving Average")
    ema_50: Optional[float] = Field(None, description="50-period Exponential Moving Average")
    ema_200: Optional[float] = Field(None, description="200-period Exponential Moving Average")

    # RSI
    rsi_7: Optional[float] = Field(None, description="7-period Relative Strength Index")
    rsi_14: Optional[float] = Field(None, description="14-period Relative Strength Index")

    # MACD
    macd_line: Optional[float] = Field(None, description="MACD Line")
    macd_signal: Optional[float] = Field(None, description="MACD Signal Line")
    macd_histogram: Optional[float] = Field(None, description="MACD Histogram")

    # Bollinger Bands
    bb_upper: Optional[float] = Field(None, description="Bollinger Bands Upper Band")
    bb_middle: Optional[float] = Field(None, description="Bollinger Bands Middle Band")
    bb_lower: Optional[float] = Field(None, description="Bollinger Bands Lower Band")
    bb_bandwidth: Optional[float] = Field(None, description="Bollinger Bands Bandwidth")
    bb_percent_b: Optional[float] = Field(None, description="Bollinger Bands Percent B")

    # ATR
    atr_14: Optional[float] = Field(None, description="14-period Average True Range")
    atr_percent: Optional[float] = Field(None, description="ATR as a percentage of price")

    # ADX
    adx_14: Optional[float] = Field(None, description="14-period Average Directional Index")
    di_plus: Optional[float] = Field(None, description="Positive Directional Indicator (+DI)")
    di_minus: Optional[float] = Field(None, description="Negative Directional Indicator (-DI)")

    # Stochastic
    stoch_k_fast: Optional[float] = Field(None, description="Fast Stochastic %K")
    stoch_d_fast: Optional[float] = Field(None, description="Fast Stochastic %D")
    stoch_k_slow: Optional[float] = Field(None, description="Slow Stochastic %K")
    stoch_d_slow: Optional[float] = Field(None, description="Slow Stochastic %D")

    # Ichimoku
    tenkan: Optional[float] = Field(None, description="Tenkan-sen (Conversion Line)")
    kijun: Optional[float] = Field(None, description="Kijun-sen (Base Line)")
    senkou_a: Optional[float] = Field(None, description="Senkou Span A (Leading Span A)")
    senkou_b: Optional[float] = Field(None, description="Senkou Span B (Leading Span B)")
    chikou: Optional[float] = Field(None, description="Chikou Span (Lagging Span)")

    # Pivots
    pivot: Optional[float] = Field(None, description="Pivot Point")
    r1: Optional[float] = Field(None, description="Resistance 1")
    r2: Optional[float] = Field(None, description="Resistance 2")
    r3: Optional[float] = Field(None, description="Resistance 3")
    s1: Optional[float] = Field(None, description="Support 1")
    s2: Optional[float] = Field(None, description="Support 2")
    s3: Optional[float] = Field(None, description="Support 3")

    # VWAP
    vwap: Optional[float] = Field(None, description="Volume Weighted Average Price")

class SMCZone(BaseModel):
    model_config = ConfigDict(use_enum_values=True)

    id: str = Field(..., description="Unique identifier for the SMC zone")
    pair: CurrencyPair = Field(..., description="Currency pair")
    timeframe: Timeframe = Field(..., description="Timeframe where the zone was identified")
    zone_type: str = Field(..., description="Type of zone (e.g., Order Block, Liquidity Void)")
    price_high: float = Field(..., gt=0, description="High price of the zone")
    price_low: float = Field(..., gt=0, description="Low price of the zone")
    formed_at: datetime = Field(..., description="Timestamp when the zone was formed")
    is_active: bool = Field(..., description="Whether the zone is currently active")
    is_mitigated: bool = Field(..., description="Whether the zone has been mitigated")
    strength: float = Field(..., ge=0.0, le=1.0, description="Calculated strength of the zone")

class MarketRegimeResult(BaseModel):
    model_config = ConfigDict(use_enum_values=True)

    timestamp: datetime = Field(..., description="Time of the classification")
    pair: CurrencyPair = Field(..., description="Currency pair")
    timeframe: Timeframe = Field(..., description="Primary timeframe for classification")
    regime: Regime = Field(..., description="Detected market regime")
    confidence: float = Field(..., ge=0.0, le=1.0, description="Confidence score of the classification")
    h4_bias: Direction = Field(..., description="H4 timeframe bias")
    h1_regime: Regime = Field(..., description="H1 timeframe regime")
    bars_in_regime: int = Field(..., description="Number of bars since regime started")
    regime_changed: bool = Field(..., description="Whether the regime changed in this bar")
    duration_warning: bool = Field(..., description="True if the regime has persisted for an unusual duration")
    indicators_agreed: int = Field(..., description="Number of indicators that agree with this regime")

class StrategyDecision(BaseModel):
    model_config = ConfigDict(use_enum_values=True)

    timestamp: datetime = Field(..., description="Time of decision")
    pair: CurrencyPair = Field(..., description="Currency pair")
    regime: Regime = Field(..., description="Current market regime")
    strategy: Strategy = Field(..., description="Selected strategy")
    timeframe: Timeframe = Field(..., description="Selected timeframe")
    confidence: float = Field(..., ge=0.0, le=1.0, description="Confidence in the strategy selection")
    session: Session = Field(..., description="Current trading session")
    switch_occurred: bool = Field(..., description="Whether a strategy switch occurred")
    switch_reason: Optional[str] = Field(None, description="Reason for strategy switch")
    alternative_strategy: Optional[Strategy] = Field(None, description="Secondary strategy candidate")
    blocked_reason: Optional[str] = Field(None, description="Reason why strategies were blocked")

class TimeframeSelection(BaseModel):
    model_config = ConfigDict(use_enum_values=True)

    timestamp: datetime = Field(..., description="Time of selection")
    pair: CurrencyPair = Field(..., description="Currency pair")
    selected_timeframe: Timeframe = Field(..., description="The chosen timeframe for execution")
    session: Session = Field(..., description="Current trading session")
    score_breakdown: Dict[str, float] = Field(..., description="Score for each timeframe evaluated")
    block_reason: Optional[str] = Field(None, description="Reason for blocking execution")
    spread_acceptable: bool = Field(..., description="Whether the current spread is within limits")
    confirmation_bars_needed: int = Field(..., description="Number of confirmation bars required")

class SentimentResult(BaseModel):
    model_config = ConfigDict(use_enum_values=True)

    timestamp: datetime = Field(..., description="Time of analysis")
    pair: CurrencyPair = Field(..., description="Currency pair")
    currency_scores: Dict[str, float] = Field(..., description="Sentiment scores for individual currencies")
    pair_score: float = Field(..., ge=-1.0, le=1.0, description="Overall sentiment score for the pair (-1 to 1)")
    pre_news_block: bool = Field(..., description="True if a major news event is upcoming")
    hard_block: bool = Field(..., description="True if sentiment data strongly suggests avoiding trades")
    post_news_window: bool = Field(..., description="True if we are in the volatile window after news")
    cot_bias: Direction = Field(..., description="Commitment of Traders bias")
    top_headlines: List[str] = Field(..., min_length=0, max_length=3, description="Top 3 relevant news headlines")
    sentiment_trend: str = Field(..., description="Trend of sentiment (e.g., improving, deteriorating)")

class RiskParameters(BaseModel):
    model_config = ConfigDict(use_enum_values=True)

    timestamp: datetime = Field(..., description="Time of risk calculation")
    pair: CurrencyPair = Field(..., description="Currency pair")
    strategy: Strategy = Field(..., description="Active strategy")
    lot_size: float = Field(..., ge=0.0, description="Calculated lot size for the trade")
    stop_loss_price: float = Field(..., ge=0.0, description="Price level for stop loss")
    take_profit_price: float = Field(..., ge=0.0, description="Price level for take profit")
    stop_loss_pips: float = Field(..., description="Stop loss distance in pips")
    take_profit_pips: float = Field(..., description="Take profit distance in pips")
    partial_close_price: Optional[float] = Field(None, gt=0, description="Price level for first partial close")
    breakeven_price: Optional[float] = Field(None, gt=0, description="Price level to move stop to breakeven")
    risk_percent: float = Field(..., ge=0.0, le=1.0, description="Percentage of account risked")
    atr_used: float = Field(..., description="ATR value used for volatility scaling")
    rr_ratio: float = Field(..., description="Risk to Reward ratio")
    daily_halt: bool = Field(..., description="True if daily loss limit reached")
    hard_daily_halt: bool = Field(..., description="True if maximum daily drawdown reached")
    weekly_review: bool = Field(..., description="True if weekly review is required")
    correlated_exposure: bool = Field(..., description="True if correlated pairs are already in trades")
    risk_score: float = Field(..., ge=0.0, le=1.0, description="Overall risk score")

class TradeDecision(BaseModel):
    model_config = ConfigDict(use_enum_values=True)

    timestamp: datetime = Field(..., description="Final decision timestamp")
    pair: CurrencyPair = Field(..., description="Currency pair")
    action: SignalAction = Field(..., description="Final action to take")
    strategy: Strategy = Field(..., description="Strategy that generated the signal")
    timeframe: Timeframe = Field(..., description="Timeframe of the signal")
    session: Session = Field(..., description="Trading session at decision time")
    entry_price: Optional[float] = Field(None, gt=0, description="Target entry price")
    stop_loss: Optional[float] = Field(None, gt=0, description="Stop loss price")
    take_profit: Optional[float] = Field(None, gt=0, description="Take profit price")
    lot_size: Optional[float] = Field(None, gt=0, description="Calculated lot size")
    confidence: float = Field(..., ge=0.0, le=1.0, description="Overall confidence in the decision")
    reason: str = Field(..., description="Brief explanation for the decision")
    timeframe_scores: Dict[str, float] = Field(default_factory=dict, description="Score for each timeframe evaluated")
    regime_confidence: float = Field(..., ge=0.0, le=1.0, description="Confidence from Regime module")
    strategy_confidence: float = Field(..., ge=0.0, le=1.0, description="Confidence from Strategy module")
    sentiment_score: float = Field(..., ge=-1.0, le=1.0, description="Score from Sentiment module")
    risk_score: float = Field(..., ge=0.0, le=1.0, description="Score from Risk module")
    bars_in_regime: int = Field(default=0)
    duration_warning: bool = Field(default=False)

class BackendSignal(BaseModel):
    model_config = ConfigDict(use_enum_values=True)

    signal_id: UUID = Field(..., description="Unique identifier for the signal")
    generated_at: datetime = Field(..., description="Creation timestamp")
    pair: CurrencyPair = Field(..., description="Currency pair")
    trade_decision: TradeDecision = Field(..., description="The trade decision details")
    regime_result: Optional[MarketRegimeResult] = Field(None, description="Contextual regime data")
    sentiment_result: Optional[SentimentResult] = Field(None, description="Contextual sentiment data")
    risk_params: Optional[RiskParameters] = Field(None, description="Contextual risk data")
    model_version: str = Field(..., description="Version of the AI model that generated this")
    is_valid: bool = Field(..., description="Whether the signal is currently valid")
    expires_at: datetime = Field(..., description="Expiration timestamp for the signal")

class NewsItem(BaseModel):
    model_config = ConfigDict(use_enum_values=True)

    article_uuid: str = Field(..., description="Unique ID of the news article")
    timestamp: datetime = Field(..., description="Article publication time")
    received_at: datetime = Field(..., description="Time article was ingested")
    source: str = Field(..., description="News source name")
    headline: str = Field(..., description="Article headline")
    body: str = Field(..., description="Full text or summary of the article")
    currencies_mentioned: List[str] = Field(..., description="List of currencies discussed")
    sentiment_score: float = Field(..., ge=-1.0, le=1.0, description="Calculated sentiment score")
    impact: ImpactLevel = Field(default=ImpactLevel.LOW, description="Calculated market impact level")
    is_processed: bool = Field(..., description="Whether the article has been analyzed")

class CalendarEvent(BaseModel):
    model_config = ConfigDict(use_enum_values=True)

    event_id: str = Field(..., description="Unique identifier for the event")
    timestamp: datetime = Field(..., description="Time of the event")
    currency: str = Field(..., description="Currency impacted by the event")
    event_name: str = Field(..., description="Name of the economic indicator or event")
    impact: ImpactLevel = Field(..., description="Expected impact level")
    forecast: Optional[str] = Field(None, description="Forecasted value")
    previous: Optional[str] = Field(None, description="Previous value")
    actual: Optional[str] = Field(None, description="Actual value")
    surprise: Optional[float] = Field(None, description="Numerical difference between actual and forecast")
    surprise_direction: Optional[Direction] = Field(None, description="Direction of the surprise")

class COTData(BaseModel):
    model_config = ConfigDict(use_enum_values=True)

    week_ending: datetime = Field(..., description="Date of the COT report")
    pair: Optional[CurrencyPair] = Field(None, description="Related currency pair")
    currency: str = Field(..., description="Specific currency analyzed")
    long_positions: int = Field(..., description="Number of long positions")
    short_positions: int = Field(..., description="Number of short positions")
    net_position: int = Field(..., description="Net position (Long - Short)")
    institutional_bias: Direction = Field(..., description="Overall institutional bias")
    bias_strength: float = Field(..., ge=0.0, le=1.0, description="Strength of the bias")

class TradeRecord(BaseModel):
    model_config = ConfigDict(use_enum_values=True)

    trade_uuid: UUID = Field(..., description="Unique identifier for the trade")
    broker_order_id: str = Field(..., description="ID assigned by the broker")
    pair: CurrencyPair = Field(..., description="Currency pair")
    strategy: Strategy = Field(..., description="Strategy used for the trade")
    regime: Regime = Field(..., description="Market regime at entry")
    trade_type: TradeType = Field(..., description="Paper or Live trade")
    direction: Direction = Field(..., description="Long or Short")
    timeframe: Timeframe = Field(..., description="Execution timeframe")
    session: Session = Field(..., description="Market session at entry")
    entry_price: float = Field(..., gt=0, description="Actual entry price")
    entry_time: datetime = Field(..., description="Actual entry time")
    lot_size: float = Field(..., gt=0, description="Position size in lots")
    stop_loss: float = Field(..., gt=0, description="Actual stop loss price")
    take_profit: float = Field(..., gt=0, description="Actual take profit price")
    exit_price: Optional[float] = Field(None, gt=0, description="Actual exit price")
    exit_time: Optional[datetime] = Field(None, description="Actual exit time")
    exit_reason: Optional[ExitReason] = Field(None, description="Reason for exiting the trade")
    pips_result: Optional[float] = Field(None, description="Total pips gained or lost")
    profit_loss: Optional[float] = Field(None, description="Gross profit or loss")
    net_profit_loss: Optional[float] = Field(None, description="Net profit or loss after fees")
    confidence_at_entry: float = Field(..., ge=0.0, le=1.0, description="Confidence score at entry")
    status: OrderStatus = Field(..., description="Current status of the trade")

    @classmethod
    def from_db_row(cls, row: Any):
        """Stub for future database mapping"""
        pass

class PerformanceMetrics(BaseModel):
    model_config = ConfigDict(use_enum_values=True)

    date_range_start: datetime = Field(..., description="Start of the evaluation period")
    date_range_end: datetime = Field(..., description="End of the evaluation period")
    total_trades: int = Field(..., description="Total number of trades executed")
    win_rate: float = Field(..., ge=0.0, le=1.0, description="Win rate percentage")
    gross_profit: float = Field(..., description="Total profit from winning trades")
    gross_loss: float = Field(..., description="Total loss from losing trades")
    net_pnl: float = Field(..., description="Net profit or loss")
    max_drawdown: float = Field(..., description="Maximum account drawdown")
    sharpe_ratio: float = Field(..., description="Calculated Sharpe ratio")
    profit_factor: float = Field(..., description="Gross Profit / Gross Loss")
    avg_rr: float = Field(..., description="Average Risk to Reward achieved")
    best_trade_pips: float = Field(..., description="Highest pips gained in a single trade")
    worst_trade_pips: float = Field(..., description="Lowest pips gained in a single trade")

class SystemAlert(BaseModel):
    model_config = ConfigDict(use_enum_values=True)

    alert_id: UUID = Field(..., description="Unique identifier for the alert")
    timestamp: datetime = Field(..., description="Time the alert was triggered")
    alert_type: str = Field(..., description="Category of the alert")
    severity: AlertSeverity = Field(..., description="Severity level")
    message: str = Field(..., description="Detailed alert message")
    pair: Optional[CurrencyPair] = Field(None, description="Currency pair associated with the alert")
    auto_resolved: bool = Field(False, description="Whether the alert was automatically resolved")
    resolved_at: Optional[datetime] = Field(None, description="Time the alert was resolved")

__all__ = [
    "CurrencyPair", "Timeframe", "Regime", "Strategy", "Session", "Direction",
    "OrderStatus", "SignalAction", "TradeType", "ImpactLevel", "ModelStatus",
    "AlertSeverity", "ExitReason", "OHLCVBar", "IndicatorSet", "SMCZone",
    "MarketRegimeResult", "StrategyDecision", "TimeframeSelection",
    "SentimentResult", "RiskParameters", "TradeDecision", "BackendSignal",
    "NewsItem", "CalendarEvent", "COTData", "TradeRecord", "PerformanceMetrics",
    "SystemAlert"
]
