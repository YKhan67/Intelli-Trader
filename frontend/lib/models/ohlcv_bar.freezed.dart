// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ohlcv_bar.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

OHLCVBar _$OHLCVBarFromJson(Map<String, dynamic> json) {
  return _OHLCVBar.fromJson(json);
}

/// @nodoc
mixin _$OHLCVBar {
  @CurrencyPairConverter()
  CurrencyPair get pair => throw _privateConstructorUsedError;
  @TimeframeConverter()
  Timeframe get timeframe => throw _privateConstructorUsedError;
  DateTime? get timestamp => throw _privateConstructorUsedError;
  double get open => throw _privateConstructorUsedError;
  double get high => throw _privateConstructorUsedError;
  double get low => throw _privateConstructorUsedError;
  double get close => throw _privateConstructorUsedError;
  double get volume => throw _privateConstructorUsedError;
  @JsonKey(name: 'spread_pips')
  double get spreadPips => throw _privateConstructorUsedError;

  /// Serializes this OHLCVBar to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OHLCVBar
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OHLCVBarCopyWith<OHLCVBar> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OHLCVBarCopyWith<$Res> {
  factory $OHLCVBarCopyWith(OHLCVBar value, $Res Function(OHLCVBar) then) =
      _$OHLCVBarCopyWithImpl<$Res, OHLCVBar>;
  @useResult
  $Res call(
      {@CurrencyPairConverter() CurrencyPair pair,
      @TimeframeConverter() Timeframe timeframe,
      DateTime? timestamp,
      double open,
      double high,
      double low,
      double close,
      double volume,
      @JsonKey(name: 'spread_pips') double spreadPips});
}

/// @nodoc
class _$OHLCVBarCopyWithImpl<$Res, $Val extends OHLCVBar>
    implements $OHLCVBarCopyWith<$Res> {
  _$OHLCVBarCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OHLCVBar
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pair = null,
    Object? timeframe = null,
    Object? timestamp = freezed,
    Object? open = null,
    Object? high = null,
    Object? low = null,
    Object? close = null,
    Object? volume = null,
    Object? spreadPips = null,
  }) {
    return _then(_value.copyWith(
      pair: null == pair
          ? _value.pair
          : pair // ignore: cast_nullable_to_non_nullable
              as CurrencyPair,
      timeframe: null == timeframe
          ? _value.timeframe
          : timeframe // ignore: cast_nullable_to_non_nullable
              as Timeframe,
      timestamp: freezed == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      open: null == open
          ? _value.open
          : open // ignore: cast_nullable_to_non_nullable
              as double,
      high: null == high
          ? _value.high
          : high // ignore: cast_nullable_to_non_nullable
              as double,
      low: null == low
          ? _value.low
          : low // ignore: cast_nullable_to_non_nullable
              as double,
      close: null == close
          ? _value.close
          : close // ignore: cast_nullable_to_non_nullable
              as double,
      volume: null == volume
          ? _value.volume
          : volume // ignore: cast_nullable_to_non_nullable
              as double,
      spreadPips: null == spreadPips
          ? _value.spreadPips
          : spreadPips // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OHLCVBarImplCopyWith<$Res>
    implements $OHLCVBarCopyWith<$Res> {
  factory _$$OHLCVBarImplCopyWith(
          _$OHLCVBarImpl value, $Res Function(_$OHLCVBarImpl) then) =
      __$$OHLCVBarImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@CurrencyPairConverter() CurrencyPair pair,
      @TimeframeConverter() Timeframe timeframe,
      DateTime? timestamp,
      double open,
      double high,
      double low,
      double close,
      double volume,
      @JsonKey(name: 'spread_pips') double spreadPips});
}

/// @nodoc
class __$$OHLCVBarImplCopyWithImpl<$Res>
    extends _$OHLCVBarCopyWithImpl<$Res, _$OHLCVBarImpl>
    implements _$$OHLCVBarImplCopyWith<$Res> {
  __$$OHLCVBarImplCopyWithImpl(
      _$OHLCVBarImpl _value, $Res Function(_$OHLCVBarImpl) _then)
      : super(_value, _then);

  /// Create a copy of OHLCVBar
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pair = null,
    Object? timeframe = null,
    Object? timestamp = freezed,
    Object? open = null,
    Object? high = null,
    Object? low = null,
    Object? close = null,
    Object? volume = null,
    Object? spreadPips = null,
  }) {
    return _then(_$OHLCVBarImpl(
      pair: null == pair
          ? _value.pair
          : pair // ignore: cast_nullable_to_non_nullable
              as CurrencyPair,
      timeframe: null == timeframe
          ? _value.timeframe
          : timeframe // ignore: cast_nullable_to_non_nullable
              as Timeframe,
      timestamp: freezed == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      open: null == open
          ? _value.open
          : open // ignore: cast_nullable_to_non_nullable
              as double,
      high: null == high
          ? _value.high
          : high // ignore: cast_nullable_to_non_nullable
              as double,
      low: null == low
          ? _value.low
          : low // ignore: cast_nullable_to_non_nullable
              as double,
      close: null == close
          ? _value.close
          : close // ignore: cast_nullable_to_non_nullable
              as double,
      volume: null == volume
          ? _value.volume
          : volume // ignore: cast_nullable_to_non_nullable
              as double,
      spreadPips: null == spreadPips
          ? _value.spreadPips
          : spreadPips // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OHLCVBarImpl extends _OHLCVBar {
  const _$OHLCVBarImpl(
      {@CurrencyPairConverter() required this.pair,
      @TimeframeConverter() required this.timeframe,
      this.timestamp,
      required this.open,
      required this.high,
      required this.low,
      required this.close,
      required this.volume,
      @JsonKey(name: 'spread_pips') required this.spreadPips})
      : super._();

  factory _$OHLCVBarImpl.fromJson(Map<String, dynamic> json) =>
      _$$OHLCVBarImplFromJson(json);

  @override
  @CurrencyPairConverter()
  final CurrencyPair pair;
  @override
  @TimeframeConverter()
  final Timeframe timeframe;
  @override
  final DateTime? timestamp;
  @override
  final double open;
  @override
  final double high;
  @override
  final double low;
  @override
  final double close;
  @override
  final double volume;
  @override
  @JsonKey(name: 'spread_pips')
  final double spreadPips;

  @override
  String toString() {
    return 'OHLCVBar(pair: $pair, timeframe: $timeframe, timestamp: $timestamp, open: $open, high: $high, low: $low, close: $close, volume: $volume, spreadPips: $spreadPips)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OHLCVBarImpl &&
            (identical(other.pair, pair) || other.pair == pair) &&
            (identical(other.timeframe, timeframe) ||
                other.timeframe == timeframe) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.open, open) || other.open == open) &&
            (identical(other.high, high) || other.high == high) &&
            (identical(other.low, low) || other.low == low) &&
            (identical(other.close, close) || other.close == close) &&
            (identical(other.volume, volume) || other.volume == volume) &&
            (identical(other.spreadPips, spreadPips) ||
                other.spreadPips == spreadPips));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, pair, timeframe, timestamp, open,
      high, low, close, volume, spreadPips);

  /// Create a copy of OHLCVBar
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OHLCVBarImplCopyWith<_$OHLCVBarImpl> get copyWith =>
      __$$OHLCVBarImplCopyWithImpl<_$OHLCVBarImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OHLCVBarImplToJson(
      this,
    );
  }
}

abstract class _OHLCVBar extends OHLCVBar {
  const factory _OHLCVBar(
          {@CurrencyPairConverter() required final CurrencyPair pair,
          @TimeframeConverter() required final Timeframe timeframe,
          final DateTime? timestamp,
          required final double open,
          required final double high,
          required final double low,
          required final double close,
          required final double volume,
          @JsonKey(name: 'spread_pips') required final double spreadPips}) =
      _$OHLCVBarImpl;
  const _OHLCVBar._() : super._();

  factory _OHLCVBar.fromJson(Map<String, dynamic> json) =
      _$OHLCVBarImpl.fromJson;

  @override
  @CurrencyPairConverter()
  CurrencyPair get pair;
  @override
  @TimeframeConverter()
  Timeframe get timeframe;
  @override
  DateTime? get timestamp;
  @override
  double get open;
  @override
  double get high;
  @override
  double get low;
  @override
  double get close;
  @override
  double get volume;
  @override
  @JsonKey(name: 'spread_pips')
  double get spreadPips;

  /// Create a copy of OHLCVBar
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OHLCVBarImplCopyWith<_$OHLCVBarImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
