// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NewsItemImpl _$$NewsItemImplFromJson(Map<String, dynamic> json) =>
    _$NewsItemImpl(
      articleUuid: json['article_uuid'] as String? ?? '',
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
      source: json['source'] as String? ?? 'Unknown',
      headline: json['headline'] as String? ?? 'No Headline',
      body: json['body'] as String? ?? '',
      sentimentScore: (json['sentiment_score'] as num?)?.toDouble() ?? 0.0,
      currenciesMentioned: (json['currencies_mentioned'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      url: json['url'] as String? ?? '',
    );

Map<String, dynamic> _$$NewsItemImplToJson(_$NewsItemImpl instance) =>
    <String, dynamic>{
      'article_uuid': instance.articleUuid,
      'timestamp': instance.timestamp?.toIso8601String(),
      'source': instance.source,
      'headline': instance.headline,
      'body': instance.body,
      'sentiment_score': instance.sentimentScore,
      'currencies_mentioned': instance.currenciesMentioned,
      'url': instance.url,
    };
