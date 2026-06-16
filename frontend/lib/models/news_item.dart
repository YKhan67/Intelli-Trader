import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:forex_ai_frontend/theme/colors.dart';

part 'news_item.freezed.dart';
part 'news_item.g.dart';

@freezed
class NewsItem with _$NewsItem {
  const factory NewsItem({
    @JsonKey(name: 'article_uuid') required String articleUuid,
    required DateTime timestamp,
    required String source,
    required String headline,
    required String body,
    @JsonKey(name: 'sentiment_score') required double sentimentScore,
    @JsonKey(name: 'currencies_mentioned') required List<String> currenciesMentioned,
  }) = _NewsItem;

  const NewsItem._();

  factory NewsItem.fromJson(Map<String, dynamic> json) => _$NewsItemFromJson(json);

  String get sentimentLabel {
    if (sentimentScore > 0.3) return 'Bullish';
    if (sentimentScore < -0.3) return 'Bearish';
    return 'Neutral';
  }

  Color get sentimentColor {
    if (sentimentScore > 0.3) return AppColors.buy;
    if (sentimentScore < -0.3) return AppColors.sell;
    return AppColors.hold;
  }
}
