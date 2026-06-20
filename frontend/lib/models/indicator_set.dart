import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums.dart';
import 'converters.dart';

part 'indicator_set.freezed.dart';
part 'indicator_set.g.dart';

@freezed
class IndicatorSet with _$IndicatorSet {
  const factory IndicatorSet({
    @CurrencyPairConverter() @Default(CurrencyPair.unknown) CurrencyPair pair,
    @TimeframeConverter() @Default(Timeframe.h1) Timeframe timeframe,
    DateTime? timestamp,
    @JsonKey(name: 'ema_50') double? ema50,
    @JsonKey(name: 'ema_200') double? ema200,
    double? rsi,
    @JsonKey(name: 'macd_line') double? macdLine,
    @JsonKey(name: 'macd_signal') double? macdSignal,
    @JsonKey(name: 'macd_histogram') double? macdHistogram,
  }) = _IndicatorSet;

  factory IndicatorSet.fromJson(Map<String, dynamic> json) => _$IndicatorSetFromJson(json);
}
