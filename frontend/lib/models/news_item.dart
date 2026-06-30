import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:forex_ai_frontend/theme/colors.dart';
import 'enums.dart';
import 'converters.dart';

part 'news_item.freezed.dart';
part 'news_item.g.dart';

@freezed
class NewsItem with _$NewsItem {
  const factory NewsItem({
    @JsonKey(name: 'article_uuid') @Default('') String articleUuid,
    DateTime? timestamp,
    @Default('Unknown') String source,
    @Default('No Headline') String headline,
    @Default('') String body,
    @JsonKey(name: 'sentiment_score') @Default(0.0) double sentimentScore,
    @ImpactLevelConverter() @Default(ImpactLevel.low) ImpactLevel impact,
    @JsonKey(name: 'currencies_mentioned') @Default([]) List<String> currenciesMentioned,
    @Default('') String url,
  }) = _NewsItem;

  const NewsItem._();

  factory NewsItem.fromJson(Map<String, dynamic> json) => _$NewsItemFromJson(json);

  String get sentimentLabel {
    if (sentimentScore > 0.3) return 'Bullish';
    if (sentimentScore < -0.3) return 'Bearish';
    return 'Neutral';
  }

  Color get sentimentColor {
    if (sentimentScore > 0.3) return AppColors.buyGreen;
    if (sentimentScore < -0.3) return AppColors.sellRed;
    return AppColors.textMuted;
  }
}
