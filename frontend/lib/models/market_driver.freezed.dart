// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'market_driver.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MarketDriver _$MarketDriverFromJson(Map<String, dynamic> json) {
  return _MarketDriver.fromJson(json);
}

/// @nodoc
mixin _$MarketDriver {
  String get summary => throw _privateConstructorUsedError;
  @JsonKey(name: 'top_currency')
  String get topCurrency => throw _privateConstructorUsedError;
  @ImpactLevelConverter()
  @JsonKey(name: 'impact_level')
  ImpactLevel get impactLevel => throw _privateConstructorUsedError;

  /// Serializes this MarketDriver to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MarketDriver
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MarketDriverCopyWith<MarketDriver> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MarketDriverCopyWith<$Res> {
  factory $MarketDriverCopyWith(
          MarketDriver value, $Res Function(MarketDriver) then) =
      _$MarketDriverCopyWithImpl<$Res, MarketDriver>;
  @useResult
  $Res call(
      {String summary,
      @JsonKey(name: 'top_currency') String topCurrency,
      @ImpactLevelConverter()
      @JsonKey(name: 'impact_level')
      ImpactLevel impactLevel});
}

/// @nodoc
class _$MarketDriverCopyWithImpl<$Res, $Val extends MarketDriver>
    implements $MarketDriverCopyWith<$Res> {
  _$MarketDriverCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MarketDriver
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? summary = null,
    Object? topCurrency = null,
    Object? impactLevel = null,
  }) {
    return _then(_value.copyWith(
      summary: null == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as String,
      topCurrency: null == topCurrency
          ? _value.topCurrency
          : topCurrency // ignore: cast_nullable_to_non_nullable
              as String,
      impactLevel: null == impactLevel
          ? _value.impactLevel
          : impactLevel // ignore: cast_nullable_to_non_nullable
              as ImpactLevel,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MarketDriverImplCopyWith<$Res>
    implements $MarketDriverCopyWith<$Res> {
  factory _$$MarketDriverImplCopyWith(
          _$MarketDriverImpl value, $Res Function(_$MarketDriverImpl) then) =
      __$$MarketDriverImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String summary,
      @JsonKey(name: 'top_currency') String topCurrency,
      @ImpactLevelConverter()
      @JsonKey(name: 'impact_level')
      ImpactLevel impactLevel});
}

/// @nodoc
class __$$MarketDriverImplCopyWithImpl<$Res>
    extends _$MarketDriverCopyWithImpl<$Res, _$MarketDriverImpl>
    implements _$$MarketDriverImplCopyWith<$Res> {
  __$$MarketDriverImplCopyWithImpl(
      _$MarketDriverImpl _value, $Res Function(_$MarketDriverImpl) _then)
      : super(_value, _then);

  /// Create a copy of MarketDriver
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? summary = null,
    Object? topCurrency = null,
    Object? impactLevel = null,
  }) {
    return _then(_$MarketDriverImpl(
      summary: null == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as String,
      topCurrency: null == topCurrency
          ? _value.topCurrency
          : topCurrency // ignore: cast_nullable_to_non_nullable
              as String,
      impactLevel: null == impactLevel
          ? _value.impactLevel
          : impactLevel // ignore: cast_nullable_to_non_nullable
              as ImpactLevel,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MarketDriverImpl implements _MarketDriver {
  const _$MarketDriverImpl(
      {required this.summary,
      @JsonKey(name: 'top_currency') required this.topCurrency,
      @ImpactLevelConverter()
      @JsonKey(name: 'impact_level')
      this.impactLevel = ImpactLevel.low});

  factory _$MarketDriverImpl.fromJson(Map<String, dynamic> json) =>
      _$$MarketDriverImplFromJson(json);

  @override
  final String summary;
  @override
  @JsonKey(name: 'top_currency')
  final String topCurrency;
  @override
  @ImpactLevelConverter()
  @JsonKey(name: 'impact_level')
  final ImpactLevel impactLevel;

  @override
  String toString() {
    return 'MarketDriver(summary: $summary, topCurrency: $topCurrency, impactLevel: $impactLevel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MarketDriverImpl &&
            (identical(other.summary, summary) || other.summary == summary) &&
            (identical(other.topCurrency, topCurrency) ||
                other.topCurrency == topCurrency) &&
            (identical(other.impactLevel, impactLevel) ||
                other.impactLevel == impactLevel));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, summary, topCurrency, impactLevel);

  /// Create a copy of MarketDriver
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MarketDriverImplCopyWith<_$MarketDriverImpl> get copyWith =>
      __$$MarketDriverImplCopyWithImpl<_$MarketDriverImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MarketDriverImplToJson(
      this,
    );
  }
}

abstract class _MarketDriver implements MarketDriver {
  const factory _MarketDriver(
      {required final String summary,
      @JsonKey(name: 'top_currency') required final String topCurrency,
      @ImpactLevelConverter()
      @JsonKey(name: 'impact_level')
      final ImpactLevel impactLevel}) = _$MarketDriverImpl;

  factory _MarketDriver.fromJson(Map<String, dynamic> json) =
      _$MarketDriverImpl.fromJson;

  @override
  String get summary;
  @override
  @JsonKey(name: 'top_currency')
  String get topCurrency;
  @override
  @ImpactLevelConverter()
  @JsonKey(name: 'impact_level')
  ImpactLevel get impactLevel;

  /// Create a copy of MarketDriver
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MarketDriverImplCopyWith<_$MarketDriverImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
