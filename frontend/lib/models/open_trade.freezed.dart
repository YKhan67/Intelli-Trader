// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'open_trade.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

OpenTrade _$OpenTradeFromJson(Map<String, dynamic> json) {
  return _OpenTrade.fromJson(json);
}

/// @nodoc
mixin _$OpenTrade {
  @JsonKey(name: 'broker_ticket_id')
  String get brokerTicketId => throw _privateConstructorUsedError;
  @CurrencyPairConverter()
  CurrencyPair get pair => throw _privateConstructorUsedError;
  @DirectionConverter()
  Direction get direction => throw _privateConstructorUsedError;
  @JsonKey(name: 'entry_price')
  double get entryPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'current_price')
  double get currentPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'lot_size')
  double get lotSize => throw _privateConstructorUsedError;
  @JsonKey(name: 'stop_loss')
  double? get stopLoss => throw _privateConstructorUsedError;
  @JsonKey(name: 'take_profit')
  double? get takeProfit => throw _privateConstructorUsedError;
  @JsonKey(name: 'open_time')
  DateTime get openTime => throw _privateConstructorUsedError;

  /// Serializes this OpenTrade to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OpenTrade
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OpenTradeCopyWith<OpenTrade> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OpenTradeCopyWith<$Res> {
  factory $OpenTradeCopyWith(OpenTrade value, $Res Function(OpenTrade) then) =
      _$OpenTradeCopyWithImpl<$Res, OpenTrade>;
  @useResult
  $Res call(
      {@JsonKey(name: 'broker_ticket_id') String brokerTicketId,
      @CurrencyPairConverter() CurrencyPair pair,
      @DirectionConverter() Direction direction,
      @JsonKey(name: 'entry_price') double entryPrice,
      @JsonKey(name: 'current_price') double currentPrice,
      @JsonKey(name: 'lot_size') double lotSize,
      @JsonKey(name: 'stop_loss') double? stopLoss,
      @JsonKey(name: 'take_profit') double? takeProfit,
      @JsonKey(name: 'open_time') DateTime openTime});
}

/// @nodoc
class _$OpenTradeCopyWithImpl<$Res, $Val extends OpenTrade>
    implements $OpenTradeCopyWith<$Res> {
  _$OpenTradeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OpenTrade
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? brokerTicketId = null,
    Object? pair = null,
    Object? direction = null,
    Object? entryPrice = null,
    Object? currentPrice = null,
    Object? lotSize = null,
    Object? stopLoss = freezed,
    Object? takeProfit = freezed,
    Object? openTime = null,
  }) {
    return _then(_value.copyWith(
      brokerTicketId: null == brokerTicketId
          ? _value.brokerTicketId
          : brokerTicketId // ignore: cast_nullable_to_non_nullable
              as String,
      pair: null == pair
          ? _value.pair
          : pair // ignore: cast_nullable_to_non_nullable
              as CurrencyPair,
      direction: null == direction
          ? _value.direction
          : direction // ignore: cast_nullable_to_non_nullable
              as Direction,
      entryPrice: null == entryPrice
          ? _value.entryPrice
          : entryPrice // ignore: cast_nullable_to_non_nullable
              as double,
      currentPrice: null == currentPrice
          ? _value.currentPrice
          : currentPrice // ignore: cast_nullable_to_non_nullable
              as double,
      lotSize: null == lotSize
          ? _value.lotSize
          : lotSize // ignore: cast_nullable_to_non_nullable
              as double,
      stopLoss: freezed == stopLoss
          ? _value.stopLoss
          : stopLoss // ignore: cast_nullable_to_non_nullable
              as double?,
      takeProfit: freezed == takeProfit
          ? _value.takeProfit
          : takeProfit // ignore: cast_nullable_to_non_nullable
              as double?,
      openTime: null == openTime
          ? _value.openTime
          : openTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OpenTradeImplCopyWith<$Res>
    implements $OpenTradeCopyWith<$Res> {
  factory _$$OpenTradeImplCopyWith(
          _$OpenTradeImpl value, $Res Function(_$OpenTradeImpl) then) =
      __$$OpenTradeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'broker_ticket_id') String brokerTicketId,
      @CurrencyPairConverter() CurrencyPair pair,
      @DirectionConverter() Direction direction,
      @JsonKey(name: 'entry_price') double entryPrice,
      @JsonKey(name: 'current_price') double currentPrice,
      @JsonKey(name: 'lot_size') double lotSize,
      @JsonKey(name: 'stop_loss') double? stopLoss,
      @JsonKey(name: 'take_profit') double? takeProfit,
      @JsonKey(name: 'open_time') DateTime openTime});
}

/// @nodoc
class __$$OpenTradeImplCopyWithImpl<$Res>
    extends _$OpenTradeCopyWithImpl<$Res, _$OpenTradeImpl>
    implements _$$OpenTradeImplCopyWith<$Res> {
  __$$OpenTradeImplCopyWithImpl(
      _$OpenTradeImpl _value, $Res Function(_$OpenTradeImpl) _then)
      : super(_value, _then);

  /// Create a copy of OpenTrade
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? brokerTicketId = null,
    Object? pair = null,
    Object? direction = null,
    Object? entryPrice = null,
    Object? currentPrice = null,
    Object? lotSize = null,
    Object? stopLoss = freezed,
    Object? takeProfit = freezed,
    Object? openTime = null,
  }) {
    return _then(_$OpenTradeImpl(
      brokerTicketId: null == brokerTicketId
          ? _value.brokerTicketId
          : brokerTicketId // ignore: cast_nullable_to_non_nullable
              as String,
      pair: null == pair
          ? _value.pair
          : pair // ignore: cast_nullable_to_non_nullable
              as CurrencyPair,
      direction: null == direction
          ? _value.direction
          : direction // ignore: cast_nullable_to_non_nullable
              as Direction,
      entryPrice: null == entryPrice
          ? _value.entryPrice
          : entryPrice // ignore: cast_nullable_to_non_nullable
              as double,
      currentPrice: null == currentPrice
          ? _value.currentPrice
          : currentPrice // ignore: cast_nullable_to_non_nullable
              as double,
      lotSize: null == lotSize
          ? _value.lotSize
          : lotSize // ignore: cast_nullable_to_non_nullable
              as double,
      stopLoss: freezed == stopLoss
          ? _value.stopLoss
          : stopLoss // ignore: cast_nullable_to_non_nullable
              as double?,
      takeProfit: freezed == takeProfit
          ? _value.takeProfit
          : takeProfit // ignore: cast_nullable_to_non_nullable
              as double?,
      openTime: null == openTime
          ? _value.openTime
          : openTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OpenTradeImpl extends _OpenTrade {
  const _$OpenTradeImpl(
      {@JsonKey(name: 'broker_ticket_id') required this.brokerTicketId,
      @CurrencyPairConverter() required this.pair,
      @DirectionConverter() required this.direction,
      @JsonKey(name: 'entry_price') required this.entryPrice,
      @JsonKey(name: 'current_price') required this.currentPrice,
      @JsonKey(name: 'lot_size') required this.lotSize,
      @JsonKey(name: 'stop_loss') this.stopLoss,
      @JsonKey(name: 'take_profit') this.takeProfit,
      @JsonKey(name: 'open_time') required this.openTime})
      : super._();

  factory _$OpenTradeImpl.fromJson(Map<String, dynamic> json) =>
      _$$OpenTradeImplFromJson(json);

  @override
  @JsonKey(name: 'broker_ticket_id')
  final String brokerTicketId;
  @override
  @CurrencyPairConverter()
  final CurrencyPair pair;
  @override
  @DirectionConverter()
  final Direction direction;
  @override
  @JsonKey(name: 'entry_price')
  final double entryPrice;
  @override
  @JsonKey(name: 'current_price')
  final double currentPrice;
  @override
  @JsonKey(name: 'lot_size')
  final double lotSize;
  @override
  @JsonKey(name: 'stop_loss')
  final double? stopLoss;
  @override
  @JsonKey(name: 'take_profit')
  final double? takeProfit;
  @override
  @JsonKey(name: 'open_time')
  final DateTime openTime;

  @override
  String toString() {
    return 'OpenTrade(brokerTicketId: $brokerTicketId, pair: $pair, direction: $direction, entryPrice: $entryPrice, currentPrice: $currentPrice, lotSize: $lotSize, stopLoss: $stopLoss, takeProfit: $takeProfit, openTime: $openTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OpenTradeImpl &&
            (identical(other.brokerTicketId, brokerTicketId) ||
                other.brokerTicketId == brokerTicketId) &&
            (identical(other.pair, pair) || other.pair == pair) &&
            (identical(other.direction, direction) ||
                other.direction == direction) &&
            (identical(other.entryPrice, entryPrice) ||
                other.entryPrice == entryPrice) &&
            (identical(other.currentPrice, currentPrice) ||
                other.currentPrice == currentPrice) &&
            (identical(other.lotSize, lotSize) || other.lotSize == lotSize) &&
            (identical(other.stopLoss, stopLoss) ||
                other.stopLoss == stopLoss) &&
            (identical(other.takeProfit, takeProfit) ||
                other.takeProfit == takeProfit) &&
            (identical(other.openTime, openTime) ||
                other.openTime == openTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, brokerTicketId, pair, direction,
      entryPrice, currentPrice, lotSize, stopLoss, takeProfit, openTime);

  /// Create a copy of OpenTrade
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OpenTradeImplCopyWith<_$OpenTradeImpl> get copyWith =>
      __$$OpenTradeImplCopyWithImpl<_$OpenTradeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OpenTradeImplToJson(
      this,
    );
  }
}

abstract class _OpenTrade extends OpenTrade {
  const factory _OpenTrade(
      {@JsonKey(name: 'broker_ticket_id') required final String brokerTicketId,
      @CurrencyPairConverter() required final CurrencyPair pair,
      @DirectionConverter() required final Direction direction,
      @JsonKey(name: 'entry_price') required final double entryPrice,
      @JsonKey(name: 'current_price') required final double currentPrice,
      @JsonKey(name: 'lot_size') required final double lotSize,
      @JsonKey(name: 'stop_loss') final double? stopLoss,
      @JsonKey(name: 'take_profit') final double? takeProfit,
      @JsonKey(name: 'open_time')
      required final DateTime openTime}) = _$OpenTradeImpl;
  const _OpenTrade._() : super._();

  factory _OpenTrade.fromJson(Map<String, dynamic> json) =
      _$OpenTradeImpl.fromJson;

  @override
  @JsonKey(name: 'broker_ticket_id')
  String get brokerTicketId;
  @override
  @CurrencyPairConverter()
  CurrencyPair get pair;
  @override
  @DirectionConverter()
  Direction get direction;
  @override
  @JsonKey(name: 'entry_price')
  double get entryPrice;
  @override
  @JsonKey(name: 'current_price')
  double get currentPrice;
  @override
  @JsonKey(name: 'lot_size')
  double get lotSize;
  @override
  @JsonKey(name: 'stop_loss')
  double? get stopLoss;
  @override
  @JsonKey(name: 'take_profit')
  double? get takeProfit;
  @override
  @JsonKey(name: 'open_time')
  DateTime get openTime;

  /// Create a copy of OpenTrade
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OpenTradeImplCopyWith<_$OpenTradeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
