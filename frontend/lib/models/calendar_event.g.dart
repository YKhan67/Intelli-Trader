// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CalendarEventImpl _$$CalendarEventImplFromJson(Map<String, dynamic> json) =>
    _$CalendarEventImpl(
      eventId: json['event_id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      currency: json['currency'] as String,
      eventName: json['event_name'] as String,
      impact: const ImpactLevelConverter().fromJson(json['impact'] as String),
      forecast: json['forecast'] as String?,
      previous: json['previous'] as String?,
      actual: json['actual'] as String?,
      surprise: (json['surprise'] as num?)?.toDouble(),
      surpriseDirection: _$JsonConverterFromJson<String, Direction>(
          json['surprise_direction'], const DirectionConverter().fromJson),
    );

Map<String, dynamic> _$$CalendarEventImplToJson(_$CalendarEventImpl instance) =>
    <String, dynamic>{
      'event_id': instance.eventId,
      'timestamp': instance.timestamp.toIso8601String(),
      'currency': instance.currency,
      'event_name': instance.eventName,
      'impact': const ImpactLevelConverter().toJson(instance.impact),
      'forecast': instance.forecast,
      'previous': instance.previous,
      'actual': instance.actual,
      'surprise': instance.surprise,
      'surprise_direction': _$JsonConverterToJson<String, Direction>(
          instance.surpriseDirection, const DirectionConverter().toJson),
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
