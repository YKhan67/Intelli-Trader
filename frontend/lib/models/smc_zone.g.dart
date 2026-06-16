// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'smc_zone.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SMCZoneImpl _$$SMCZoneImplFromJson(Map<String, dynamic> json) =>
    _$SMCZoneImpl(
      id: json['id'] as String,
      pair: const CurrencyPairConverter().fromJson(json['pair'] as String),
      timeframe:
          const TimeframeConverter().fromJson(json['timeframe'] as String),
      zoneType: json['zone_type'] as String,
      priceHigh: (json['price_high'] as num).toDouble(),
      priceLow: (json['price_low'] as num).toDouble(),
      formedAt: json['formed_at'] == null
          ? null
          : DateTime.parse(json['formed_at'] as String),
      isActive: json['is_active'] as bool? ?? true,
      isMitigated: json['is_mitigated'] as bool? ?? false,
      strength: (json['strength'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$SMCZoneImplToJson(_$SMCZoneImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'pair': const CurrencyPairConverter().toJson(instance.pair),
      'timeframe': const TimeframeConverter().toJson(instance.timeframe),
      'zone_type': instance.zoneType,
      'price_high': instance.priceHigh,
      'price_low': instance.priceLow,
      'formed_at': instance.formedAt?.toIso8601String(),
      'is_active': instance.isActive,
      'is_mitigated': instance.isMitigated,
      'strength': instance.strength,
    };
