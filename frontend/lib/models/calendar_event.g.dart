// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CalendarEventImpl _$$CalendarEventImplFromJson(Map<String, dynamic> json) =>
    _$CalendarEventImpl(
      eventId: json['event_id'] as String? ?? '',
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
      currency: json['currency'] as String? ?? 'Unknown',
      eventName: json['event_name'] as String? ?? 'Economic Event',
      impact: json['impact'] == null
          ? ImpactLevel.low
          : const ImpactLevelConverter().fromJson(json['impact']),
      forecast: json['forecast'] as String?,
      previous: json['previous'] as String?,
      actual: json['actual'] as String?,
      surprise: (json['surprise'] as num?)?.toDouble(),
      surpriseDirection:
          const DirectionConverter().fromJson(json['surprise_direction']),
    );

Map<String, dynamic> _$$CalendarEventImplToJson(_$CalendarEventImpl instance) =>
    <String, dynamic>{
      'event_id': instance.eventId,
      'timestamp': instance.timestamp?.toIso8601String(),
      'currency': instance.currency,
      'event_name': instance.eventName,
      'impact': const ImpactLevelConverter().toJson(instance.impact),
      'forecast': instance.forecast,
      'previous': instance.previous,
      'actual': instance.actual,
      'surprise': instance.surprise,
      'surprise_direction': _$JsonConverterToJson<dynamic, Direction>(
          instance.surpriseDirection, const DirectionConverter().toJson),
    };

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
