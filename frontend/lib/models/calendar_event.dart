import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums.dart';
import 'converters.dart';

part 'calendar_event.freezed.dart';
part 'calendar_event.g.dart';

@freezed
class CalendarEvent with _$CalendarEvent {
  const factory CalendarEvent({
    @JsonKey(name: 'event_id') required String eventId,
    required DateTime timestamp,
    required String currency,
    @JsonKey(name: 'event_name') required String eventName,
    @ImpactLevelConverter() required ImpactLevel impact,
    String? forecast,
    String? previous,
    String? actual,
    double? surprise,
    @JsonKey(name: 'surprise_direction') @DirectionConverter() Direction? surpriseDirection,
  }) = _CalendarEvent;

  const CalendarEvent._();

  factory CalendarEvent.fromJson(Map<String, dynamic> json) => _$CalendarEventFromJson(json);

  int get minutesAway => timestamp.difference(DateTime.now()).inMinutes;
  bool get isPast => timestamp.isBefore(DateTime.now());
}
