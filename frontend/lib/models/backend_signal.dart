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
    @JsonKey(name: 'entry_price') required double entryPrice,
    @JsonKey(name: 'stop_loss') required double stopLoss,
    @JsonKey(name: 'take_profit') required double takeProfit,
    @JsonKey(name: 'lot_size') required double lotSize,
    required double confidence,
    required String reason,
    @JsonKey(name: 'timeframe_scores') @Default({}) Map<String, double> timeframeScores,
    @RegimeConverter() required Regime regime,
    @JsonKey(name: 'regime_confidence') required double regimeConfidence,
    @JsonKey(name: 'sentiment_score') required double sentimentScore,
    @JsonKey(name: 'risk_score') required double riskScore,
    @JsonKey(name: 'bars_in_regime') @Default(0) int barsInRegime,
    @JsonKey(name: 'duration_warning') @Default(false) bool durationWarning,
    @JsonKey(name: 'is_valid') required bool isValid,
    @JsonKey(name: 'expires_at') required DateTime expiresAt,
  }) = _BackendSignal;

  const BackendSignal._();

  factory BackendSignal.fromJson(Map<String, dynamic> json) => _$BackendSignalFromJson(json);

  bool get isExpired => expiresAt.isBefore(DateTime.now());
}
