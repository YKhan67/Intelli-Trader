import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums.dart';
import 'converters.dart';

part 'backend_signal.freezed.dart';
part 'backend_signal.g.dart';

@freezed
class BackendSignal with _$BackendSignal {
  const factory BackendSignal({
    @JsonKey(name: 'signal_id') required String signalId,
    @JsonKey(name: 'generated_at') required DateTime generatedAt,
    @CurrencyPairConverter() required CurrencyPair pair,
    @SignalActionConverter() required SignalAction action,
    @StrategyConverter() required Strategy strategy,
    @TimeframeConverter() required Timeframe timeframe,
    @SessionConverter() required Session session,
    @JsonKey(name: 'entry_price') double? entryPrice,
    @JsonKey(name: 'stop_loss') double? stopLoss,
    @JsonKey(name: 'take_profit') double? takeProfit,
    @JsonKey(name: 'lot_size') double? lotSize,
    @Default(0.0) double confidence,
    @Default('') String reason,
    @JsonKey(name: 'timeframe_scores') @Default({}) Map<String, double> timeframeScores,
    @RegimeConverter() @Default(Regime.unknown) Regime regime,
    @JsonKey(name: 'regime_confidence') @Default(0.0) double regimeConfidence,
    @JsonKey(name: 'strategy_confidence') @Default(0.0) double strategyConfidence,
    @DirectionConverter() @JsonKey(name: 'h4_bias') @Default(Direction.neutral) Direction h4Bias,
    @RegimeConverter() @JsonKey(name: 'h1_regime') @Default(Regime.unknown) Regime h1Regime,
    @JsonKey(name: 'sentiment_score') @Default(0.0) double sentimentScore,
    @JsonKey(name: 'risk_score') @Default(0.0) double riskScore,
    @JsonKey(name: 'bars_in_regime') @Default(0) int barsInRegime,
    @JsonKey(name: 'duration_warning') @Default(false) bool durationWarning,
    @JsonKey(name: 'is_valid') @Default(true) bool isValid,
    @JsonKey(name: 'expires_at') required DateTime expiresAt,
  }) = _BackendSignal;

  const BackendSignal._();

  factory BackendSignal.fromJson(Map<String, dynamic> json) => _$BackendSignalFromJson(json);

  bool get isExpired => expiresAt.isBefore(DateTime.now());
}
