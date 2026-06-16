import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums.dart';
import 'converters.dart';

part 'regime_result.freezed.dart';
part 'regime_result.g.dart';

@freezed
class RegimeResult with _$RegimeResult {
  const factory RegimeResult({
    required DateTime timestamp,
    @CurrencyPairConverter() required CurrencyPair pair,
    @TimeframeConverter() required Timeframe timeframe,
    @RegimeConverter() required Regime regime,
    required double confidence,
    @JsonKey(name: 'h4_bias') @DirectionConverter() required Direction h4Bias,
    @JsonKey(name: 'h1_regime') @RegimeConverter() required Regime h1Regime,
    @JsonKey(name: 'bars_in_regime') required int barsInRegime,
    @JsonKey(name: 'regime_changed') required bool regimeChanged,
    @JsonKey(name: 'duration_warning') required bool durationWarning,
  }) = _RegimeResult;

  factory RegimeResult.fromJson(Map<String, dynamic> json) => _$RegimeResultFromJson(json);
}
