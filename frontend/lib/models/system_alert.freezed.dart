// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'system_alert.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SystemAlert _$SystemAlertFromJson(Map<String, dynamic> json) {
  return _SystemAlert.fromJson(json);
}

/// @nodoc
mixin _$SystemAlert {
  @JsonKey(name: 'alert_id')
  String get alertId => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  @JsonKey(name: 'alert_type')
  String get alertType => throw _privateConstructorUsedError;
  AlertSeverity get severity => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  CurrencyPair? get pair => throw _privateConstructorUsedError;
  @JsonKey(name: 'auto_resolved')
  bool get autoResolved => throw _privateConstructorUsedError;

  /// Serializes this SystemAlert to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SystemAlert
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SystemAlertCopyWith<SystemAlert> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SystemAlertCopyWith<$Res> {
  factory $SystemAlertCopyWith(
          SystemAlert value, $Res Function(SystemAlert) then) =
      _$SystemAlertCopyWithImpl<$Res, SystemAlert>;
  @useResult
  $Res call(
      {@JsonKey(name: 'alert_id') String alertId,
      DateTime timestamp,
      @JsonKey(name: 'alert_type') String alertType,
      AlertSeverity severity,
      String message,
      CurrencyPair? pair,
      @JsonKey(name: 'auto_resolved') bool autoResolved});
}

/// @nodoc
class _$SystemAlertCopyWithImpl<$Res, $Val extends SystemAlert>
    implements $SystemAlertCopyWith<$Res> {
  _$SystemAlertCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SystemAlert
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? alertId = null,
    Object? timestamp = null,
    Object? alertType = null,
    Object? severity = null,
    Object? message = null,
    Object? pair = freezed,
    Object? autoResolved = null,
  }) {
    return _then(_value.copyWith(
      alertId: null == alertId
          ? _value.alertId
          : alertId // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      alertType: null == alertType
          ? _value.alertType
          : alertType // ignore: cast_nullable_to_non_nullable
              as String,
      severity: null == severity
          ? _value.severity
          : severity // ignore: cast_nullable_to_non_nullable
              as AlertSeverity,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      pair: freezed == pair
          ? _value.pair
          : pair // ignore: cast_nullable_to_non_nullable
              as CurrencyPair?,
      autoResolved: null == autoResolved
          ? _value.autoResolved
          : autoResolved // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SystemAlertImplCopyWith<$Res>
    implements $SystemAlertCopyWith<$Res> {
  factory _$$SystemAlertImplCopyWith(
          _$SystemAlertImpl value, $Res Function(_$SystemAlertImpl) then) =
      __$$SystemAlertImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'alert_id') String alertId,
      DateTime timestamp,
      @JsonKey(name: 'alert_type') String alertType,
      AlertSeverity severity,
      String message,
      CurrencyPair? pair,
      @JsonKey(name: 'auto_resolved') bool autoResolved});
}

/// @nodoc
class __$$SystemAlertImplCopyWithImpl<$Res>
    extends _$SystemAlertCopyWithImpl<$Res, _$SystemAlertImpl>
    implements _$$SystemAlertImplCopyWith<$Res> {
  __$$SystemAlertImplCopyWithImpl(
      _$SystemAlertImpl _value, $Res Function(_$SystemAlertImpl) _then)
      : super(_value, _then);

  /// Create a copy of SystemAlert
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? alertId = null,
    Object? timestamp = null,
    Object? alertType = null,
    Object? severity = null,
    Object? message = null,
    Object? pair = freezed,
    Object? autoResolved = null,
  }) {
    return _then(_$SystemAlertImpl(
      alertId: null == alertId
          ? _value.alertId
          : alertId // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      alertType: null == alertType
          ? _value.alertType
          : alertType // ignore: cast_nullable_to_non_nullable
              as String,
      severity: null == severity
          ? _value.severity
          : severity // ignore: cast_nullable_to_non_nullable
              as AlertSeverity,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      pair: freezed == pair
          ? _value.pair
          : pair // ignore: cast_nullable_to_non_nullable
              as CurrencyPair?,
      autoResolved: null == autoResolved
          ? _value.autoResolved
          : autoResolved // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SystemAlertImpl implements _SystemAlert {
  const _$SystemAlertImpl(
      {@JsonKey(name: 'alert_id') required this.alertId,
      required this.timestamp,
      @JsonKey(name: 'alert_type') required this.alertType,
      required this.severity,
      required this.message,
      required this.pair,
      @JsonKey(name: 'auto_resolved') required this.autoResolved});

  factory _$SystemAlertImpl.fromJson(Map<String, dynamic> json) =>
      _$$SystemAlertImplFromJson(json);

  @override
  @JsonKey(name: 'alert_id')
  final String alertId;
  @override
  final DateTime timestamp;
  @override
  @JsonKey(name: 'alert_type')
  final String alertType;
  @override
  final AlertSeverity severity;
  @override
  final String message;
  @override
  final CurrencyPair? pair;
  @override
  @JsonKey(name: 'auto_resolved')
  final bool autoResolved;

  @override
  String toString() {
    return 'SystemAlert(alertId: $alertId, timestamp: $timestamp, alertType: $alertType, severity: $severity, message: $message, pair: $pair, autoResolved: $autoResolved)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SystemAlertImpl &&
            (identical(other.alertId, alertId) || other.alertId == alertId) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.alertType, alertType) ||
                other.alertType == alertType) &&
            (identical(other.severity, severity) ||
                other.severity == severity) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.pair, pair) || other.pair == pair) &&
            (identical(other.autoResolved, autoResolved) ||
                other.autoResolved == autoResolved));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, alertId, timestamp, alertType,
      severity, message, pair, autoResolved);

  /// Create a copy of SystemAlert
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SystemAlertImplCopyWith<_$SystemAlertImpl> get copyWith =>
      __$$SystemAlertImplCopyWithImpl<_$SystemAlertImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SystemAlertImplToJson(
      this,
    );
  }
}

abstract class _SystemAlert implements SystemAlert {
  const factory _SystemAlert(
          {@JsonKey(name: 'alert_id') required final String alertId,
          required final DateTime timestamp,
          @JsonKey(name: 'alert_type') required final String alertType,
          required final AlertSeverity severity,
          required final String message,
          required final CurrencyPair? pair,
          @JsonKey(name: 'auto_resolved') required final bool autoResolved}) =
      _$SystemAlertImpl;

  factory _SystemAlert.fromJson(Map<String, dynamic> json) =
      _$SystemAlertImpl.fromJson;

  @override
  @JsonKey(name: 'alert_id')
  String get alertId;
  @override
  DateTime get timestamp;
  @override
  @JsonKey(name: 'alert_type')
  String get alertType;
  @override
  AlertSeverity get severity;
  @override
  String get message;
  @override
  CurrencyPair? get pair;
  @override
  @JsonKey(name: 'auto_resolved')
  bool get autoResolved;

  /// Create a copy of SystemAlert
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SystemAlertImplCopyWith<_$SystemAlertImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
