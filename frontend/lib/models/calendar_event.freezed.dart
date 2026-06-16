// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'calendar_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CalendarEvent _$CalendarEventFromJson(Map<String, dynamic> json) {
  return _CalendarEvent.fromJson(json);
}

/// @nodoc
mixin _$CalendarEvent {
  @JsonKey(name: 'event_id')
  String get eventId => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  @JsonKey(name: 'event_name')
  String get eventName => throw _privateConstructorUsedError;
  @ImpactLevelConverter()
  ImpactLevel get impact => throw _privateConstructorUsedError;
  String? get forecast => throw _privateConstructorUsedError;
  String? get previous => throw _privateConstructorUsedError;
  String? get actual => throw _privateConstructorUsedError;
  double? get surprise => throw _privateConstructorUsedError;
  @JsonKey(name: 'surprise_direction')
  @DirectionConverter()
  Direction? get surpriseDirection => throw _privateConstructorUsedError;

  /// Serializes this CalendarEvent to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CalendarEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CalendarEventCopyWith<CalendarEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CalendarEventCopyWith<$Res> {
  factory $CalendarEventCopyWith(
          CalendarEvent value, $Res Function(CalendarEvent) then) =
      _$CalendarEventCopyWithImpl<$Res, CalendarEvent>;
  @useResult
  $Res call(
      {@JsonKey(name: 'event_id') String eventId,
      DateTime timestamp,
      String currency,
      @JsonKey(name: 'event_name') String eventName,
      @ImpactLevelConverter() ImpactLevel impact,
      String? forecast,
      String? previous,
      String? actual,
      double? surprise,
      @JsonKey(name: 'surprise_direction')
      @DirectionConverter()
      Direction? surpriseDirection});
}

/// @nodoc
class _$CalendarEventCopyWithImpl<$Res, $Val extends CalendarEvent>
    implements $CalendarEventCopyWith<$Res> {
  _$CalendarEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CalendarEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? eventId = null,
    Object? timestamp = null,
    Object? currency = null,
    Object? eventName = null,
    Object? impact = null,
    Object? forecast = freezed,
    Object? previous = freezed,
    Object? actual = freezed,
    Object? surprise = freezed,
    Object? surpriseDirection = freezed,
  }) {
    return _then(_value.copyWith(
      eventId: null == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      eventName: null == eventName
          ? _value.eventName
          : eventName // ignore: cast_nullable_to_non_nullable
              as String,
      impact: null == impact
          ? _value.impact
          : impact // ignore: cast_nullable_to_non_nullable
              as ImpactLevel,
      forecast: freezed == forecast
          ? _value.forecast
          : forecast // ignore: cast_nullable_to_non_nullable
              as String?,
      previous: freezed == previous
          ? _value.previous
          : previous // ignore: cast_nullable_to_non_nullable
              as String?,
      actual: freezed == actual
          ? _value.actual
          : actual // ignore: cast_nullable_to_non_nullable
              as String?,
      surprise: freezed == surprise
          ? _value.surprise
          : surprise // ignore: cast_nullable_to_non_nullable
              as double?,
      surpriseDirection: freezed == surpriseDirection
          ? _value.surpriseDirection
          : surpriseDirection // ignore: cast_nullable_to_non_nullable
              as Direction?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CalendarEventImplCopyWith<$Res>
    implements $CalendarEventCopyWith<$Res> {
  factory _$$CalendarEventImplCopyWith(
          _$CalendarEventImpl value, $Res Function(_$CalendarEventImpl) then) =
      __$$CalendarEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'event_id') String eventId,
      DateTime timestamp,
      String currency,
      @JsonKey(name: 'event_name') String eventName,
      @ImpactLevelConverter() ImpactLevel impact,
      String? forecast,
      String? previous,
      String? actual,
      double? surprise,
      @JsonKey(name: 'surprise_direction')
      @DirectionConverter()
      Direction? surpriseDirection});
}

/// @nodoc
class __$$CalendarEventImplCopyWithImpl<$Res>
    extends _$CalendarEventCopyWithImpl<$Res, _$CalendarEventImpl>
    implements _$$CalendarEventImplCopyWith<$Res> {
  __$$CalendarEventImplCopyWithImpl(
      _$CalendarEventImpl _value, $Res Function(_$CalendarEventImpl) _then)
      : super(_value, _then);

  /// Create a copy of CalendarEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? eventId = null,
    Object? timestamp = null,
    Object? currency = null,
    Object? eventName = null,
    Object? impact = null,
    Object? forecast = freezed,
    Object? previous = freezed,
    Object? actual = freezed,
    Object? surprise = freezed,
    Object? surpriseDirection = freezed,
  }) {
    return _then(_$CalendarEventImpl(
      eventId: null == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      eventName: null == eventName
          ? _value.eventName
          : eventName // ignore: cast_nullable_to_non_nullable
              as String,
      impact: null == impact
          ? _value.impact
          : impact // ignore: cast_nullable_to_non_nullable
              as ImpactLevel,
      forecast: freezed == forecast
          ? _value.forecast
          : forecast // ignore: cast_nullable_to_non_nullable
              as String?,
      previous: freezed == previous
          ? _value.previous
          : previous // ignore: cast_nullable_to_non_nullable
              as String?,
      actual: freezed == actual
          ? _value.actual
          : actual // ignore: cast_nullable_to_non_nullable
              as String?,
      surprise: freezed == surprise
          ? _value.surprise
          : surprise // ignore: cast_nullable_to_non_nullable
              as double?,
      surpriseDirection: freezed == surpriseDirection
          ? _value.surpriseDirection
          : surpriseDirection // ignore: cast_nullable_to_non_nullable
              as Direction?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CalendarEventImpl extends _CalendarEvent {
  const _$CalendarEventImpl(
      {@JsonKey(name: 'event_id') required this.eventId,
      required this.timestamp,
      required this.currency,
      @JsonKey(name: 'event_name') required this.eventName,
      @ImpactLevelConverter() required this.impact,
      this.forecast,
      this.previous,
      this.actual,
      this.surprise,
      @JsonKey(name: 'surprise_direction')
      @DirectionConverter()
      this.surpriseDirection})
      : super._();

  factory _$CalendarEventImpl.fromJson(Map<String, dynamic> json) =>
      _$$CalendarEventImplFromJson(json);

  @override
  @JsonKey(name: 'event_id')
  final String eventId;
  @override
  final DateTime timestamp;
  @override
  final String currency;
  @override
  @JsonKey(name: 'event_name')
  final String eventName;
  @override
  @ImpactLevelConverter()
  final ImpactLevel impact;
  @override
  final String? forecast;
  @override
  final String? previous;
  @override
  final String? actual;
  @override
  final double? surprise;
  @override
  @JsonKey(name: 'surprise_direction')
  @DirectionConverter()
  final Direction? surpriseDirection;

  @override
  String toString() {
    return 'CalendarEvent(eventId: $eventId, timestamp: $timestamp, currency: $currency, eventName: $eventName, impact: $impact, forecast: $forecast, previous: $previous, actual: $actual, surprise: $surprise, surpriseDirection: $surpriseDirection)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CalendarEventImpl &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.eventName, eventName) ||
                other.eventName == eventName) &&
            (identical(other.impact, impact) || other.impact == impact) &&
            (identical(other.forecast, forecast) ||
                other.forecast == forecast) &&
            (identical(other.previous, previous) ||
                other.previous == previous) &&
            (identical(other.actual, actual) || other.actual == actual) &&
            (identical(other.surprise, surprise) ||
                other.surprise == surprise) &&
            (identical(other.surpriseDirection, surpriseDirection) ||
                other.surpriseDirection == surpriseDirection));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      eventId,
      timestamp,
      currency,
      eventName,
      impact,
      forecast,
      previous,
      actual,
      surprise,
      surpriseDirection);

  /// Create a copy of CalendarEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CalendarEventImplCopyWith<_$CalendarEventImpl> get copyWith =>
      __$$CalendarEventImplCopyWithImpl<_$CalendarEventImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CalendarEventImplToJson(
      this,
    );
  }
}

abstract class _CalendarEvent extends CalendarEvent {
  const factory _CalendarEvent(
      {@JsonKey(name: 'event_id') required final String eventId,
      required final DateTime timestamp,
      required final String currency,
      @JsonKey(name: 'event_name') required final String eventName,
      @ImpactLevelConverter() required final ImpactLevel impact,
      final String? forecast,
      final String? previous,
      final String? actual,
      final double? surprise,
      @JsonKey(name: 'surprise_direction')
      @DirectionConverter()
      final Direction? surpriseDirection}) = _$CalendarEventImpl;
  const _CalendarEvent._() : super._();

  factory _CalendarEvent.fromJson(Map<String, dynamic> json) =
      _$CalendarEventImpl.fromJson;

  @override
  @JsonKey(name: 'event_id')
  String get eventId;
  @override
  DateTime get timestamp;
  @override
  String get currency;
  @override
  @JsonKey(name: 'event_name')
  String get eventName;
  @override
  @ImpactLevelConverter()
  ImpactLevel get impact;
  @override
  String? get forecast;
  @override
  String? get previous;
  @override
  String? get actual;
  @override
  double? get surprise;
  @override
  @JsonKey(name: 'surprise_direction')
  @DirectionConverter()
  Direction? get surpriseDirection;

  /// Create a copy of CalendarEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CalendarEventImplCopyWith<_$CalendarEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
