import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums.dart';
import 'converters.dart';

part 'sentiment_result.freezed.dart';
part 'sentiment_result.g.dart';

@freezed
class SentimentResult with _$SentimentResult {
  const factory SentimentResult({
    DateTime? timestamp,
    @CurrencyPairConverter() @Default(CurrencyPair.unknown) CurrencyPair pair,
    @JsonKey(name: 'currency_scores') @Default({}) Map<String, double> currencyScores,
    @JsonKey(name: 'pair_score') @Default(0.0) double pairScore,
    @JsonKey(name: 'pre_news_block') @Default(false) bool preNewsBlock,
    @JsonKey(name: 'hard_block') @Default(false) bool hardBlock,
    @JsonKey(name: 'post_news_window') @Default(false) bool postNewsWindow,
    @JsonKey(name: 'cot_bias') @DirectionConverter() @Default(Direction.neutral) Direction cotBias,
    @JsonKey(name: 'top_headlines') @Default([]) List<String> topHeadlines,
    @JsonKey(name: 'sentiment_trend') @Default('stable') String sentimentTrend,
  }) = _SentimentResult;

  factory SentimentResult.fromJson(Map<String, dynamic> json) => _$SentimentResultFromJson(json);
}
