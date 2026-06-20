// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cot_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

COTData _$COTDataFromJson(Map<String, dynamic> json) {
  return _COTData.fromJson(json);
}

/// @nodoc
mixin _$COTData {
  int get net => throw _privateConstructorUsedError;
  @DirectionConverter()
  Direction get bias => throw _privateConstructorUsedError;
  double get strength => throw _privateConstructorUsedError;

  /// Serializes this COTData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of COTData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $COTDataCopyWith<COTData> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $COTDataCopyWith<$Res> {
  factory $COTDataCopyWith(COTData value, $Res Function(COTData) then) =
      _$COTDataCopyWithImpl<$Res, COTData>;
  @useResult
  $Res call({int net, @DirectionConverter() Direction bias, double strength});
}

/// @nodoc
class _$COTDataCopyWithImpl<$Res, $Val extends COTData>
    implements $COTDataCopyWith<$Res> {
  _$COTDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of COTData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? net = null,
    Object? bias = null,
    Object? strength = null,
  }) {
    return _then(_value.copyWith(
      net: null == net
          ? _value.net
          : net // ignore: cast_nullable_to_non_nullable
              as int,
      bias: null == bias
          ? _value.bias
          : bias // ignore: cast_nullable_to_non_nullable
              as Direction,
      strength: null == strength
          ? _value.strength
          : strength // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$COTDataImplCopyWith<$Res> implements $COTDataCopyWith<$Res> {
  factory _$$COTDataImplCopyWith(
          _$COTDataImpl value, $Res Function(_$COTDataImpl) then) =
      __$$COTDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int net, @DirectionConverter() Direction bias, double strength});
}

/// @nodoc
class __$$COTDataImplCopyWithImpl<$Res>
    extends _$COTDataCopyWithImpl<$Res, _$COTDataImpl>
    implements _$$COTDataImplCopyWith<$Res> {
  __$$COTDataImplCopyWithImpl(
      _$COTDataImpl _value, $Res Function(_$COTDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of COTData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? net = null,
    Object? bias = null,
    Object? strength = null,
  }) {
    return _then(_$COTDataImpl(
      net: null == net
          ? _value.net
          : net // ignore: cast_nullable_to_non_nullable
              as int,
      bias: null == bias
          ? _value.bias
          : bias // ignore: cast_nullable_to_non_nullable
              as Direction,
      strength: null == strength
          ? _value.strength
          : strength // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$COTDataImpl implements _COTData {
  const _$COTDataImpl(
      {required this.net,
      @DirectionConverter() required this.bias,
      required this.strength});

  factory _$COTDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$COTDataImplFromJson(json);

  @override
  final int net;
  @override
  @DirectionConverter()
  final Direction bias;
  @override
  final double strength;

  @override
  String toString() {
    return 'COTData(net: $net, bias: $bias, strength: $strength)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$COTDataImpl &&
            (identical(other.net, net) || other.net == net) &&
            (identical(other.bias, bias) || other.bias == bias) &&
            (identical(other.strength, strength) ||
                other.strength == strength));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, net, bias, strength);

  /// Create a copy of COTData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$COTDataImplCopyWith<_$COTDataImpl> get copyWith =>
      __$$COTDataImplCopyWithImpl<_$COTDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$COTDataImplToJson(
      this,
    );
  }
}

abstract class _COTData implements COTData {
  const factory _COTData(
      {required final int net,
      @DirectionConverter() required final Direction bias,
      required final double strength}) = _$COTDataImpl;

  factory _COTData.fromJson(Map<String, dynamic> json) = _$COTDataImpl.fromJson;

  @override
  int get net;
  @override
  @DirectionConverter()
  Direction get bias;
  @override
  double get strength;

  /// Create a copy of COTData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$COTDataImplCopyWith<_$COTDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
