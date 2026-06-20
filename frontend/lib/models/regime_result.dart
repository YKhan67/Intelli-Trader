import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums.dart';
import 'converters.dart';

part 'regime_result.freezed.dart';
part 'regime_result.g.dart';

@freezed
class RegimeResult with _$RegimeResult {
  const factory RegimeResult({
    DateTime? timestamp,
    @CurrencyPairConverter() @Default(CurrencyPair.unknown) CurrencyPair pair,
    @TimeframeConverter() @Default(Timeframe.h1) Timeframe timeframe,
    @RegimeConverter() @Default(Regime.unknown) Regime regime,
    @Default(0.0) double confidence,
    @JsonKey(name: 'h4_bias') @DirectionConverter() @Default(Direction.neutral) Direction h4Bias,
    @JsonKey(name: 'h1_regime') @RegimeConverter() @Default(Regime.unknown) Regime h1Regime,
    @JsonKey(name: 'bars_in_regime') @Default(0) int barsInRegime,
    @JsonKey(name: 'regime_changed') @Default(false) bool regimeChanged,
    @JsonKey(name: 'duration_warning') @Default(false) bool durationWarning,
  }) = _RegimeResult;

  factory RegimeResult.fromJson(Map<String, dynamic> json) => _$RegimeResultFromJson(json);
}
