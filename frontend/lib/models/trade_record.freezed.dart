// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trade_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TradeRecord _$TradeRecordFromJson(Map<String, dynamic> json) {
  return _TradeRecord.fromJson(json);
}

/// @nodoc
mixin _$TradeRecord {
  @JsonKey(name: 'trade_uuid')
  String get tradeUuid => throw _privateConstructorUsedError;
  @JsonKey(name: 'broker_order_id')
  String? get brokerOrderId => throw _privateConstructorUsedError;
  @CurrencyPairConverter()
  CurrencyPair get pair => throw _privateConstructorUsedError;
  @StrategyConverter()
  Strategy get strategy => throw _privateConstructorUsedError;
  @DirectionConverter()
  Direction get direction => throw _privateConstructorUsedError;
  @TimeframeConverter()
  Timeframe get timeframe => throw _privateConstructorUsedError;
  @SessionConverter()
  Session get session => throw _privateConstructorUsedError;
  @RegimeConverter()
  @JsonKey(name: 'regime_at_entry')
  Regime get regimeAtEntry => throw _privateConstructorUsedError;
  @JsonKey(name: 'sentiment_at_entry')
  double get sentimentAtEntry => throw _privateConstructorUsedError;
  @JsonKey(name: 'confidence_at_entry')
  double get confidenceAtEntry => throw _privateConstructorUsedError;
  @JsonKey(name: 'entry_price')
  double? get entryPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'entry_time')
  DateTime? get entryTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'lot_size')
  double? get lotSize => throw _privateConstructorUsedError;
  @JsonKey(name: 'stop_loss')
  double? get stopLoss => throw _privateConstructorUsedError;
  @JsonKey(name: 'take_profit')
  double? get takeProfit => throw _privateConstructorUsedError;
  @JsonKey(name: 'exit_price')
  double? get exitPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'exit_time')
  DateTime? get exitTime => throw _privateConstructorUsedError;
  @ExitReasonConverter()
  @JsonKey(name: 'exit_reason')
  ExitReason? get exitReason => throw _privateConstructorUsedError;
  double get commission => throw _privateConstructorUsedError;
  double get swap => throw _privateConstructorUsedError;
  @JsonKey(name: 'pips_result')
  double? get pipsResult => throw _privateConstructorUsedError;
  @JsonKey(name: 'profit_loss')
  double? get profitLoss => throw _privateConstructorUsedError;
  @JsonKey(name: 'net_profit_loss')
  double? get netProfitLoss => throw _privateConstructorUsedError;
  @OrderStatusConverter()
  OrderStatus get status => throw _privateConstructorUsedError;
  @TradeTypeConverter()
  @JsonKey(name: 'trade_type')
  TradeType get tradeType => throw _privateConstructorUsedError;

  /// Serializes this TradeRecord to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TradeRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TradeRecordCopyWith<TradeRecord> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TradeRecordCopyWith<$Res> {
  factory $TradeRecordCopyWith(
          TradeRecord value, $Res Function(TradeRecord) then) =
      _$TradeRecordCopyWithImpl<$Res, TradeRecord>;
  @useResult
  $Res call(
      {@JsonKey(name: 'trade_uuid') String tradeUuid,
      @JsonKey(name: 'broker_order_id') String? brokerOrderId,
      @CurrencyPairConverter() CurrencyPair pair,
      @StrategyConverter() Strategy strategy,
      @DirectionConverter() Direction direction,
      @TimeframeConverter() Timeframe timeframe,
      @SessionConverter() Session session,
      @RegimeConverter() @JsonKey(name: 'regime_at_entry') Regime regimeAtEntry,
      @JsonKey(name: 'sentiment_at_entry') double sentimentAtEntry,
      @JsonKey(name: 'confidence_at_entry') double confidenceAtEntry,
      @JsonKey(name: 'entry_price') double? entryPrice,
      @JsonKey(name: 'entry_time') DateTime? entryTime,
      @JsonKey(name: 'lot_size') double? lotSize,
      @JsonKey(name: 'stop_loss') double? stopLoss,
      @JsonKey(name: 'take_profit') double? takeProfit,
      @JsonKey(name: 'exit_price') double? exitPrice,
      @JsonKey(name: 'exit_time') DateTime? exitTime,
      @ExitReasonConverter()
      @JsonKey(name: 'exit_reason')
      ExitReason? exitReason,
      double commission,
      double swap,
      @JsonKey(name: 'pips_result') double? pipsResult,
      @JsonKey(name: 'profit_loss') double? profitLoss,
      @JsonKey(name: 'net_profit_loss') double? netProfitLoss,
      @OrderStatusConverter() OrderStatus status,
      @TradeTypeConverter() @JsonKey(name: 'trade_type') TradeType tradeType});
}

/// @nodoc
class _$TradeRecordCopyWithImpl<$Res, $Val extends TradeRecord>
    implements $TradeRecordCopyWith<$Res> {
  _$TradeRecordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TradeRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tradeUuid = null,
    Object? brokerOrderId = freezed,
    Object? pair = null,
    Object? strategy = null,
    Object? direction = null,
    Object? timeframe = null,
    Object? session = null,
    Object? regimeAtEntry = null,
    Object? sentimentAtEntry = null,
    Object? confidenceAtEntry = null,
    Object? entryPrice = freezed,
    Object? entryTime = freezed,
    Object? lotSize = freezed,
    Object? stopLoss = freezed,
    Object? takeProfit = freezed,
    Object? exitPrice = freezed,
    Object? exitTime = freezed,
    Object? exitReason = freezed,
    Object? commission = null,
    Object? swap = null,
    Object? pipsResult = freezed,
    Object? profitLoss = freezed,
    Object? netProfitLoss = freezed,
    Object? status = null,
    Object? tradeType = null,
  }) {
    return _then(_value.copyWith(
      tradeUuid: null == tradeUuid
          ? _value.tradeUuid
          : tradeUuid // ignore: cast_nullable_to_non_nullable
              as String,
      brokerOrderId: freezed == brokerOrderId
          ? _value.brokerOrderId
          : brokerOrderId // ignore: cast_nullable_to_non_nullable
              as String?,
      pair: null == pair
          ? _value.pair
          : pair // ignore: cast_nullable_to_non_nullable
              as CurrencyPair,
      strategy: null == strategy
          ? _value.strategy
          : strategy // ignore: cast_nullable_to_non_nullable
              as Strategy,
      direction: null == direction
          ? _value.direction
          : direction // ignore: cast_nullable_to_non_nullable
              as Direction,
      timeframe: null == timeframe
          ? _value.timeframe
          : timeframe // ignore: cast_nullable_to_non_nullable
              as Timeframe,
      session: null == session
          ? _value.session
          : session // ignore: cast_nullable_to_non_nullable
              as Session,
      regimeAtEntry: null == regimeAtEntry
          ? _value.regimeAtEntry
          : regimeAtEntry // ignore: cast_nullable_to_non_nullable
              as Regime,
      sentimentAtEntry: null == sentimentAtEntry
          ? _value.sentimentAtEntry
          : sentimentAtEntry // ignore: cast_nullable_to_non_nullable
              as double,
      confidenceAtEntry: null == confidenceAtEntry
          ? _value.confidenceAtEntry
          : confidenceAtEntry // ignore: cast_nullable_to_non_nullable
              as double,
      entryPrice: freezed == entryPrice
          ? _value.entryPrice
          : entryPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      entryTime: freezed == entryTime
          ? _value.entryTime
          : entryTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lotSize: freezed == lotSize
          ? _value.lotSize
          : lotSize // ignore: cast_nullable_to_non_nullable
              as double?,
      stopLoss: freezed == stopLoss
          ? _value.stopLoss
          : stopLoss // ignore: cast_nullable_to_non_nullable
              as double?,
      takeProfit: freezed == takeProfit
          ? _value.takeProfit
          : takeProfit // ignore: cast_nullable_to_non_nullable
              as double?,
      exitPrice: freezed == exitPrice
          ? _value.exitPrice
          : exitPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      exitTime: freezed == exitTime
          ? _value.exitTime
          : exitTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      exitReason: freezed == exitReason
          ? _value.exitReason
          : exitReason // ignore: cast_nullable_to_non_nullable
              as ExitReason?,
      commission: null == commission
          ? _value.commission
          : commission // ignore: cast_nullable_to_non_nullable
              as double,
      swap: null == swap
          ? _value.swap
          : swap // ignore: cast_nullable_to_non_nullable
              as double,
      pipsResult: freezed == pipsResult
          ? _value.pipsResult
          : pipsResult // ignore: cast_nullable_to_non_nullable
              as double?,
      profitLoss: freezed == profitLoss
          ? _value.profitLoss
          : profitLoss // ignore: cast_nullable_to_non_nullable
              as double?,
      netProfitLoss: freezed == netProfitLoss
          ? _value.netProfitLoss
          : netProfitLoss // ignore: cast_nullable_to_non_nullable
              as double?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as OrderStatus,
      tradeType: null == tradeType
          ? _value.tradeType
          : tradeType // ignore: cast_nullable_to_non_nullable
              as TradeType,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TradeRecordImplCopyWith<$Res>
    implements $TradeRecordCopyWith<$Res> {
  factory _$$TradeRecordImplCopyWith(
          _$TradeRecordImpl value, $Res Function(_$TradeRecordImpl) then) =
      __$$TradeRecordImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'trade_uuid') String tradeUuid,
      @JsonKey(name: 'broker_order_id') String? brokerOrderId,
      @CurrencyPairConverter() CurrencyPair pair,
      @StrategyConverter() Strategy strategy,
      @DirectionConverter() Direction direction,
      @TimeframeConverter() Timeframe timeframe,
      @SessionConverter() Session session,
      @RegimeConverter() @JsonKey(name: 'regime_at_entry') Regime regimeAtEntry,
      @JsonKey(name: 'sentiment_at_entry') double sentimentAtEntry,
      @JsonKey(name: 'confidence_at_entry') double confidenceAtEntry,
      @JsonKey(name: 'entry_price') double? entryPrice,
      @JsonKey(name: 'entry_time') DateTime? entryTime,
      @JsonKey(name: 'lot_size') double? lotSize,
      @JsonKey(name: 'stop_loss') double? stopLoss,
      @JsonKey(name: 'take_profit') double? takeProfit,
      @JsonKey(name: 'exit_price') double? exitPrice,
      @JsonKey(name: 'exit_time') DateTime? exitTime,
      @ExitReasonConverter()
      @JsonKey(name: 'exit_reason')
      ExitReason? exitReason,
      double commission,
      double swap,
      @JsonKey(name: 'pips_result') double? pipsResult,
      @JsonKey(name: 'profit_loss') double? profitLoss,
      @JsonKey(name: 'net_profit_loss') double? netProfitLoss,
      @OrderStatusConverter() OrderStatus status,
      @TradeTypeConverter() @JsonKey(name: 'trade_type') TradeType tradeType});
}

/// @nodoc
class __$$TradeRecordImplCopyWithImpl<$Res>
    extends _$TradeRecordCopyWithImpl<$Res, _$TradeRecordImpl>
    implements _$$TradeRecordImplCopyWith<$Res> {
  __$$TradeRecordImplCopyWithImpl(
      _$TradeRecordImpl _value, $Res Function(_$TradeRecordImpl) _then)
      : super(_value, _then);

  /// Create a copy of TradeRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tradeUuid = null,
    Object? brokerOrderId = freezed,
    Object? pair = null,
    Object? strategy = null,
    Object? direction = null,
    Object? timeframe = null,
    Object? session = null,
    Object? regimeAtEntry = null,
    Object? sentimentAtEntry = null,
    Object? confidenceAtEntry = null,
    Object? entryPrice = freezed,
    Object? entryTime = freezed,
    Object? lotSize = freezed,
    Object? stopLoss = freezed,
    Object? takeProfit = freezed,
    Object? exitPrice = freezed,
    Object? exitTime = freezed,
    Object? exitReason = freezed,
    Object? commission = null,
    Object? swap = null,
    Object? pipsResult = freezed,
    Object? profitLoss = freezed,
    Object? netProfitLoss = freezed,
    Object? status = null,
    Object? tradeType = null,
  }) {
    return _then(_$TradeRecordImpl(
      tradeUuid: null == tradeUuid
          ? _value.tradeUuid
          : tradeUuid // ignore: cast_nullable_to_non_nullable
              as String,
      brokerOrderId: freezed == brokerOrderId
          ? _value.brokerOrderId
          : brokerOrderId // ignore: cast_nullable_to_non_nullable
              as String?,
      pair: null == pair
          ? _value.pair
          : pair // ignore: cast_nullable_to_non_nullable
              as CurrencyPair,
      strategy: null == strategy
          ? _value.strategy
          : strategy // ignore: cast_nullable_to_non_nullable
              as Strategy,
      direction: null == direction
          ? _value.direction
          : direction // ignore: cast_nullable_to_non_nullable
              as Direction,
      timeframe: null == timeframe
          ? _value.timeframe
          : timeframe // ignore: cast_nullable_to_non_nullable
              as Timeframe,
      session: null == session
          ? _value.session
          : session // ignore: cast_nullable_to_non_nullable
              as Session,
      regimeAtEntry: null == regimeAtEntry
          ? _value.regimeAtEntry
          : regimeAtEntry // ignore: cast_nullable_to_non_nullable
              as Regime,
      sentimentAtEntry: null == sentimentAtEntry
          ? _value.sentimentAtEntry
          : sentimentAtEntry // ignore: cast_nullable_to_non_nullable
              as double,
      confidenceAtEntry: null == confidenceAtEntry
          ? _value.confidenceAtEntry
          : confidenceAtEntry // ignore: cast_nullable_to_non_nullable
              as double,
      entryPrice: freezed == entryPrice
          ? _value.entryPrice
          : entryPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      entryTime: freezed == entryTime
          ? _value.entryTime
          : entryTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lotSize: freezed == lotSize
          ? _value.lotSize
          : lotSize // ignore: cast_nullable_to_non_nullable
              as double?,
      stopLoss: freezed == stopLoss
          ? _value.stopLoss
          : stopLoss // ignore: cast_nullable_to_non_nullable
              as double?,
      takeProfit: freezed == takeProfit
          ? _value.takeProfit
          : takeProfit // ignore: cast_nullable_to_non_nullable
              as double?,
      exitPrice: freezed == exitPrice
          ? _value.exitPrice
          : exitPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      exitTime: freezed == exitTime
          ? _value.exitTime
          : exitTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      exitReason: freezed == exitReason
          ? _value.exitReason
          : exitReason // ignore: cast_nullable_to_non_nullable
              as ExitReason?,
      commission: null == commission
          ? _value.commission
          : commission // ignore: cast_nullable_to_non_nullable
              as double,
      swap: null == swap
          ? _value.swap
          : swap // ignore: cast_nullable_to_non_nullable
              as double,
      pipsResult: freezed == pipsResult
          ? _value.pipsResult
          : pipsResult // ignore: cast_nullable_to_non_nullable
              as double?,
      profitLoss: freezed == profitLoss
          ? _value.profitLoss
          : profitLoss // ignore: cast_nullable_to_non_nullable
              as double?,
      netProfitLoss: freezed == netProfitLoss
          ? _value.netProfitLoss
          : netProfitLoss // ignore: cast_nullable_to_non_nullable
              as double?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as OrderStatus,
      tradeType: null == tradeType
          ? _value.tradeType
          : tradeType // ignore: cast_nullable_to_non_nullable
              as TradeType,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TradeRecordImpl extends _TradeRecord {
  const _$TradeRecordImpl(
      {@JsonKey(name: 'trade_uuid') this.tradeUuid = '',
      @JsonKey(name: 'broker_order_id') this.brokerOrderId,
      @CurrencyPairConverter() this.pair = CurrencyPair.unknown,
      @StrategyConverter() this.strategy = Strategy.skip,
      @DirectionConverter() this.direction = Direction.neutral,
      @TimeframeConverter() this.timeframe = Timeframe.h1,
      @SessionConverter() this.session = Session.deadZone,
      @RegimeConverter()
      @JsonKey(name: 'regime_at_entry')
      this.regimeAtEntry = Regime.unknown,
      @JsonKey(name: 'sentiment_at_entry') this.sentimentAtEntry = 0.0,
      @JsonKey(name: 'confidence_at_entry') this.confidenceAtEntry = 0.0,
      @JsonKey(name: 'entry_price') this.entryPrice,
      @JsonKey(name: 'entry_time') this.entryTime,
      @JsonKey(name: 'lot_size') this.lotSize,
      @JsonKey(name: 'stop_loss') this.stopLoss,
      @JsonKey(name: 'take_profit') this.takeProfit,
      @JsonKey(name: 'exit_price') this.exitPrice,
      @JsonKey(name: 'exit_time') this.exitTime,
      @ExitReasonConverter()
      @JsonKey(name: 'exit_reason')
      this.exitReason = ExitReason.manualClose,
      this.commission = 0.0,
      this.swap = 0.0,
      @JsonKey(name: 'pips_result') this.pipsResult = 0.0,
      @JsonKey(name: 'profit_loss') this.profitLoss = 0.0,
      @JsonKey(name: 'net_profit_loss') this.netProfitLoss = 0.0,
      @OrderStatusConverter() this.status = OrderStatus.closed,
      @TradeTypeConverter()
      @JsonKey(name: 'trade_type')
      this.tradeType = TradeType.paper})
      : super._();

  factory _$TradeRecordImpl.fromJson(Map<String, dynamic> json) =>
      _$$TradeRecordImplFromJson(json);

  @override
  @JsonKey(name: 'trade_uuid')
  final String tradeUuid;
  @override
  @JsonKey(name: 'broker_order_id')
  final String? brokerOrderId;
  @override
  @JsonKey()
  @CurrencyPairConverter()
  final CurrencyPair pair;
  @override
  @JsonKey()
  @StrategyConverter()
  final Strategy strategy;
  @override
  @JsonKey()
  @DirectionConverter()
  final Direction direction;
  @override
  @JsonKey()
  @TimeframeConverter()
  final Timeframe timeframe;
  @override
  @JsonKey()
  @SessionConverter()
  final Session session;
  @override
  @RegimeConverter()
  @JsonKey(name: 'regime_at_entry')
  final Regime regimeAtEntry;
  @override
  @JsonKey(name: 'sentiment_at_entry')
  final double sentimentAtEntry;
  @override
  @JsonKey(name: 'confidence_at_entry')
  final double confidenceAtEntry;
  @override
  @JsonKey(name: 'entry_price')
  final double? entryPrice;
  @override
  @JsonKey(name: 'entry_time')
  final DateTime? entryTime;
  @override
  @JsonKey(name: 'lot_size')
  final double? lotSize;
  @override
  @JsonKey(name: 'stop_loss')
  final double? stopLoss;
  @override
  @JsonKey(name: 'take_profit')
  final double? takeProfit;
  @override
  @JsonKey(name: 'exit_price')
  final double? exitPrice;
  @override
  @JsonKey(name: 'exit_time')
  final DateTime? exitTime;
  @override
  @ExitReasonConverter()
  @JsonKey(name: 'exit_reason')
  final ExitReason? exitReason;
  @override
  @JsonKey()
  final double commission;
  @override
  @JsonKey()
  final double swap;
  @override
  @JsonKey(name: 'pips_result')
  final double? pipsResult;
  @override
  @JsonKey(name: 'profit_loss')
  final double? profitLoss;
  @override
  @JsonKey(name: 'net_profit_loss')
  final double? netProfitLoss;
  @override
  @JsonKey()
  @OrderStatusConverter()
  final OrderStatus status;
  @override
  @TradeTypeConverter()
  @JsonKey(name: 'trade_type')
  final TradeType tradeType;

  @override
  String toString() {
    return 'TradeRecord(tradeUuid: $tradeUuid, brokerOrderId: $brokerOrderId, pair: $pair, strategy: $strategy, direction: $direction, timeframe: $timeframe, session: $session, regimeAtEntry: $regimeAtEntry, sentimentAtEntry: $sentimentAtEntry, confidenceAtEntry: $confidenceAtEntry, entryPrice: $entryPrice, entryTime: $entryTime, lotSize: $lotSize, stopLoss: $stopLoss, takeProfit: $takeProfit, exitPrice: $exitPrice, exitTime: $exitTime, exitReason: $exitReason, commission: $commission, swap: $swap, pipsResult: $pipsResult, profitLoss: $profitLoss, netProfitLoss: $netProfitLoss, status: $status, tradeType: $tradeType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TradeRecordImpl &&
            (identical(other.tradeUuid, tradeUuid) ||
                other.tradeUuid == tradeUuid) &&
            (identical(other.brokerOrderId, brokerOrderId) ||
                other.brokerOrderId == brokerOrderId) &&
            (identical(other.pair, pair) || other.pair == pair) &&
            (identical(other.strategy, strategy) ||
                other.strategy == strategy) &&
            (identical(other.direction, direction) ||
                other.direction == direction) &&
            (identical(other.timeframe, timeframe) ||
                other.timeframe == timeframe) &&
            (identical(other.session, session) || other.session == session) &&
            (identical(other.regimeAtEntry, regimeAtEntry) ||
                other.regimeAtEntry == regimeAtEntry) &&
            (identical(other.sentimentAtEntry, sentimentAtEntry) ||
                other.sentimentAtEntry == sentimentAtEntry) &&
            (identical(other.confidenceAtEntry, confidenceAtEntry) ||
                other.confidenceAtEntry == confidenceAtEntry) &&
            (identical(other.entryPrice, entryPrice) ||
                other.entryPrice == entryPrice) &&
            (identical(other.entryTime, entryTime) ||
                other.entryTime == entryTime) &&
            (identical(other.lotSize, lotSize) || other.lotSize == lotSize) &&
            (identical(other.stopLoss, stopLoss) ||
                other.stopLoss == stopLoss) &&
            (identical(other.takeProfit, takeProfit) ||
                other.takeProfit == takeProfit) &&
            (identical(other.exitPrice, exitPrice) ||
                other.exitPrice == exitPrice) &&
            (identical(other.exitTime, exitTime) ||
                other.exitTime == exitTime) &&
            (identical(other.exitReason, exitReason) ||
                other.exitReason == exitReason) &&
            (identical(other.commission, commission) ||
                other.commission == commission) &&
            (identical(other.swap, swap) || other.swap == swap) &&
            (identical(other.pipsResult, pipsResult) ||
                other.pipsResult == pipsResult) &&
            (identical(other.profitLoss, profitLoss) ||
                other.profitLoss == profitLoss) &&
            (identical(other.netProfitLoss, netProfitLoss) ||
                other.netProfitLoss == netProfitLoss) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.tradeType, tradeType) ||
                other.tradeType == tradeType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        tradeUuid,
        brokerOrderId,
        pair,
        strategy,
        direction,
        timeframe,
        session,
        regimeAtEntry,
        sentimentAtEntry,
        confidenceAtEntry,
        entryPrice,
        entryTime,
        lotSize,
        stopLoss,
        takeProfit,
        exitPrice,
        exitTime,
        exitReason,
        commission,
        swap,
        pipsResult,
        profitLoss,
        netProfitLoss,
        status,
        tradeType
      ]);

  /// Create a copy of TradeRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TradeRecordImplCopyWith<_$TradeRecordImpl> get copyWith =>
      __$$TradeRecordImplCopyWithImpl<_$TradeRecordImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TradeRecordImplToJson(
      this,
    );
  }
}

abstract class _TradeRecord extends TradeRecord {
  const factory _TradeRecord(
      {@JsonKey(name: 'trade_uuid') final String tradeUuid,
      @JsonKey(name: 'broker_order_id') final String? brokerOrderId,
      @CurrencyPairConverter() final CurrencyPair pair,
      @StrategyConverter() final Strategy strategy,
      @DirectionConverter() final Direction direction,
      @TimeframeConverter() final Timeframe timeframe,
      @SessionConverter() final Session session,
      @RegimeConverter()
      @JsonKey(name: 'regime_at_entry')
      final Regime regimeAtEntry,
      @JsonKey(name: 'sentiment_at_entry') final double sentimentAtEntry,
      @JsonKey(name: 'confidence_at_entry') final double confidenceAtEntry,
      @JsonKey(name: 'entry_price') final double? entryPrice,
      @JsonKey(name: 'entry_time') final DateTime? entryTime,
      @JsonKey(name: 'lot_size') final double? lotSize,
      @JsonKey(name: 'stop_loss') final double? stopLoss,
      @JsonKey(name: 'take_profit') final double? takeProfit,
      @JsonKey(name: 'exit_price') final double? exitPrice,
      @JsonKey(name: 'exit_time') final DateTime? exitTime,
      @ExitReasonConverter()
      @JsonKey(name: 'exit_reason')
      final ExitReason? exitReason,
      final double commission,
      final double swap,
      @JsonKey(name: 'pips_result') final double? pipsResult,
      @JsonKey(name: 'profit_loss') final double? profitLoss,
      @JsonKey(name: 'net_profit_loss') final double? netProfitLoss,
      @OrderStatusConverter() final OrderStatus status,
      @TradeTypeConverter()
      @JsonKey(name: 'trade_type')
      final TradeType tradeType}) = _$TradeRecordImpl;
  const _TradeRecord._() : super._();

  factory _TradeRecord.fromJson(Map<String, dynamic> json) =
      _$TradeRecordImpl.fromJson;

  @override
  @JsonKey(name: 'trade_uuid')
  String get tradeUuid;
  @override
  @JsonKey(name: 'broker_order_id')
  String? get brokerOrderId;
  @override
  @CurrencyPairConverter()
  CurrencyPair get pair;
  @override
  @StrategyConverter()
  Strategy get strategy;
  @override
  @DirectionConverter()
  Direction get direction;
  @override
  @TimeframeConverter()
  Timeframe get timeframe;
  @override
  @SessionConverter()
  Session get session;
  @override
  @RegimeConverter()
  @JsonKey(name: 'regime_at_entry')
  Regime get regimeAtEntry;
  @override
  @JsonKey(name: 'sentiment_at_entry')
  double get sentimentAtEntry;
  @override
  @JsonKey(name: 'confidence_at_entry')
  double get confidenceAtEntry;
  @override
  @JsonKey(name: 'entry_price')
  double? get entryPrice;
  @override
  @JsonKey(name: 'entry_time')
  DateTime? get entryTime;
  @override
  @JsonKey(name: 'lot_size')
  double? get lotSize;
  @override
  @JsonKey(name: 'stop_loss')
  double? get stopLoss;
  @override
  @JsonKey(name: 'take_profit')
  double? get takeProfit;
  @override
  @JsonKey(name: 'exit_price')
  double? get exitPrice;
  @override
  @JsonKey(name: 'exit_time')
  DateTime? get exitTime;
  @override
  @ExitReasonConverter()
  @JsonKey(name: 'exit_reason')
  ExitReason? get exitReason;
  @override
  double get commission;
  @override
  double get swap;
  @override
  @JsonKey(name: 'pips_result')
  double? get pipsResult;
  @override
  @JsonKey(name: 'profit_loss')
  double? get profitLoss;
  @override
  @JsonKey(name: 'net_profit_loss')
  double? get netProfitLoss;
  @override
  @OrderStatusConverter()
  OrderStatus get status;
  @override
  @TradeTypeConverter()
  @JsonKey(name: 'trade_type')
  TradeType get tradeType;

  /// Create a copy of TradeRecord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TradeRecordImplCopyWith<_$TradeRecordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
