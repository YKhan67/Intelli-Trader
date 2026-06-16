// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sentiment_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SentimentResultImpl _$$SentimentResultImplFromJson(
        Map<String, dynamic> json) =>
    _$SentimentResultImpl(
      timestamp: DateTime.parse(json['timestamp'] as String),
      pair: const CurrencyPairConverter().fromJson(json['pair'] as String),
      currencyScores: (json['currency_scores'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      pairScore: (json['pair_score'] as num).toDouble(),
      preNewsBlock: json['pre_news_block'] as bool,
      hardBlock: json['hard_block'] as bool,
      postNewsWindow: json['post_news_window'] as bool,
      cotBias: const DirectionConverter().fromJson(json['cot_bias'] as String),
      topHeadlines: (json['top_headlines'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      sentimentTrend: json['sentiment_trend'] as String,
    );

Map<String, dynamic> _$$SentimentResultImplToJson(
        _$SentimentResultImpl instance) =>
    <String, dynamic>{
      'timestamp': instance.timestamp.toIso8601String(),
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
