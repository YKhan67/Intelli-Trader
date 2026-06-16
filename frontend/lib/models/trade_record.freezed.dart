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
  @JsonKey(name: 'entry_price')
  double get entryPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'entry_time')
  DateTime get entryTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'lot_size')
  double get lotSize => throw _privateConstructorUsedError;
  @JsonKey(name: 'stop_loss')
  double get stopLoss => throw _privateConstructorUsedError;
  @JsonKey(name: 'take_profit')
  double get takeProfit => throw _privateConstructorUsedError;
  @JsonKey(name: 'exit_price')
  double? get exitPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'exit_time')
  DateTime? get exitTime => throw _privateConstructorUsedError;
  @ExitReasonConverter()
  @JsonKey(name: 'exit_reason')
  ExitReason? get exitReason => throw _privateConstructorUsedError;
  @JsonKey(name: 'pips_result')
  double? get pipsResult => throw _privateConstructorUsedError;
  @JsonKey(name: 'profit_loss')
  double? get profitLoss => throw _privateConstructorUsedError;
  @JsonKey(name: 'net_profit_loss')
  double? get netProfitLoss => throw _privateConstructorUsedError;
  @JsonKey(name: 'confidence_at_entry')
  double get confidenceAtEntry => throw _privateConstructorUsedError;
  @OrderStatusConverter()
  OrderStatus get status => throw _privateConstructorUsedError;

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
      @JsonKey(name: 'entry_price') double entryPrice,
      @JsonKey(name: 'entry_time') DateTime entryTime,
      @JsonKey(name: 'lot_size') double lotSize,
      @JsonKey(name: 'stop_loss') double stopLoss,
      @JsonKey(name: 'take_profit') double takeProfit,
      @JsonKey(name: 'exit_price') double? exitPrice,
      @JsonKey(name: 'exit_time') DateTime? exitTime,
      @ExitReasonConverter()
      @JsonKey(name: 'exit_reason')
      ExitReason? exitReason,
      @JsonKey(name: 'pips_result') double? pipsResult,
      @JsonKey(name: 'profit_loss') double? profitLoss,
      @JsonKey(name: 'net_profit_loss') double? netProfitLoss,
      @JsonKey(name: 'confidence_at_entry') double confidenceAtEntry,
      @OrderStatusConverter() OrderStatus status});
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
    Object? entryPrice = null,
    Object? entryTime = null,
    Object? lotSize = null,
    Object? stopLoss = null,
    Object? takeProfit = null,
    Object? exitPrice = freezed,
    Object? exitTime = freezed,
    Object? exitReason = freezed,
    Object? pipsResult = freezed,
    Object? profitLoss = freezed,
    Object? netProfitLoss = freezed,
    Object? confidenceAtEntry = null,
    Object? status = null,
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
      entryPrice: null == entryPrice
          ? _value.entryPrice
          : entryPrice // ignore: cast_nullable_to_non_nullable
              as double,
      entryTime: null == entryTime
          ? _value.entryTime
          : entryTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lotSize: null == lotSize
          ? _value.lotSize
          : lotSize // ignore: cast_nullable_to_non_nullable
              as double,
      stopLoss: null == stopLoss
          ? _value.stopLoss
          : stopLoss // ignore: cast_nullable_to_non_nullable
              as double,
      takeProfit: null == takeProfit
          ? _value.takeProfit
          : takeProfit // ignore: cast_nullable_to_non_nullable
              as double,
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
      confidenceAtEntry: null == confidenceAtEntry
          ? _value.confidenceAtEntry
          : confidenceAtEntry // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as OrderStatus,
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
      @JsonKey(name: 'entry_price') double entryPrice,
      @JsonKey(name: 'entry_time') DateTime entryTime,
      @JsonKey(name: 'lot_size') double lotSize,
      @JsonKey(name: 'stop_loss') double stopLoss,
      @JsonKey(name: 'take_profit') double takeProfit,
      @JsonKey(name: 'exit_price') double? exitPrice,
      @JsonKey(name: 'exit_time') DateTime? exitTime,
      @ExitReasonConverter()
      @JsonKey(name: 'exit_reason')
      ExitReason? exitReason,
      @JsonKey(name: 'pips_result') double? pipsResult,
      @JsonKey(name: 'profit_loss') double? profitLoss,
      @JsonKey(name: 'net_profit_loss') double? netProfitLoss,
      @JsonKey(name: 'confidence_at_entry') double confidenceAtEntry,
      @OrderStatusConverter() OrderStatus status});
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
    Object? entryPrice = null,
    Object? entryTime = null,
    Object? lotSize = null,
    Object? stopLoss = null,
    Object? takeProfit = null,
    Object? exitPrice = freezed,
    Object? exitTime = freezed,
    Object? exitReason = freezed,
    Object? pipsResult = freezed,
    Object? profitLoss = freezed,
    Object? netProfitLoss = freezed,
    Object? confidenceAtEntry = null,
    Object? status = null,
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
      entryPrice: null == entryPrice
          ? _value.entryPrice
          : entryPrice // ignore: cast_nullable_to_non_nullable
              as double,
      entryTime: null == entryTime
          ? _value.entryTime
          : entryTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lotSize: null == lotSize
          ? _value.lotSize
          : lotSize // ignore: cast_nullable_to_non_nullable
              as double,
      stopLoss: null == stopLoss
          ? _value.stopLoss
          : stopLoss // ignore: cast_nullable_to_non_nullable
              as double,
      takeProfit: null == takeProfit
          ? _value.takeProfit
          : takeProfit // ignore: cast_nullable_to_non_nullable
              as double,
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
      confidenceAtEntry: null == confidenceAtEntry
          ? _value.confidenceAtEntry
          : confidenceAtEntry // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as OrderStatus,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TradeRecordImpl extends _TradeRecord {
  const _$TradeRecordImpl(
      {@JsonKey(name: 'trade_uuid') required this.tradeUuid,
      @JsonKey(name: 'broker_order_id') required this.brokerOrderId,
      @CurrencyPairConverter() required this.pair,
      @StrategyConverter() required this.strategy,
      @DirectionConverter() required this.direction,
      @TimeframeConverter() required this.timeframe,
      @SessionConverter() required this.session,
      @JsonKey(name: 'entry_price') required this.entryPrice,
      @JsonKey(name: 'entry_time') required this.entryTime,
      @JsonKey(name: 'lot_size') required this.lotSize,
      @JsonKey(name: 'stop_loss') required this.stopLoss,
      @JsonKey(name: 'take_profit') required this.takeProfit,
      @JsonKey(name: 'exit_price') this.exitPrice,
      @JsonKey(name: 'exit_time') this.exitTime,
      @ExitReasonConverter() @JsonKey(name: 'exit_reason') this.exitReason,
      @JsonKey(name: 'pips_result') this.pipsResult,
      @JsonKey(name: 'profit_loss') this.profitLoss,
      @JsonKey(name: 'net_profit_loss') this.netProfitLoss,
      @JsonKey(name: 'confidence_at_entry') required this.confidenceAtEntry,
      @OrderStatusConverter() required this.status})
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
  @CurrencyPairConverter()
  final CurrencyPair pair;
  @override
  @StrategyConverter()
  final Strategy strategy;
  @override
  @DirectionConverter()
  final Direction direction;
  @override
  @TimeframeConverter()
  final Timeframe timeframe;
  @override
  @SessionConverter()
  final Session session;
  @override
  @JsonKey(name: 'entry_price')
  final double entryPrice;
  @override
  @JsonKey(name: 'entry_time')
  final DateTime entryTime;
  @override
  @JsonKey(name: 'lot_size')
  final double lotSize;
  @override
  @JsonKey(name: 'stop_loss')
  final double stopLoss;
  @override
  @JsonKey(name: 'take_profit')
  final double takeProfit;
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
  @JsonKey(name: 'pips_result')
  final double? pipsResult;
  @override
  @JsonKey(name: 'profit_loss')
  final double? profitLoss;
  @override
  @JsonKey(name: 'net_profit_loss')
  final double? netProfitLoss;
  @override
  @JsonKey(name: 'confidence_at_entry')
  final double confidenceAtEntry;
  @override
  @OrderStatusConverter()
  final OrderStatus status;

  @override
  String toString() {
    return 'TradeRecord(tradeUuid: $tradeUuid, brokerOrderId: $brokerOrderId, pair: $pair, strategy: $strategy, direction: $direction, timeframe: $timeframe, session: $session, entryPrice: $entryPrice, entryTime: $entryTime, lotSize: $lotSize, stopLoss: $stopLoss, takeProfit: $takeProfit, exitPrice: $exitPrice, exitTime: $exitTime, exitReason: $exitReason, pipsResult: $pipsResult, profitLoss: $profitLoss, netProfitLoss: $netProfitLoss, confidenceAtEntry: $confidenceAtEntry, status: $status)';
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
            (identical(other.pipsResult, pipsResult) ||
                other.pipsResult == pipsResult) &&
            (identical(other.profitLoss, profitLoss) ||
                other.profitLoss == profitLoss) &&
            (identical(other.netProfitLoss, netProfitLoss) ||
                other.netProfitLoss == netProfitLoss) &&
            (identical(other.confidenceAtEntry, confidenceAtEntry) ||
                other.confidenceAtEntry == confidenceAtEntry) &&
            (identical(other.status, status) || other.status == status));
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
        entryPrice,
        entryTime,
        lotSize,
        stopLoss,
        takeProfit,
        exitPrice,
        exitTime,
        exitReason,
        pipsResult,
        profitLoss,
        netProfitLoss,
        confidenceAtEntry,
        status
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
      {@JsonKey(name: 'trade_uuid') required final String tradeUuid,
      @JsonKey(name: 'broker_order_id') required final String? brokerOrderId,
      @CurrencyPairConverter() required final CurrencyPair pair,
      @StrategyConverter() required final Strategy strategy,
      @DirectionConverter() required final Direction direction,
      @TimeframeConverter() required final Timeframe timeframe,
      @SessionConverter() required final Session session,
      @JsonKey(name: 'entry_price') required final double entryPrice,
      @JsonKey(name: 'entry_time') required final DateTime entryTime,
      @JsonKey(name: 'lot_size') required final double lotSize,
      @JsonKey(name: 'stop_loss') required final double stopLoss,
      @JsonKey(name: 'take_profit') required final double takeProfit,
      @JsonKey(name: 'exit_price') final double? exitPrice,
      @JsonKey(name: 'exit_time') final DateTime? exitTime,
      @ExitReasonConverter()
      @JsonKey(name: 'exit_reason')
      final ExitReason? exitReason,
      @JsonKey(name: 'pips_result') final double? pipsResult,
      @JsonKey(name: 'profit_loss') final double? profitLoss,
      @JsonKey(name: 'net_profit_loss') final double? netProfitLoss,
      @JsonKey(name: 'confidence_at_entry')
      required final double confidenceAtEntry,
      @OrderStatusConverter()
      required final OrderStatus status}) = _$TradeRecordImpl;
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
  @JsonKey(name: 'entry_price')
  double get entryPrice;
  @override
  @JsonKey(name: 'entry_time')
  DateTime get entryTime;
  @override
  @JsonKey(name: 'lot_size')
  double get lotSize;
  @override
  @JsonKey(name: 'stop_loss')
  double get stopLoss;
  @override
  @JsonKey(name: 'take_profit')
  double get takeProfit;
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
  @JsonKey(name: 'pips_result')
  double? get pipsResult;
  @override
  @JsonKey(name: 'profit_loss')
  double? get profitLoss;
  @override
  @JsonKey(name: 'net_profit_loss')
  double? get netProfitLoss;
  @override
  @JsonKey(name: 'confidence_at_entry')
  double get confidenceAtEntry;
  @override
  @OrderStatusConverter()
  OrderStatus get status;

  /// Create a copy of TradeRecord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TradeRecordImplCopyWith<_$TradeRecordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
