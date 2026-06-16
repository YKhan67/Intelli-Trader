// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'regime_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RegimeResult _$RegimeResultFromJson(Map<String, dynamic> json) {
  return _RegimeResult.fromJson(json);
}

/// @nodoc
mixin _$RegimeResult {
  DateTime get timestamp => throw _privateConstructorUsedError;
  @CurrencyPairConverter()
  CurrencyPair get pair => throw _privateConstructorUsedError;
  @TimeframeConverter()
  Timeframe get timeframe => throw _privateConstructorUsedError;
  @RegimeConverter()
  Regime get regime => throw _privateConstructorUsedError;
  double get confidence => throw _privateConstructorUsedError;
  @JsonKey(name: 'h4_bias')
  @DirectionConverter()
  Direction get h4Bias => throw _privateConstructorUsedError;
  @JsonKey(name: 'h1_regime')
  @RegimeConverter()
  Regime get h1Regime => throw _privateConstructorUsedError;
  @JsonKey(name: 'bars_in_regime')
  int get barsInRegime => throw _privateConstructorUsedError;
  @JsonKey(name: 'regime_changed')
  bool get regimeChanged => throw _privateConstructorUsedError;
  @JsonKey(name: 'duration_warning')
  bool get durationWarning => throw _privateConstructorUsedError;

  /// Serializes this RegimeResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RegimeResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RegimeResultCopyWith<RegimeResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RegimeResultCopyWith<$Res> {
  factory $RegimeResultCopyWith(
          RegimeResult value, $Res Function(RegimeResult) then) =
      _$RegimeResultCopyWithImpl<$Res, RegimeResult>;
  @useResult
  $Res call(
      {DateTime timestamp,
      @CurrencyPairConverter() CurrencyPair pair,
      @TimeframeConverter() Timeframe timeframe,
      @RegimeConverter() Regime regime,
      double confidence,
      @JsonKey(name: 'h4_bias') @DirectionConverter() Direction h4Bias,
      @JsonKey(name: 'h1_regime') @RegimeConverter() Regime h1Regime,
      @JsonKey(name: 'bars_in_regime') int barsInRegime,
      @JsonKey(name: 'regime_changed') bool regimeChanged,
      @JsonKey(name: 'duration_warning') bool durationWarning});
}

/// @nodoc
class _$RegimeResultCopyWithImpl<$Res, $Val extends RegimeResult>
    implements $RegimeResultCopyWith<$Res> {
  _$RegimeResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RegimeResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timestamp = null,
    Object? pair = null,
    Object? timeframe = null,
    Object? regime = null,
    Object? confidence = null,
    Object? h4Bias = null,
    Object? h1Regime = null,
    Object? barsInRegime = null,
    Object? regimeChanged = null,
    Object? durationWarning = null,
  }) {
    return _then(_value.copyWith(
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      pair: null == pair
          ? _value.pair
          : pair // ignore: cast_nullable_to_non_nullable
              as CurrencyPair,
      timeframe: null == timeframe
          ? _value.timeframe
          : timeframe // ignore: cast_nullable_to_non_nullable
              as Timeframe,
      regime: null == regime
          ? _value.regime
          : regime // ignore: cast_nullable_to_non_nullable
              as Regime,
      confidence: null == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double,
      h4Bias: null == h4Bias
          ? _value.h4Bias
          : h4Bias // ignore: cast_nullable_to_non_nullable
              as Direction,
      h1Regime: null == h1Regime
          ? _value.h1Regime
          : h1Regime // ignore: cast_nullable_to_non_nullable
              as Regime,
      barsInRegime: null == barsInRegime
          ? _value.barsInRegime
          : barsInRegime // ignore: cast_nullable_to_non_nullable
              as int,
      regimeChanged: null == regimeChanged
          ? _value.regimeChanged
          : regimeChanged // ignore: cast_nullable_to_non_nullable
              as bool,
      durationWarning: null == durationWarning
          ? _value.durationWarning
          : durationWarning // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RegimeResultImplCopyWith<$Res>
    implements $RegimeResultCopyWith<$Res> {
  factory _$$RegimeResultImplCopyWith(
          _$RegimeResultImpl value, $Res Function(_$RegimeResultImpl) then) =
      __$$RegimeResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime timestamp,
      @CurrencyPairConverter() CurrencyPair pair,
      @TimeframeConverter() Timeframe timeframe,
      @RegimeConverter() Regime regime,
      double confidence,
      @JsonKey(name: 'h4_bias') @DirectionConverter() Direction h4Bias,
      @JsonKey(name: 'h1_regime') @RegimeConverter() Regime h1Regime,
      @JsonKey(name: 'bars_in_regime') int barsInRegime,
      @JsonKey(name: 'regime_changed') bool regimeChanged,
      @JsonKey(name: 'duration_warning') bool durationWarning});
}

/// @nodoc
class __$$RegimeResultImplCopyWithImpl<$Res>
    extends _$RegimeResultCopyWithImpl<$Res, _$RegimeResultImpl>
    implements _$$RegimeResultImplCopyWith<$Res> {
  __$$RegimeResultImplCopyWithImpl(
      _$RegimeResultImpl _value, $Res Function(_$RegimeResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of RegimeResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timestamp = null,
    Object? pair = null,
    Object? timeframe = null,
    Object? regime = null,
    Object? confidence = null,
    Object? h4Bias = null,
    Object? h1Regime = null,
    Object? barsInRegime = null,
    Object? regimeChanged = null,
    Object? durationWarning = null,
  }) {
    return _then(_$RegimeResultImpl(
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      pair: null == pair
          ? _value.pair
          : pair // ignore: cast_nullable_to_non_nullable
              as CurrencyPair,
      timeframe: null == timeframe
          ? _value.timeframe
          : timeframe // ignore: cast_nullable_to_non_nullable
              as Timeframe,
      regime: null == regime
          ? _value.regime
          : regime // ignore: cast_nullable_to_non_nullable
              as Regime,
      confidence: null == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double,
      h4Bias: null == h4Bias
          ? _value.h4Bias
          : h4Bias // ignore: cast_nullable_to_non_nullable
              as Direction,
      h1Regime: null == h1Regime
          ? _value.h1Regime
          : h1Regime // ignore: cast_nullable_to_non_nullable
              as Regime,
      barsInRegime: null == barsInRegime
          ? _value.barsInRegime
          : barsInRegime // ignore: cast_nullable_to_non_nullable
              as int,
      regimeChanged: null == regimeChanged
          ? _value.regimeChanged
          : regimeChanged // ignore: cast_nullable_to_non_nullable
              as bool,
      durationWarning: null == durationWarning
          ? _value.durationWarning
          : durationWarning // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RegimeResultImpl implements _RegimeResult {
  const _$RegimeResultImpl(
      {required this.timestamp,
      @CurrencyPairConverter() required this.pair,
      @TimeframeConverter() required this.timeframe,
      @RegimeConverter() required this.regime,
      required this.confidence,
      @JsonKey(name: 'h4_bias') @DirectionConverter() required this.h4Bias,
      @JsonKey(name: 'h1_regime') @RegimeConverter() required this.h1Regime,
      @JsonKey(name: 'bars_in_regime') required this.barsInRegime,
      @JsonKey(name: 'regime_changed') required this.regimeChanged,
      @JsonKey(name: 'duration_warning') required this.durationWarning});

  factory _$RegimeResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$RegimeResultImplFromJson(json);

  @override
  final DateTime timestamp;
  @override
  @CurrencyPairConverter()
  final CurrencyPair pair;
  @override
  @TimeframeConverter()
  final Timeframe timeframe;
  @override
  @RegimeConverter()
  final Regime regime;
  @override
  final double confidence;
  @override
  @JsonKey(name: 'h4_bias')
  @DirectionConverter()
  final Direction h4Bias;
  @override
  @JsonKey(name: 'h1_regime')
  @RegimeConverter()
  final Regime h1Regime;
  @override
  @JsonKey(name: 'bars_in_regime')
  final int barsInRegime;
  @override
  @JsonKey(name: 'regime_changed')
  final bool regimeChanged;
  @override
  @JsonKey(name: 'duration_warning')
  final bool durationWarning;

  @override
  String toString() {
    return 'RegimeResult(timestamp: $timestamp, pair: $pair, timeframe: $timeframe, regime: $regime, confidence: $confidence, h4Bias: $h4Bias, h1Regime: $h1Regime, barsInRegime: $barsInRegime, regimeChanged: $regimeChanged, durationWarning: $durationWarning)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RegimeResultImpl &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.pair, pair) || other.pair == pair) &&
            (identical(other.timeframe, timeframe) ||
                other.timeframe == timeframe) &&
            (identical(other.regime, regime) || other.regime == regime) &&
            (identical(other.confidence, confidence) ||
                other.confidence == confidence) &&
            (identical(other.h4Bias, h4Bias) || other.h4Bias == h4Bias) &&
            (identical(other.h1Regime, h1Regime) ||
                other.h1Regime == h1Regime) &&
            (identical(other.barsInRegime, barsInRegime) ||
                other.barsInRegime == barsInRegime) &&
            (identical(other.regimeChanged, regimeChanged) ||
                other.regimeChanged == regimeChanged) &&
            (identical(other.durationWarning, durationWarning) ||
                other.durationWarning == durationWarning));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      timestamp,
      pair,
      timeframe,
      regime,
      confidence,
      h4Bias,
      h1Regime,
      barsInRegime,
      regimeChanged,
      durationWarning);

  /// Create a copy of RegimeResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RegimeResultImplCopyWith<_$RegimeResultImpl> get copyWith =>
      __$$RegimeResultImplCopyWithImpl<_$RegimeResultImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RegimeResultImplToJson(
      this,
    );
  }
}

abstract class _RegimeResult implements RegimeResult {
  const factory _RegimeResult(
      {required final DateTime timestamp,
      @CurrencyPairConverter() required final CurrencyPair pair,
      @TimeframeConverter() required final Timeframe timeframe,
      @RegimeConverter() required final Regime regime,
      required final double confidence,
      @JsonKey(name: 'h4_bias')
      @DirectionConverter()
      required final Direction h4Bias,
      @JsonKey(name: 'h1_regime')
      @RegimeConverter()
      required final Regime h1Regime,
      @JsonKey(name: 'bars_in_regime') required final int barsInRegime,
      @JsonKey(name: 'regime_changed') required final bool regimeChanged,
      @JsonKey(name: 'duration_warning')
      required final bool durationWarning}) = _$RegimeResultImpl;

  factory _RegimeResult.fromJson(Map<String, dynamic> json) =
      _$RegimeResultImpl.fromJson;

  @override
  DateTime get timestamp;
  @override
  @CurrencyPairConverter()
  CurrencyPair get pair;
  @override
  @TimeframeConverter()
  Timeframe get timeframe;
  @override
  @RegimeConverter()
  Regime get regime;
  @override
  double get confidence;
  @override
  @JsonKey(name: 'h4_bias')
  @DirectionConverter()
  Direction get h4Bias;
  @override
  @JsonKey(name: 'h1_regime')
  @RegimeConverter()
  Regime get h1Regime;
  @override
  @JsonKey(name: 'bars_in_regime')
  int get barsInRegime;
  @override
  @JsonKey(name: 'regime_changed')
  bool get regimeChanged;
  @override
  @JsonKey(name: 'duration_warning')
  bool get durationWarning;

  /// Create a copy of RegimeResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RegimeResultImplCopyWith<_$RegimeResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
