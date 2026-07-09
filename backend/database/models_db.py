from sqlalchemy import Column, Integer, Float, String, DateTime, Boolean, ForeignKey, JSON, Enum, UniqueConstraint, Index, UUID as SQLUUID
from sqlalchemy.orm import relationship
from .postgres import Base
import uuid
from datetime import datetime, timezone

class CurrencyPairDB(Base):
    __tablename__ = "currency_pairs"
    id = Column(Integer, primary_key=True)
    symbol = Column(String(10), unique=True, nullable=False)
    pip_size = Column(Float, nullable=False)
    pip_value = Column(Float, nullable=False)

class OHLCVBarDB(Base):
    __tablename__ = "ohlcv_bars"
    id = Column(Integer, primary_key=True)
    pair_id = Column(Integer, ForeignKey("currency_pairs.id"), nullable=False)
    timeframe = Column(String(20), nullable=False)
    timestamp = Column(DateTime(timezone=True), nullable=False)
    open = Column(Float, nullable=False)
    high = Column(Float, nullable=False)
    low = Column(Float, nullable=False)
    close = Column(Float, nullable=False)
    volume = Column(Float, nullable=False)
    spread_pips = Column(Float, nullable=False)

    __table_args__ = (
        UniqueConstraint('pair_id', 'timeframe', 'timestamp', name='_pair_tf_ts_uc'),
        Index('idx_ohlcv_lookup', 'pair_id', 'timeframe', 'timestamp'),
    )

class IndicatorDB(Base):
    __tablename__ = "indicators"
    id = Column(Integer, primary_key=True)
    bar_id = Column(Integer, ForeignKey("ohlcv_bars.id"), nullable=False, unique=True)
    # Using JSON for simplicity as indicator set is large and mostly optional
    data = Column(JSON, nullable=False) 

class SMCZoneDB(Base):
    __tablename__ = "smc_zones"
    id = Column(String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    pair_id = Column(Integer, ForeignKey("currency_pairs.id"), nullable=False)
    timeframe = Column(String(20), nullable=False)
    zone_type = Column(String(50), nullable=False)
    price_high = Column(Float, nullable=False)
    price_low = Column(Float, nullable=False)
    formed_at = Column(DateTime(timezone=True), nullable=False)
    is_active = Column(Boolean, default=True)
    is_mitigated = Column(Boolean, default=False)
    strength = Column(Float, nullable=False)

    __table_args__ = (
        Index('idx_smc_lookup', 'pair_id', 'timeframe', 'is_active'),
    )

class RegimeHistoryDB(Base):
    __tablename__ = "regime_history"
    id = Column(Integer, primary_key=True)
    pair_id = Column(Integer, ForeignKey("currency_pairs.id"), nullable=False)
    timestamp = Column(DateTime(timezone=True), nullable=False)
    regime = Column(String(50), nullable=False)
    confidence = Column(Float, nullable=False)
    h4_bias = Column(String(20))
    h1_regime = Column(String(50))
    bars_in_regime = Column(Integer)
    regime_changed = Column(Boolean)
    duration_warning = Column(Boolean)
    indicators_agreed = Column(Integer)

    __table_args__ = (
        Index('idx_regime_ts', 'pair_id', timestamp.desc()),
    )

class StrategyDecisionDB(Base):
    __tablename__ = "strategy_decisions"
    id = Column(Integer, primary_key=True)
    regime_history_id = Column(Integer, ForeignKey("regime_history.id"))
    timestamp = Column(DateTime(timezone=True), nullable=False)
    pair_id = Column(Integer, ForeignKey("currency_pairs.id"), nullable=False)
    regime = Column(String(50), nullable=False)
    strategy = Column(String(50), nullable=False)
    timeframe = Column(String(20), nullable=False)
    confidence = Column(Float, nullable=False)
    session = Column(String(50))
    switch_occurred = Column(Boolean)
    switch_reason = Column(String(255))
    alternative_strategy = Column(String(50))
    blocked_reason = Column(String(255))

class TradeDB(Base):
    __tablename__ = "trades"
    trade_uuid = Column(SQLUUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    broker_order_id = Column(String(100))
    pair_id = Column(Integer, ForeignKey("currency_pairs.id"), nullable=False)
    strategy = Column(String(50))
    regime = Column(String(50))
    trade_type = Column(String(20))
    direction = Column(String(20))
    timeframe = Column(String(20))
    session = Column(String(50))
    entry_price = Column(Float)
    entry_time = Column(DateTime(timezone=True))
    lot_size = Column(Float)
    stop_loss = Column(Float)
    take_profit = Column(Float)
    exit_price = Column(Float)
    exit_time = Column(DateTime(timezone=True))
    exit_reason = Column(String(100))
    pips_result = Column(Float)
    profit_loss = Column(Float)
    net_profit_loss = Column(Float)
    confidence_at_entry = Column(Float)
    status = Column(String(20))

class PerformanceDailyDB(Base):
    __tablename__ = "performance_daily"
    id = Column(Integer, primary_key=True)
    date = Column(DateTime, unique=True)
    total_trades = Column(Integer)
    win_rate = Column(Float)
    net_pnl = Column(Float)
    max_drawdown = Column(Float)

class PerformanceStrategyDB(Base):
    __tablename__ = "performance_strategy"
    id = Column(Integer, primary_key=True)
    strategy = Column(String(50))
    regime = Column(String(50))
    total_trades = Column(Integer)
    win_rate = Column(Float)
    profit_factor = Column(Float)

class EconomicCalendarDB(Base):
    __tablename__ = "economic_calendar"
    id = Column(Integer, primary_key=True)
    event_id = Column(String(100), unique=True)
    timestamp = Column(DateTime(timezone=True), nullable=False)
    currency = Column(String(10), nullable=False)
    event_name = Column(String(255), nullable=False)
    impact = Column(String(20), nullable=False)
    forecast = Column(String(50))
    previous = Column(String(50))
    actual = Column(String(50))
    surprise = Column(Float)
    surprise_direction = Column(String(20))

    __table_args__ = (
        Index('idx_calendar_lookup', 'timestamp', 'currency', 'impact'),
    )

class COTDataDB(Base):
    __tablename__ = "cot_data"
    id = Column(Integer, primary_key=True)
    week_ending = Column(DateTime(timezone=True), nullable=False)
    currency = Column(String(10), nullable=False)
    long_positions = Column(Integer)
    short_positions = Column(Integer)
    net_position = Column(Integer)
    institutional_bias = Column(String(20))
    bias_strength = Column(Float)

    __table_args__ = (
        UniqueConstraint('week_ending', 'currency', name='_week_curr_uc'),
    )

class ModelVersionDB(Base):
    __tablename__ = "model_versions"
    id = Column(Integer, primary_key=True)
    version = Column(String(50), unique=True)
    module = Column(String(50))
    status = Column(String(20))
    trained_at = Column(DateTime, default=datetime.utcnow)
    metrics = Column(JSON)

class ModelFeedbackDB(Base):
    __tablename__ = "model_feedback"
    id = Column(SQLUUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    pair_id = Column(Integer, ForeignKey("currency_pairs.id"), nullable=False)
    strategy = Column(String(50), nullable=False)
    indicator_dna = Column(JSON, nullable=False) # Snapshot of RSI, MACD, etc.
    failure_context = Column(String(100)) # e.g., "BULL_TRAP"
    severity = Column(Float, default=1.0)
    detected_at = Column(DateTime(timezone=True), default=lambda: datetime.now(timezone.utc))
    expires_at = Column(DateTime(timezone=True)) # 48h limit

class DataDownloadLogDB(Base):
    __tablename__ = "data_download_log"
    id = Column(Integer, primary_key=True)
    pair_id = Column(Integer, ForeignKey("currency_pairs.id"))
    timeframe = Column(String(20))
    start_time = Column(DateTime(timezone=True))
    end_time = Column(DateTime(timezone=True))
    status = Column(String(20))
    bars_count = Column(Integer)

class SystemAlertDB(Base):
    __tablename__ = "system_alerts"
    alert_id = Column(SQLUUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    timestamp = Column(DateTime(timezone=True), nullable=False)
    alert_type = Column(String(50), nullable=False)
    severity = Column(String(20), nullable=False)
    message = Column(String(255), nullable=False)
    pair_id = Column(Integer, ForeignKey("currency_pairs.id"))
    auto_resolved = Column(Boolean, default=False)
    resolved_at = Column(DateTime(timezone=True))
