// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'backend_signal.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BackendSignal _$BackendSignalFromJson(Map<String, dynamic> json) {
  return _BackendSignal.fromJson(json);
}

/// @nodoc
mixin _$BackendSignal {
  @JsonKey(name: 'signal_id')
  String get signalId => throw _privateConstructorUsedError;
  @JsonKey(name: 'generated_at')
  DateTime get generatedAt => throw _privateConstructorUsedError;
  @CurrencyPairConverter()
  CurrencyPair get pair => throw _privateConstructorUsedError;
  @SignalActionConverter()
  SignalAction get action => throw _privateConstructorUsedError;
  @StrategyConverter()
  Strategy get strategy => throw _privateConstructorUsedError;
  @TimeframeConverter()
  Timeframe get timeframe => throw _privateConstructorUsedError;
  @SessionConverter()
  Session get session => throw _privateConstructorUsedError;
  @JsonKey(name: 'entry_price')
  double? get entryPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'stop_loss')
  double? get stopLoss => throw _privateConstructorUsedError;
  @JsonKey(name: 'take_profit')
  double? get takeProfit => throw _privateConstructorUsedError;
  @JsonKey(name: 'lot_size')
  double? get lotSize => throw _privateConstructorUsedError;
  double get confidence => throw _privateConstructorUsedError;
  String get reason => throw _privateConstructorUsedError;
  @JsonKey(name: 'timeframe_scores')
  Map<String, double> get timeframeScores => throw _privateConstructorUsedError;
  @RegimeConverter()
  Regime get regime => throw _privateConstructorUsedError;
  @JsonKey(name: 'regime_confidence')
  double get regimeConfidence => throw _privateConstructorUsedError;
  @JsonKey(name: 'strategy_confidence')
  double get strategyConfidence => throw _privateConstructorUsedError;
  @DirectionConverter()
  @JsonKey(name: 'h4_bias')
  Direction get h4Bias => throw _privateConstructorUsedError;
  @RegimeConverter()
  @JsonKey(name: 'h1_regime')
  Regime get h1Regime => throw _privateConstructorUsedError;
  @JsonKey(name: 'sentiment_score')
  double get sentimentScore => throw _privateConstructorUsedError;
  @JsonKey(name: 'risk_score')
  double get riskScore => throw _privateConstructorUsedError;
  @JsonKey(name: 'bars_in_regime')
  int get barsInRegime => throw _privateConstructorUsedError;
  @JsonKey(name: 'duration_warning')
  bool get durationWarning => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_valid')
  bool get isValid => throw _privateConstructorUsedError;
  @JsonKey(name: 'expires_at')
  DateTime get expiresAt => throw _privateConstructorUsedError;

  /// Serializes this BackendSignal to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BackendSignal
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BackendSignalCopyWith<BackendSignal> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BackendSignalCopyWith<$Res> {
  factory $BackendSignalCopyWith(
          BackendSignal value, $Res Function(BackendSignal) then) =
      _$BackendSignalCopyWithImpl<$Res, BackendSignal>;
  @useResult
  $Res call(
      {@JsonKey(name: 'signal_id') String signalId,
      @JsonKey(name: 'generated_at') DateTime generatedAt,
      @CurrencyPairConverter() CurrencyPair pair,
      @SignalActionConverter() SignalAction action,
      @StrategyConverter() Strategy strategy,
      @TimeframeConverter() Timeframe timeframe,
      @SessionConverter() Session session,
      @JsonKey(name: 'entry_price') double? entryPrice,
      @JsonKey(name: 'stop_loss') double? stopLoss,
      @JsonKey(name: 'take_profit') double? takeProfit,
      @JsonKey(name: 'lot_size') double? lotSize,
      double confidence,
      String reason,
      @JsonKey(name: 'timeframe_scores') Map<String, double> timeframeScores,
      @RegimeConverter() Regime regime,
      @JsonKey(name: 'regime_confidence') double regimeConfidence,
      @JsonKey(name: 'strategy_confidence') double strategyConfidence,
      @DirectionConverter() @JsonKey(name: 'h4_bias') Direction h4Bias,
      @RegimeConverter() @JsonKey(name: 'h1_regime') Regime h1Regime,
      @JsonKey(name: 'sentiment_score') double sentimentScore,
      @JsonKey(name: 'risk_score') double riskScore,
      @JsonKey(name: 'bars_in_regime') int barsInRegime,
      @JsonKey(name: 'duration_warning') bool durationWarning,
      @JsonKey(name: 'is_valid') bool isValid,
      @JsonKey(name: 'expires_at') DateTime expiresAt});
}

/// @nodoc
class _$BackendSignalCopyWithImpl<$Res, $Val extends BackendSignal>
    implements $BackendSignalCopyWith<$Res> {
  _$BackendSignalCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BackendSignal
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? signalId = null,
    Object? generatedAt = null,
    Object? pair = null,
    Object? action = null,
    Object? strategy = null,
    Object? timeframe = null,
    Object? session = null,
    Object? entryPrice = freezed,
    Object? stopLoss = freezed,
    Object? takeProfit = freezed,
    Object? lotSize = freezed,
    Object? confidence = null,
    Object? reason = null,
    Object? timeframeScores = null,
    Object? regime = null,
    Object? regimeConfidence = null,
    Object? strategyConfidence = null,
    Object? h4Bias = null,
    Object? h1Regime = null,
    Object? sentimentScore = null,
    Object? riskScore = null,
    Object? barsInRegime = null,
    Object? durationWarning = null,
    Object? isValid = null,
    Object? expiresAt = null,
  }) {
    return _then(_value.copyWith(
      signalId: null == signalId
          ? _value.signalId
          : signalId // ignore: cast_nullable_to_non_nullable
              as String,
      generatedAt: null == generatedAt
          ? _value.generatedAt
          : generatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      pair: null == pair
          ? _value.pair
          : pair // ignore: cast_nullable_to_non_nullable
              as CurrencyPair,
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as SignalAction,
      strategy: null == strategy
          ? _value.strategy
          : strategy // ignore: cast_nullable_to_non_nullable
              as Strategy,
      timeframe: null == timeframe
          ? _value.timeframe
          : timeframe // ignore: cast_nullable_to_non_nullable
              as Timeframe,
      session: null == session
          ? _value.session
          : session // ignore: cast_nullable_to_non_nullable
              as Session,
      entryPrice: freezed == entryPrice
          ? _value.entryPrice
          : entryPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      stopLoss: freezed == stopLoss
          ? _value.stopLoss
          : stopLoss // ignore: cast_nullable_to_non_nullable
              as double?,
      takeProfit: freezed == takeProfit
          ? _value.takeProfit
          : takeProfit // ignore: cast_nullable_to_non_nullable
              as double?,
      lotSize: freezed == lotSize
          ? _value.lotSize
          : lotSize // ignore: cast_nullable_to_non_nullable
              as double?,
      confidence: null == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double,
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
      timeframeScores: null == timeframeScores
          ? _value.timeframeScores
          : timeframeScores // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      regime: null == regime
          ? _value.regime
          : regime // ignore: cast_nullable_to_non_nullable
              as Regime,
      regimeConfidence: null == regimeConfidence
          ? _value.regimeConfidence
          : regimeConfidence // ignore: cast_nullable_to_non_nullable
              as double,
      strategyConfidence: null == strategyConfidence
          ? _value.strategyConfidence
          : strategyConfidence // ignore: cast_nullable_to_non_nullable
              as double,
      h4Bias: null == h4Bias
          ? _value.h4Bias
          : h4Bias // ignore: cast_nullable_to_non_nullable
              as Direction,
      h1Regime: null == h1Regime
          ? _value.h1Regime
          : h1Regime // ignore: cast_nullable_to_non_nullable
              as Regime,
      sentimentScore: null == sentimentScore
          ? _value.sentimentScore
          : sentimentScore // ignore: cast_nullable_to_non_nullable
              as double,
      riskScore: null == riskScore
          ? _value.riskScore
          : riskScore // ignore: cast_nullable_to_non_nullable
              as double,
      barsInRegime: null == barsInRegime
          ? _value.barsInRegime
          : barsInRegime // ignore: cast_nullable_to_non_nullable
              as int,
      durationWarning: null == durationWarning
          ? _value.durationWarning
          : durationWarning // ignore: cast_nullable_to_non_nullable
              as bool,
      isValid: null == isValid
          ? _value.isValid
          : isValid // ignore: cast_nullable_to_non_nullable
              as bool,
      expiresAt: null == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BackendSignalImplCopyWith<$Res>
    implements $BackendSignalCopyWith<$Res> {
  factory _$$BackendSignalImplCopyWith(
          _$BackendSignalImpl value, $Res Function(_$BackendSignalImpl) then) =
      __$$BackendSignalImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'signal_id') String signalId,
      @JsonKey(name: 'generated_at') DateTime generatedAt,
      @CurrencyPairConverter() CurrencyPair pair,
      @SignalActionConverter() SignalAction action,
      @StrategyConverter() Strategy strategy,
      @TimeframeConverter() Timeframe timeframe,
      @SessionConverter() Session session,
      @JsonKey(name: 'entry_price') double? entryPrice,
      @JsonKey(name: 'stop_loss') double? stopLoss,
      @JsonKey(name: 'take_profit') double? takeProfit,
      @JsonKey(name: 'lot_size') double? lotSize,
      double confidence,
      String reason,
      @JsonKey(name: 'timeframe_scores') Map<String, double> timeframeScores,
      @RegimeConverter() Regime regime,
      @JsonKey(name: 'regime_confidence') double regimeConfidence,
      @JsonKey(name: 'strategy_confidence') double strategyConfidence,
      @DirectionConverter() @JsonKey(name: 'h4_bias') Direction h4Bias,
      @RegimeConverter() @JsonKey(name: 'h1_regime') Regime h1Regime,
      @JsonKey(name: 'sentiment_score') double sentimentScore,
      @JsonKey(name: 'risk_score') double riskScore,
      @JsonKey(name: 'bars_in_regime') int barsInRegime,
      @JsonKey(name: 'duration_warning') bool durationWarning,
      @JsonKey(name: 'is_valid') bool isValid,
      @JsonKey(name: 'expires_at') DateTime expiresAt});
}

/// @nodoc
class __$$BackendSignalImplCopyWithImpl<$Res>
    extends _$BackendSignalCopyWithImpl<$Res, _$BackendSignalImpl>
    implements _$$BackendSignalImplCopyWith<$Res> {
  __$$BackendSignalImplCopyWithImpl(
      _$BackendSignalImpl _value, $Res Function(_$BackendSignalImpl) _then)
      : super(_value, _then);

  /// Create a copy of BackendSignal
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? signalId = null,
    Object? generatedAt = null,
    Object? pair = null,
    Object? action = null,
    Object? strategy = null,
    Object? timeframe = null,
    Object? session = null,
    Object? entryPrice = freezed,
    Object? stopLoss = freezed,
    Object? takeProfit = freezed,
    Object? lotSize = freezed,
    Object? confidence = null,
    Object? reason = null,
    Object? timeframeScores = null,
    Object? regime = null,
    Object? regimeConfidence = null,
    Object? strategyConfidence = null,
    Object? h4Bias = null,
    Object? h1Regime = null,
    Object? sentimentScore = null,
    Object? riskScore = null,
    Object? barsInRegime = null,
    Object? durationWarning = null,
    Object? isValid = null,
    Object? expiresAt = null,
  }) {
    return _then(_$BackendSignalImpl(
      signalId: null == signalId
          ? _value.signalId
          : signalId // ignore: cast_nullable_to_non_nullable
              as String,
      generatedAt: null == generatedAt
          ? _value.generatedAt
          : generatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      pair: null == pair
          ? _value.pair
          : pair // ignore: cast_nullable_to_non_nullable
              as CurrencyPair,
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as SignalAction,
      strategy: null == strategy
          ? _value.strategy
          : strategy // ignore: cast_nullable_to_non_nullable
              as Strategy,
      timeframe: null == timeframe
          ? _value.timeframe
          : timeframe // ignore: cast_nullable_to_non_nullable
              as Timeframe,
      session: null == session
          ? _value.session
          : session // ignore: cast_nullable_to_non_nullable
              as Session,
      entryPrice: freezed == entryPrice
          ? _value.entryPrice
          : entryPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      stopLoss: freezed == stopLoss
          ? _value.stopLoss
          : stopLoss // ignore: cast_nullable_to_non_nullable
              as double?,
      takeProfit: freezed == takeProfit
          ? _value.takeProfit
          : takeProfit // ignore: cast_nullable_to_non_nullable
              as double?,
      lotSize: freezed == lotSize
          ? _value.lotSize
          : lotSize // ignore: cast_nullable_to_non_nullable
              as double?,
      confidence: null == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double,
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
      timeframeScores: null == timeframeScores
          ? _value._timeframeScores
          : timeframeScores // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      regime: null == regime
          ? _value.regime
          : regime // ignore: cast_nullable_to_non_nullable
              as Regime,
      regimeConfidence: null == regimeConfidence
          ? _value.regimeConfidence
          : regimeConfidence // ignore: cast_nullable_to_non_nullable
              as double,
      strategyConfidence: null == strategyConfidence
          ? _value.strategyConfidence
          : strategyConfidence // ignore: cast_nullable_to_non_nullable
              as double,
      h4Bias: null == h4Bias
          ? _value.h4Bias
          : h4Bias // ignore: cast_nullable_to_non_nullable
              as Direction,
      h1Regime: null == h1Regime
          ? _value.h1Regime
          : h1Regime // ignore: cast_nullable_to_non_nullable
              as Regime,
      sentimentScore: null == sentimentScore
          ? _value.sentimentScore
          : sentimentScore // ignore: cast_nullable_to_non_nullable
              as double,
      riskScore: null == riskScore
          ? _value.riskScore
          : riskScore // ignore: cast_nullable_to_non_nullable
              as double,
      barsInRegime: null == barsInRegime
          ? _value.barsInRegime
          : barsInRegime // ignore: cast_nullable_to_non_nullable
              as int,
      durationWarning: null == durationWarning
          ? _value.durationWarning
          : durationWarning // ignore: cast_nullable_to_non_nullable
              as bool,
      isValid: null == isValid
          ? _value.isValid
          : isValid // ignore: cast_nullable_to_non_nullable
              as bool,
      expiresAt: null == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BackendSignalImpl extends _BackendSignal {
  const _$BackendSignalImpl(
      {@JsonKey(name: 'signal_id') required this.signalId,
      @JsonKey(name: 'generated_at') required this.generatedAt,
      @CurrencyPairConverter() required this.pair,
      @SignalActionConverter() required this.action,
      @StrategyConverter() required this.strategy,
      @TimeframeConverter() required this.timeframe,
      @SessionConverter() required this.session,
      @JsonKey(name: 'entry_price') this.entryPrice,
      @JsonKey(name: 'stop_loss') this.stopLoss,
      @JsonKey(name: 'take_profit') this.takeProfit,
      @JsonKey(name: 'lot_size') this.lotSize,
      this.confidence = 0.0,
      this.reason = '',
      @JsonKey(name: 'timeframe_scores')
      final Map<String, double> timeframeScores = const {},
      @RegimeConverter() this.regime = Regime.unknown,
      @JsonKey(name: 'regime_confidence') this.regimeConfidence = 0.0,
      @JsonKey(name: 'strategy_confidence') this.strategyConfidence = 0.0,
      @DirectionConverter()
      @JsonKey(name: 'h4_bias')
      this.h4Bias = Direction.neutral,
      @RegimeConverter()
      @JsonKey(name: 'h1_regime')
      this.h1Regime = Regime.unknown,
      @JsonKey(name: 'sentiment_score') this.sentimentScore = 0.0,
      @JsonKey(name: 'risk_score') this.riskScore = 0.0,
      @JsonKey(name: 'bars_in_regime') this.barsInRegime = 0,
      @JsonKey(name: 'duration_warning') this.durationWarning = false,
      @JsonKey(name: 'is_valid') this.isValid = true,
      @JsonKey(name: 'expires_at') required this.expiresAt})
      : _timeframeScores = timeframeScores,
        super._();

  factory _$BackendSignalImpl.fromJson(Map<String, dynamic> json) =>
      _$$BackendSignalImplFromJson(json);

  @override
  @JsonKey(name: 'signal_id')
  final String signalId;
  @override
  @JsonKey(name: 'generated_at')
  final DateTime generatedAt;
  @override
  @CurrencyPairConverter()
  final CurrencyPair pair;
  @override
  @SignalActionConverter()
  final SignalAction action;
  @override
  @StrategyConverter()
  final Strategy strategy;
  @override
  @TimeframeConverter()
  final Timeframe timeframe;
  @override
  @SessionConverter()
  final Session session;
  @override
  @JsonKey(name: 'entry_price')
  final double? entryPrice;
  @override
  @JsonKey(name: 'stop_loss')
  final double? stopLoss;
  @override
  @JsonKey(name: 'take_profit')
  final double? takeProfit;
  @override
  @JsonKey(name: 'lot_size')
  final double? lotSize;
  @override
  @JsonKey()
  final double confidence;
  @override
  @JsonKey()
  final String reason;
  final Map<String, double> _timeframeScores;
  @override
  @JsonKey(name: 'timeframe_scores')
  Map<String, double> get timeframeScores {
    if (_timeframeScores is EqualUnmodifiableMapView) return _timeframeScores;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_timeframeScores);
  }

  @override
  @JsonKey()
  @RegimeConverter()
  final Regime regime;
  @override
  @JsonKey(name: 'regime_confidence')
  final double regimeConfidence;
  @override
  @JsonKey(name: 'strategy_confidence')
  final double strategyConfidence;
  @override
  @DirectionConverter()
  @JsonKey(name: 'h4_bias')
  final Direction h4Bias;
  @override
  @RegimeConverter()
  @JsonKey(name: 'h1_regime')
  final Regime h1Regime;
  @override
  @JsonKey(name: 'sentiment_score')
  final double sentimentScore;
  @override
  @JsonKey(name: 'risk_score')
  final double riskScore;
  @override
  @JsonKey(name: 'bars_in_regime')
  final int barsInRegime;
  @override
  @JsonKey(name: 'duration_warning')
  final bool durationWarning;
  @override
  @JsonKey(name: 'is_valid')
  final bool isValid;
  @override
  @JsonKey(name: 'expires_at')
  final DateTime expiresAt;

  @override
  String toString() {
    return 'BackendSignal(signalId: $signalId, generatedAt: $generatedAt, pair: $pair, action: $action, strategy: $strategy, timeframe: $timeframe, session: $session, entryPrice: $entryPrice, stopLoss: $stopLoss, takeProfit: $takeProfit, lotSize: $lotSize, confidence: $confidence, reason: $reason, timeframeScores: $timeframeScores, regime: $regime, regimeConfidence: $regimeConfidence, strategyConfidence: $strategyConfidence, h4Bias: $h4Bias, h1Regime: $h1Regime, sentimentScore: $sentimentScore, riskScore: $riskScore, barsInRegime: $barsInRegime, durationWarning: $durationWarning, isValid: $isValid, expiresAt: $expiresAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BackendSignalImpl &&
            (identical(other.signalId, signalId) ||
                other.signalId == signalId) &&
            (identical(other.generatedAt, generatedAt) ||
                other.generatedAt == generatedAt) &&
            (identical(other.pair, pair) || other.pair == pair) &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.strategy, strategy) ||
                other.strategy == strategy) &&
            (identical(other.timeframe, timeframe) ||
                other.timeframe == timeframe) &&
            (identical(other.session, session) || other.session == session) &&
            (identical(other.entryPrice, entryPrice) ||
                other.entryPrice == entryPrice) &&
            (identical(other.stopLoss, stopLoss) ||
                other.stopLoss == stopLoss) &&
            (identical(other.takeProfit, takeProfit) ||
                other.takeProfit == takeProfit) &&
            (identical(other.lotSize, lotSize) || other.lotSize == lotSize) &&
            (identical(other.confidence, confidence) ||
                other.confidence == confidence) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            const DeepCollectionEquality()
                .equals(other._timeframeScores, _timeframeScores) &&
            (identical(other.regime, regime) || other.regime == regime) &&
            (identical(other.regimeConfidence, regimeConfidence) ||
                other.regimeConfidence == regimeConfidence) &&
            (identical(other.strategyConfidence, strategyConfidence) ||
                other.strategyConfidence == strategyConfidence) &&
            (identical(other.h4Bias, h4Bias) || other.h4Bias == h4Bias) &&
            (identical(other.h1Regime, h1Regime) ||
                other.h1Regime == h1Regime) &&
            (identical(other.sentimentScore, sentimentScore) ||
                other.sentimentScore == sentimentScore) &&
            (identical(other.riskScore, riskScore) ||
                other.riskScore == riskScore) &&
            (identical(other.barsInRegime, barsInRegime) ||
                other.barsInRegime == barsInRegime) &&
            (identical(other.durationWarning, durationWarning) ||
                other.durationWarning == durationWarning) &&
            (identical(other.isValid, isValid) || other.isValid == isValid) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        signalId,
        generatedAt,
        pair,
        action,
        strategy,
        timeframe,
        session,
        entryPrice,
        stopLoss,
        takeProfit,
        lotSize,
        confidence,
        reason,
        const DeepCollectionEquality().hash(_timeframeScores),
        regime,
        regimeConfidence,
        strategyConfidence,
        h4Bias,
        h1Regime,
        sentimentScore,
        riskScore,
        barsInRegime,
        durationWarning,
        isValid,
        expiresAt
      ]);

  /// Create a copy of BackendSignal
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BackendSignalImplCopyWith<_$BackendSignalImpl> get copyWith =>
      __$$BackendSignalImplCopyWithImpl<_$BackendSignalImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BackendSignalImplToJson(
      this,
    );
  }
}

abstract class _BackendSignal extends BackendSignal {
  const factory _BackendSignal(
      {@JsonKey(name: 'signal_id') required final String signalId,
      @JsonKey(name: 'generated_at') required final DateTime generatedAt,
      @CurrencyPairConverter() required final CurrencyPair pair,
      @SignalActionConverter() required final SignalAction action,
      @StrategyConverter() required final Strategy strategy,
      @TimeframeConverter() required final Timeframe timeframe,
      @SessionConverter() required final Session session,
      @JsonKey(name: 'entry_price') final double? entryPrice,
      @JsonKey(name: 'stop_loss') final double? stopLoss,
      @JsonKey(name: 'take_profit') final double? takeProfit,
      @JsonKey(name: 'lot_size') final double? lotSize,
      final double confidence,
      final String reason,
      @JsonKey(name: 'timeframe_scores')
      final Map<String, double> timeframeScores,
      @RegimeConverter() final Regime regime,
      @JsonKey(name: 'regime_confidence') final double regimeConfidence,
      @JsonKey(name: 'strategy_confidence') final double strategyConfidence,
      @DirectionConverter() @JsonKey(name: 'h4_bias') final Direction h4Bias,
      @RegimeConverter() @JsonKey(name: 'h1_regime') final Regime h1Regime,
      @JsonKey(name: 'sentiment_score') final double sentimentScore,
      @JsonKey(name: 'risk_score') final double riskScore,
      @JsonKey(name: 'bars_in_regime') final int barsInRegime,
      @JsonKey(name: 'duration_warning') final bool durationWarning,
      @JsonKey(name: 'is_valid') final bool isValid,
      @JsonKey(name: 'expires_at')
      required final DateTime expiresAt}) = _$BackendSignalImpl;
  const _BackendSignal._() : super._();

  factory _BackendSignal.fromJson(Map<String, dynamic> json) =
      _$BackendSignalImpl.fromJson;

  @override
  @JsonKey(name: 'signal_id')
  String get signalId;
  @override
  @JsonKey(name: 'generated_at')
  DateTime get generatedAt;
  @override
  @CurrencyPairConverter()
  CurrencyPair get pair;
  @override
  @SignalActionConverter()
  SignalAction get action;
  @override
  @StrategyConverter()
  Strategy get strategy;
  @override
  @TimeframeConverter()
  Timeframe get timeframe;
  @override
  @SessionConverter()
  Session get session;
  @override
  @JsonKey(name: 'entry_price')
  double? get entryPrice;
  @override
  @JsonKey(name: 'stop_loss')
  double? get stopLoss;
  @override
  @JsonKey(name: 'take_profit')
  double? get takeProfit;
  @override
  @JsonKey(name: 'lot_size')
  double? get lotSize;
  @override
  double get confidence;
  @override
  String get reason;
  @override
  @JsonKey(name: 'timeframe_scores')
  Map<String, double> get timeframeScores;
  @override
  @RegimeConverter()
  Regime get regime;
  @override
  @JsonKey(name: 'regime_confidence')
  double get regimeConfidence;
  @override
  @JsonKey(name: 'strategy_confidence')
  double get strategyConfidence;
  @override
  @DirectionConverter()
  @JsonKey(name: 'h4_bias')
  Direction get h4Bias;
  @override
  @RegimeConverter()
  @JsonKey(name: 'h1_regime')
  Regime get h1Regime;
  @override
  @JsonKey(name: 'sentiment_score')
  double get sentimentScore;
  @override
  @JsonKey(name: 'risk_score')
  double get riskScore;
  @override
  @JsonKey(name: 'bars_in_regime')
  int get barsInRegime;
  @override
  @JsonKey(name: 'duration_warning')
  bool get durationWarning;
  @override
  @JsonKey(name: 'is_valid')
  bool get isValid;
  @override
  @JsonKey(name: 'expires_at')
  DateTime get expiresAt;

  /// Create a copy of BackendSignal
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BackendSignalImplCopyWith<_$BackendSignalImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
