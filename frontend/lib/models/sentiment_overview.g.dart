// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sentiment_overview.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CurrencySentimentImpl _$$CurrencySentimentImplFromJson(
        Map<String, dynamic> json) =>
    _$CurrencySentimentImpl(
      currency: json['currency'] as String? ?? '',
      score4h: (json['score_4h'] as num?)?.toDouble() ?? 0.0,
      score24h: (json['score_24h'] as num?)?.toDouble() ?? 0.0,
      trend: json['trend'] as String? ?? 'stable',
    );

Map<String, dynamic> _$$CurrencySentimentImplToJson(
        _$CurrencySentimentImpl instance) =>
    <String, dynamic>{
      'currency': instance.currency,
      'score_4h': instance.score4h,
      'score_24h': instance.score24h,
      'trend': instance.trend,
    };

_$SentimentOverviewImpl _$$SentimentOverviewImplFromJson(
        Map<String, dynamic> json) =>
    _$SentimentOverviewImpl(
      currencies: (json['currencies'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
                k, CurrencySentiment.fromJson(e as Map<String, dynamic>)),
          ) ??
          const {},
      pairSentiment: (json['pair_sentiment'] as List<dynamic>?)
              ?.map(
                  (e) => PairSentimentScore.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$SentimentOverviewImplToJson(
        _$SentimentOverviewImpl instance) =>
    <String, dynamic>{
      'currencies': instance.currencies,
      'pair_sentiment': instance.pairSentiment,
    };

_$PairSentimentScoreImpl _$$PairSentimentScoreImplFromJson(
        Map<String, dynamic> json) =>
    _$PairSentimentScoreImpl(
      pair: json['pair'] as String? ?? '',
      score: (json['score'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$PairSentimentScoreImplToJson(
        _$PairSentimentScoreImpl instance) =>
    <String, dynamic>{
      'pair': instance.pair,
      'score': instance.score,
    };
