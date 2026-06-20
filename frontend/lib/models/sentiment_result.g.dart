// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sentiment_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SentimentResultImpl _$$SentimentResultImplFromJson(
        Map<String, dynamic> json) =>
    _$SentimentResultImpl(
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
      pair: json['pair'] == null
          ? CurrencyPair.unknown
          : const CurrencyPairConverter().fromJson(json['pair']),
      currencyScores: (json['currency_scores'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toDouble()),
          ) ??
          const {},
      pairScore: (json['pair_score'] as num?)?.toDouble() ?? 0.0,
      preNewsBlock: json['pre_news_block'] as bool? ?? false,
      hardBlock: json['hard_block'] as bool? ?? false,
      postNewsWindow: json['post_news_window'] as bool? ?? false,
      cotBias: json['cot_bias'] == null
          ? Direction.neutral
          : const DirectionConverter().fromJson(json['cot_bias']),
      topHeadlines: (json['top_headlines'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      sentimentTrend: json['sentiment_trend'] as String? ?? 'stable',
    );

Map<String, dynamic> _$$SentimentResultImplToJson(
        _$SentimentResultImpl instance) =>
    <String, dynamic>{
      'timestamp': instance.timestamp?.toIso8601String(),
      'pair': const CurrencyPairConverter().toJson(instance.pair),
      'currency_scores': instance.currencyScores,
      'pair_score': instance.pairScore,
      'pre_news_block': instance.preNewsBlock,
      'hard_block': instance.hardBlock,
      'post_news_window': instance.postNewsWindow,
      'cot_bias': const DirectionConverter().toJson(instance.cotBias),
      'top_headlines': instance.topHeadlines,
      'sentiment_trend': instance.sentimentTrend,
    };
