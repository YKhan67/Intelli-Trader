import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums.dart';
import 'converters.dart';

part 'sentiment_result.freezed.dart';
part 'sentiment_result.g.dart';

@freezed
class SentimentResult with _$SentimentResult {
  const factory SentimentResult({
    required DateTime timestamp,
    @CurrencyPairConverter() required CurrencyPair pair,
    @JsonKey(name: 'currency_scores') required Map<String, double> currencyScores,
    @JsonKey(name: 'pair_score') required double pairScore,
    @JsonKey(name: 'pre_news_block') required bool preNewsBlock,
    @JsonKey(name: 'hard_block') required bool hardBlock,
    @JsonKey(name: 'post_news_window') required bool postNewsWindow,
    @JsonKey(name: 'cot_bias') @DirectionConverter() required Direction cotBias,
    @JsonKey(name: 'top_headlines') required List<String> topHeadlines,
    @JsonKey(name: 'sentiment_trend') required String sentimentTrend,
  }) = _SentimentResult;

  factory SentimentResult.fromJson(Map<String, dynamic> json) => _$SentimentResultFromJson(json);
}
