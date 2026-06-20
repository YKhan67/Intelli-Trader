// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'indicator_set.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

IndicatorSet _$IndicatorSetFromJson(Map<String, dynamic> json) {
  return _IndicatorSet.fromJson(json);
}

/// @nodoc
mixin _$IndicatorSet {
  @CurrencyPairConverter()
  CurrencyPair get pair => throw _privateConstructorUsedError;
  @TimeframeConverter()
  Timeframe get timeframe => throw _privateConstructorUsedError;
  DateTime? get timestamp => throw _privateConstructorUsedError;
  @JsonKey(name: 'ema_50')
  double? get ema50 => throw _privateConstructorUsedError;
  @JsonKey(name: 'ema_200')
  double? get ema200 => throw _privateConstructorUsedError;
  double? get rsi => throw _privateConstructorUsedError;
  @JsonKey(name: 'macd_line')
  double? get macdLine => throw _privateConstructorUsedError;
  @JsonKey(name: 'macd_signal')
  double? get macdSignal => throw _privateConstructorUsedError;
  @JsonKey(name: 'macd_histogram')
  double? get macdHistogram => throw _privateConstructorUsedError;

  /// Serializes this IndicatorSet to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of IndicatorSet
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IndicatorSetCopyWith<IndicatorSet> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IndicatorSetCopyWith<$Res> {
  factory $IndicatorSetCopyWith(
          IndicatorSet value, $Res Function(IndicatorSet) then) =
      _$IndicatorSetCopyWithImpl<$Res, IndicatorSet>;
  @useResult
  $Res call(
      {@CurrencyPairConverter() CurrencyPair pair,
      @TimeframeConverter() Timeframe timeframe,
      DateTime? timestamp,
      @JsonKey(name: 'ema_50') double? ema50,
      @JsonKey(name: 'ema_200') double? ema200,
      double? rsi,
      @JsonKey(name: 'macd_line') double? macdLine,
      @JsonKey(name: 'macd_signal') double? macdSignal,
      @JsonKey(name: 'macd_histogram') double? macdHistogram});
}

/// @nodoc
class _$IndicatorSetCopyWithImpl<$Res, $Val extends IndicatorSet>
    implements $IndicatorSetCopyWith<$Res> {
  _$IndicatorSetCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of IndicatorSet
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pair = null,
    Object? timeframe = null,
    Object? timestamp = freezed,
    Object? ema50 = freezed,
    Object? ema200 = freezed,
    Object? rsi = freezed,
    Object? macdLine = freezed,
    Object? macdSignal = freezed,
    Object? macdHistogram = freezed,
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
      ema50: freezed == ema50
          ? _value.ema50
          : ema50 // ignore: cast_nullable_to_non_nullable
              as double?,
      ema200: freezed == ema200
          ? _value.ema200
          : ema200 // ignore: cast_nullable_to_non_nullable
              as double?,
      rsi: freezed == rsi
          ? _value.rsi
          : rsi // ignore: cast_nullable_to_non_nullable
              as double?,
      macdLine: freezed == macdLine
          ? _value.macdLine
          : macdLine // ignore: cast_nullable_to_non_nullable
              as double?,
      macdSignal: freezed == macdSignal
          ? _value.macdSignal
          : macdSignal // ignore: cast_nullable_to_non_nullable
              as double?,
      macdHistogram: freezed == macdHistogram
          ? _value.macdHistogram
          : macdHistogram // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$IndicatorSetImplCopyWith<$Res>
    implements $IndicatorSetCopyWith<$Res> {
  factory _$$IndicatorSetImplCopyWith(
          _$IndicatorSetImpl value, $Res Function(_$IndicatorSetImpl) then) =
      __$$IndicatorSetImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@CurrencyPairConverter() CurrencyPair pair,
      @TimeframeConverter() Timeframe timeframe,
      DateTime? timestamp,
      @JsonKey(name: 'ema_50') double? ema50,
      @JsonKey(name: 'ema_200') double? ema200,
      double? rsi,
      @JsonKey(name: 'macd_line') double? macdLine,
      @JsonKey(name: 'macd_signal') double? macdSignal,
      @JsonKey(name: 'macd_histogram') double? macdHistogram});
}

/// @nodoc
class __$$IndicatorSetImplCopyWithImpl<$Res>
    extends _$IndicatorSetCopyWithImpl<$Res, _$IndicatorSetImpl>
    implements _$$IndicatorSetImplCopyWith<$Res> {
  __$$IndicatorSetImplCopyWithImpl(
      _$IndicatorSetImpl _value, $Res Function(_$IndicatorSetImpl) _then)
      : super(_value, _then);

  /// Create a copy of IndicatorSet
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pair = null,
    Object? timeframe = null,
    Object? timestamp = freezed,
    Object? ema50 = freezed,
    Object? ema200 = freezed,
    Object? rsi = freezed,
    Object? macdLine = freezed,
    Object? macdSignal = freezed,
    Object? macdHistogram = freezed,
  }) {
    return _then(_$IndicatorSetImpl(
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
      ema50: freezed == ema50
          ? _value.ema50
          : ema50 // ignore: cast_nullable_to_non_nullable
              as double?,
      ema200: freezed == ema200
          ? _value.ema200
          : ema200 // ignore: cast_nullable_to_non_nullable
              as double?,
      rsi: freezed == rsi
          ? _value.rsi
          : rsi // ignore: cast_nullable_to_non_nullable
              as double?,
      macdLine: freezed == macdLine
          ? _value.macdLine
          : macdLine // ignore: cast_nullable_to_non_nullable
              as double?,
      macdSignal: freezed == macdSignal
          ? _value.macdSignal
          : macdSignal // ignore: cast_nullable_to_non_nullable
              as double?,
      macdHistogram: freezed == macdHistogram
          ? _value.macdHistogram
          : macdHistogram // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$IndicatorSetImpl implements _IndicatorSet {
  const _$IndicatorSetImpl(
      {@CurrencyPairConverter() this.pair = CurrencyPair.unknown,
      @TimeframeConverter() this.timeframe = Timeframe.h1,
      this.timestamp,
      @JsonKey(name: 'ema_50') this.ema50,
      @JsonKey(name: 'ema_200') this.ema200,
      this.rsi,
      @JsonKey(name: 'macd_line') this.macdLine,
      @JsonKey(name: 'macd_signal') this.macdSignal,
      @JsonKey(name: 'macd_histogram') this.macdHistogram});

  factory _$IndicatorSetImpl.fromJson(Map<String, dynamic> json) =>
      _$$IndicatorSetImplFromJson(json);

  @override
  @JsonKey()
  @CurrencyPairConverter()
  final CurrencyPair pair;
  @override
  @JsonKey()
  @TimeframeConverter()
  final Timeframe timeframe;
  @override
  final DateTime? timestamp;
  @override
  @JsonKey(name: 'ema_50')
  final double? ema50;
  @override
  @JsonKey(name: 'ema_200')
  final double? ema200;
  @override
  final double? rsi;
  @override
  @JsonKey(name: 'macd_line')
  final double? macdLine;
  @override
  @JsonKey(name: 'macd_signal')
  final double? macdSignal;
  @override
  @JsonKey(name: 'macd_histogram')
  final double? macdHistogram;

  @override
  String toString() {
    return 'IndicatorSet(pair: $pair, timeframe: $timeframe, timestamp: $timestamp, ema50: $ema50, ema200: $ema200, rsi: $rsi, macdLine: $macdLine, macdSignal: $macdSignal, macdHistogram: $macdHistogram)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IndicatorSetImpl &&
            (identical(other.pair, pair) || other.pair == pair) &&
            (identical(other.timeframe, timeframe) ||
                other.timeframe == timeframe) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.ema50, ema50) || other.ema50 == ema50) &&
            (identical(other.ema200, ema200) || other.ema200 == ema200) &&
            (identical(other.rsi, rsi) || other.rsi == rsi) &&
            (identical(other.macdLine, macdLine) ||
                other.macdLine == macdLine) &&
            (identical(other.macdSignal, macdSignal) ||
                other.macdSignal == macdSignal) &&
            (identical(other.macdHistogram, macdHistogram) ||
                other.macdHistogram == macdHistogram));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, pair, timeframe, timestamp,
      ema50, ema200, rsi, macdLine, macdSignal, macdHistogram);

  /// Create a copy of IndicatorSet
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IndicatorSetImplCopyWith<_$IndicatorSetImpl> get copyWith =>
      __$$IndicatorSetImplCopyWithImpl<_$IndicatorSetImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$IndicatorSetImplToJson(
      this,
    );
  }
}

abstract class _IndicatorSet implements IndicatorSet {
  const factory _IndicatorSet(
          {@CurrencyPairConverter() final CurrencyPair pair,
          @TimeframeConverter() final Timeframe timeframe,
          final DateTime? timestamp,
          @JsonKey(name: 'ema_50') final double? ema50,
          @JsonKey(name: 'ema_200') final double? ema200,
          final double? rsi,
          @JsonKey(name: 'macd_line') final double? macdLine,
          @JsonKey(name: 'macd_signal') final double? macdSignal,
          @JsonKey(name: 'macd_histogram') final double? macdHistogram}) =
      _$IndicatorSetImpl;

  factory _IndicatorSet.fromJson(Map<String, dynamic> json) =
      _$IndicatorSetImpl.fromJson;

  @override
  @CurrencyPairConverter()
  CurrencyPair get pair;
  @override
  @TimeframeConverter()
  Timeframe get timeframe;
  @override
  DateTime? get timestamp;
  @override
  @JsonKey(name: 'ema_50')
  double? get ema50;
  @override
  @JsonKey(name: 'ema_200')
  double? get ema200;
  @override
  double? get rsi;
  @override
  @JsonKey(name: 'macd_line')
  double? get macdLine;
  @override
  @JsonKey(name: 'macd_signal')
  double? get macdSignal;
  @override
  @JsonKey(name: 'macd_histogram')
  double? get macdHistogram;

  /// Create a copy of IndicatorSet
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IndicatorSetImplCopyWith<_$IndicatorSetImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
