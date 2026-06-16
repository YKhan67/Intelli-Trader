// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'smc_zone.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SMCZone _$SMCZoneFromJson(Map<String, dynamic> json) {
  return _SMCZone.fromJson(json);
}

/// @nodoc
mixin _$SMCZone {
  String get id => throw _privateConstructorUsedError;
  @CurrencyPairConverter()
  CurrencyPair get pair => throw _privateConstructorUsedError;
  @TimeframeConverter()
  Timeframe get timeframe => throw _privateConstructorUsedError;
  @JsonKey(name: 'zone_type')
  String get zoneType => throw _privateConstructorUsedError;
  @JsonKey(name: 'price_high')
  double get priceHigh => throw _privateConstructorUsedError;
  @JsonKey(name: 'price_low')
  double get priceLow => throw _privateConstructorUsedError;
  @JsonKey(name: 'formed_at')
  DateTime? get formedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_mitigated')
  bool get isMitigated => throw _privateConstructorUsedError;
  double get strength => throw _privateConstructorUsedError;

  /// Serializes this SMCZone to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SMCZone
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SMCZoneCopyWith<SMCZone> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SMCZoneCopyWith<$Res> {
  factory $SMCZoneCopyWith(SMCZone value, $Res Function(SMCZone) then) =
      _$SMCZoneCopyWithImpl<$Res, SMCZone>;
  @useResult
  $Res call(
      {String id,
      @CurrencyPairConverter() CurrencyPair pair,
      @TimeframeConverter() Timeframe timeframe,
      @JsonKey(name: 'zone_type') String zoneType,
      @JsonKey(name: 'price_high') double priceHigh,
      @JsonKey(name: 'price_low') double priceLow,
      @JsonKey(name: 'formed_at') DateTime? formedAt,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'is_mitigated') bool isMitigated,
      double strength});
}

/// @nodoc
class _$SMCZoneCopyWithImpl<$Res, $Val extends SMCZone>
    implements $SMCZoneCopyWith<$Res> {
  _$SMCZoneCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SMCZone
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? pair = null,
    Object? timeframe = null,
    Object? zoneType = null,
    Object? priceHigh = null,
    Object? priceLow = null,
    Object? formedAt = freezed,
    Object? isActive = null,
    Object? isMitigated = null,
    Object? strength = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      pair: null == pair
          ? _value.pair
          : pair // ignore: cast_nullable_to_non_nullable
              as CurrencyPair,
      timeframe: null == timeframe
          ? _value.timeframe
          : timeframe // ignore: cast_nullable_to_non_nullable
              as Timeframe,
      zoneType: null == zoneType
          ? _value.zoneType
          : zoneType // ignore: cast_nullable_to_non_nullable
              as String,
      priceHigh: null == priceHigh
          ? _value.priceHigh
          : priceHigh // ignore: cast_nullable_to_non_nullable
              as double,
      priceLow: null == priceLow
          ? _value.priceLow
          : priceLow // ignore: cast_nullable_to_non_nullable
              as double,
      formedAt: freezed == formedAt
          ? _value.formedAt
          : formedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isMitigated: null == isMitigated
          ? _value.isMitigated
          : isMitigated // ignore: cast_nullable_to_non_nullable
              as bool,
      strength: null == strength
          ? _value.strength
          : strength // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SMCZoneImplCopyWith<$Res> implements $SMCZoneCopyWith<$Res> {
  factory _$$SMCZoneImplCopyWith(
          _$SMCZoneImpl value, $Res Function(_$SMCZoneImpl) then) =
      __$$SMCZoneImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @CurrencyPairConverter() CurrencyPair pair,
      @TimeframeConverter() Timeframe timeframe,
      @JsonKey(name: 'zone_type') String zoneType,
      @JsonKey(name: 'price_high') double priceHigh,
      @JsonKey(name: 'price_low') double priceLow,
      @JsonKey(name: 'formed_at') DateTime? formedAt,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'is_mitigated') bool isMitigated,
      double strength});
}

/// @nodoc
class __$$SMCZoneImplCopyWithImpl<$Res>
    extends _$SMCZoneCopyWithImpl<$Res, _$SMCZoneImpl>
    implements _$$SMCZoneImplCopyWith<$Res> {
  __$$SMCZoneImplCopyWithImpl(
      _$SMCZoneImpl _value, $Res Function(_$SMCZoneImpl) _then)
      : super(_value, _then);

  /// Create a copy of SMCZone
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? pair = null,
    Object? timeframe = null,
    Object? zoneType = null,
    Object? priceHigh = null,
    Object? priceLow = null,
    Object? formedAt = freezed,
    Object? isActive = null,
    Object? isMitigated = null,
    Object? strength = null,
  }) {
    return _then(_$SMCZoneImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      pair: null == pair
          ? _value.pair
          : pair // ignore: cast_nullable_to_non_nullable
              as CurrencyPair,
      timeframe: null == timeframe
          ? _value.timeframe
          : timeframe // ignore: cast_nullable_to_non_nullable
              as Timeframe,
      zoneType: null == zoneType
          ? _value.zoneType
          : zoneType // ignore: cast_nullable_to_non_nullable
              as String,
      priceHigh: null == priceHigh
          ? _value.priceHigh
          : priceHigh // ignore: cast_nullable_to_non_nullable
              as double,
      priceLow: null == priceLow
          ? _value.priceLow
          : priceLow // ignore: cast_nullable_to_non_nullable
              as double,
      formedAt: freezed == formedAt
          ? _value.formedAt
          : formedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isMitigated: null == isMitigated
          ? _value.isMitigated
          : isMitigated // ignore: cast_nullable_to_non_nullable
              as bool,
      strength: null == strength
          ? _value.strength
          : strength // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SMCZoneImpl implements _SMCZone {
  const _$SMCZoneImpl(
      {required this.id,
      @CurrencyPairConverter() required this.pair,
      @TimeframeConverter() required this.timeframe,
      @JsonKey(name: 'zone_type') required this.zoneType,
      @JsonKey(name: 'price_high') required this.priceHigh,
      @JsonKey(name: 'price_low') required this.priceLow,
      @JsonKey(name: 'formed_at') this.formedAt,
      @JsonKey(name: 'is_active') this.isActive = true,
      @JsonKey(name: 'is_mitigated') this.isMitigated = false,
      this.strength = 0.0});

  factory _$SMCZoneImpl.fromJson(Map<String, dynamic> json) =>
      _$$SMCZoneImplFromJson(json);

  @override
  final String id;
  @override
  @CurrencyPairConverter()
  final CurrencyPair pair;
  @override
  @TimeframeConverter()
  final Timeframe timeframe;
  @override
  @JsonKey(name: 'zone_type')
  final String zoneType;
  @override
  @JsonKey(name: 'price_high')
  final double priceHigh;
  @override
  @JsonKey(name: 'price_low')
  final double priceLow;
  @override
  @JsonKey(name: 'formed_at')
  final DateTime? formedAt;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  @JsonKey(name: 'is_mitigated')
  final bool isMitigated;
  @override
  @JsonKey()
  final double strength;

  @override
  String toString() {
    return 'SMCZone(id: $id, pair: $pair, timeframe: $timeframe, zoneType: $zoneType, priceHigh: $priceHigh, priceLow: $priceLow, formedAt: $formedAt, isActive: $isActive, isMitigated: $isMitigated, strength: $strength)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SMCZoneImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.pair, pair) || other.pair == pair) &&
            (identical(other.timeframe, timeframe) ||
                other.timeframe == timeframe) &&
            (identical(other.zoneType, zoneType) ||
                other.zoneType == zoneType) &&
            (identical(other.priceHigh, priceHigh) ||
                other.priceHigh == priceHigh) &&
            (identical(other.priceLow, priceLow) ||
                other.priceLow == priceLow) &&
            (identical(other.formedAt, formedAt) ||
                other.formedAt == formedAt) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isMitigated, isMitigated) ||
                other.isMitigated == isMitigated) &&
            (identical(other.strength, strength) ||
                other.strength == strength));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, pair, timeframe, zoneType,
      priceHigh, priceLow, formedAt, isActive, isMitigated, strength);

  /// Create a copy of SMCZone
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SMCZoneImplCopyWith<_$SMCZoneImpl> get copyWith =>
      __$$SMCZoneImplCopyWithImpl<_$SMCZoneImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SMCZoneImplToJson(
      this,
    );
  }
}

abstract class _SMCZone implements SMCZone {
  const factory _SMCZone(
      {required final String id,
      @CurrencyPairConverter() required final CurrencyPair pair,
      @TimeframeConverter() required final Timeframe timeframe,
      @JsonKey(name: 'zone_type') required final String zoneType,
      @JsonKey(name: 'price_high') required final double priceHigh,
      @JsonKey(name: 'price_low') required final double priceLow,
      @JsonKey(name: 'formed_at') final DateTime? formedAt,
      @JsonKey(name: 'is_active') final bool isActive,
      @JsonKey(name: 'is_mitigated') final bool isMitigated,
      final double strength}) = _$SMCZoneImpl;

  factory _SMCZone.fromJson(Map<String, dynamic> json) = _$SMCZoneImpl.fromJson;

  @override
  String get id;
  @override
  @CurrencyPairConverter()
  CurrencyPair get pair;
  @override
  @TimeframeConverter()
  Timeframe get timeframe;
  @override
  @JsonKey(name: 'zone_type')
  String get zoneType;
  @override
  @JsonKey(name: 'price_high')
  double get priceHigh;
  @override
  @JsonKey(name: 'price_low')
  double get priceLow;
  @override
  @JsonKey(name: 'formed_at')
  DateTime? get formedAt;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'is_mitigated')
  bool get isMitigated;
  @override
  double get strength;

  /// Create a copy of SMCZone
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SMCZoneImplCopyWith<_$SMCZoneImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
