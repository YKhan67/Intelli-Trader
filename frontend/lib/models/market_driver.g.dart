// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'market_driver.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MarketDriverImpl _$$MarketDriverImplFromJson(Map<String, dynamic> json) =>
    _$MarketDriverImpl(
      summary: json['summary'] as String,
      topCurrency: json['top_currency'] as String,
      impactLevel: json['impact_level'] == null
          ? ImpactLevel.low
          : const ImpactLevelConverter().fromJson(json['impact_level']),
    );

Map<String, dynamic> _$$MarketDriverImplToJson(_$MarketDriverImpl instance) =>
    <String, dynamic>{
      'summary': instance.summary,
      'top_currency': instance.topCurrency,
      'impact_level': const ImpactLevelConverter().toJson(instance.impactLevel),
    };
