import 'package:freezed_annotation/freezed_annotation.dart';

part 'sentiment_overview.freezed.dart';
part 'sentiment_overview.g.dart';

@freezed
class CurrencySentiment with _$CurrencySentiment {
  const factory CurrencySentiment({
    @Default('') String currency,
    @JsonKey(name: 'score_4h') @Default(0.0) double score4h,
    @JsonKey(name: 'score_24h') @Default(0.0) double score24h,
    @Default('stable') String trend,
  }) = _CurrencySentiment;

  factory CurrencySentiment.fromJson(Map<String, dynamic> json) => _$CurrencySentimentFromJson(json);
}

@freezed
class SentimentOverview with _$SentimentOverview {
  const factory SentimentOverview({
    @Default({}) Map<String, CurrencySentiment> currencies,
    @JsonKey(name: 'pair_sentiment') @Default([]) List<PairSentimentScore> pairSentiment,
  }) = _SentimentOverview;

  factory SentimentOverview.fromJson(Map<String, dynamic> json) => _$SentimentOverviewFromJson(json);
}

@freezed
class PairSentimentScore with _$PairSentimentScore {
  const factory PairSentimentScore({
    @Default('') String pair,
    @Default(0.0) double score,
  }) = _PairSentimentScore;

  factory PairSentimentScore.fromJson(Map<String, dynamic> json) => _$PairSentimentScoreFromJson(json);
}
