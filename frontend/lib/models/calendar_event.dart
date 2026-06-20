import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums.dart';
import 'converters.dart';

part 'calendar_event.freezed.dart';
part 'calendar_event.g.dart';

@freezed
class CalendarEvent with _$CalendarEvent {
  const factory CalendarEvent({
    @JsonKey(name: 'event_id') @Default('') String eventId,
    DateTime? timestamp,
    @Default('Unknown') String currency,
    @JsonKey(name: 'event_name') @Default('Economic Event') String eventName,
    @ImpactLevelConverter() @Default(ImpactLevel.low) ImpactLevel impact,
    String? forecast,
    String? previous,
    String? actual,
    double? surprise,
    @JsonKey(name: 'surprise_direction') @DirectionConverter() Direction? surpriseDirection,
  }) = _CalendarEvent;

  const CalendarEvent._();

  factory CalendarEvent.fromJson(Map<String, dynamic> json) => _$CalendarEventFromJson(json);

  int get minutesAway => timestamp?.difference(DateTime.now()).inMinutes ?? 0;
  bool get isPast => timestamp?.isBefore(DateTime.now()) ?? true;
}
