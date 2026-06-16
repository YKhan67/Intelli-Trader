// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AccountInfo _$AccountInfoFromJson(Map<String, dynamic> json) {
  return _AccountInfo.fromJson(json);
}

/// @nodoc
mixin _$AccountInfo {
  double get balance => throw _privateConstructorUsedError;
  double get equity => throw _privateConstructorUsedError;
  double get margin => throw _privateConstructorUsedError;
  @JsonKey(name: 'free_margin')
  double get freeMargin => throw _privateConstructorUsedError;
  @JsonKey(name: 'margin_level')
  double get marginLevel => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  @JsonKey(name: 'broker_name')
  String get brokerName => throw _privateConstructorUsedError;
  @JsonKey(name: 'account_number')
  String get accountNumber => throw _privateConstructorUsedError;
  double get leverage => throw _privateConstructorUsedError;

  /// Serializes this AccountInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AccountInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AccountInfoCopyWith<AccountInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccountInfoCopyWith<$Res> {
  factory $AccountInfoCopyWith(
          AccountInfo value, $Res Function(AccountInfo) then) =
      _$AccountInfoCopyWithImpl<$Res, AccountInfo>;
  @useResult
  $Res call(
      {double balance,
      double equity,
      double margin,
      @JsonKey(name: 'free_margin') double freeMargin,
      @JsonKey(name: 'margin_level') double marginLevel,
      String currency,
      @JsonKey(name: 'broker_name') String brokerName,
      @JsonKey(name: 'account_number') String accountNumber,
      double leverage});
}

/// @nodoc
class _$AccountInfoCopyWithImpl<$Res, $Val extends AccountInfo>
    implements $AccountInfoCopyWith<$Res> {
  _$AccountInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AccountInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? balance = null,
    Object? equity = null,
    Object? margin = null,
    Object? freeMargin = null,
    Object? marginLevel = null,
    Object? currency = null,
    Object? brokerName = null,
    Object? accountNumber = null,
    Object? leverage = null,
  }) {
    return _then(_value.copyWith(
      balance: null == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as double,
      equity: null == equity
          ? _value.equity
          : equity // ignore: cast_nullable_to_non_nullable
              as double,
      margin: null == margin
          ? _value.margin
          : margin // ignore: cast_nullable_to_non_nullable
              as double,
      freeMargin: null == freeMargin
          ? _value.freeMargin
          : freeMargin // ignore: cast_nullable_to_non_nullable
              as double,
      marginLevel: null == marginLevel
          ? _value.marginLevel
          : marginLevel // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      brokerName: null == brokerName
          ? _value.brokerName
          : brokerName // ignore: cast_nullable_to_non_nullable
              as String,
      accountNumber: null == accountNumber
          ? _value.accountNumber
          : accountNumber // ignore: cast_nullable_to_non_nullable
              as String,
      leverage: null == leverage
          ? _value.leverage
          : leverage // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AccountInfoImplCopyWith<$Res>
    implements $AccountInfoCopyWith<$Res> {
  factory _$$AccountInfoImplCopyWith(
          _$AccountInfoImpl value, $Res Function(_$AccountInfoImpl) then) =
      __$$AccountInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double balance,
      double equity,
      double margin,
      @JsonKey(name: 'free_margin') double freeMargin,
      @JsonKey(name: 'margin_level') double marginLevel,
      String currency,
      @JsonKey(name: 'broker_name') String brokerName,
      @JsonKey(name: 'account_number') String accountNumber,
      double leverage});
}

/// @nodoc
class __$$AccountInfoImplCopyWithImpl<$Res>
    extends _$AccountInfoCopyWithImpl<$Res, _$AccountInfoImpl>
    implements _$$AccountInfoImplCopyWith<$Res> {
  __$$AccountInfoImplCopyWithImpl(
      _$AccountInfoImpl _value, $Res Function(_$AccountInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of AccountInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? balance = null,
    Object? equity = null,
    Object? margin = null,
    Object? freeMargin = null,
    Object? marginLevel = null,
    Object? currency = null,
    Object? brokerName = null,
    Object? accountNumber = null,
    Object? leverage = null,
  }) {
    return _then(_$AccountInfoImpl(
      balance: null == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as double,
      equity: null == equity
          ? _value.equity
          : equity // ignore: cast_nullable_to_non_nullable
              as double,
      margin: null == margin
          ? _value.margin
          : margin // ignore: cast_nullable_to_non_nullable
              as double,
      freeMargin: null == freeMargin
          ? _value.freeMargin
          : freeMargin // ignore: cast_nullable_to_non_nullable
              as double,
      marginLevel: null == marginLevel
          ? _value.marginLevel
          : marginLevel // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      brokerName: null == brokerName
          ? _value.brokerName
          : brokerName // ignore: cast_nullable_to_non_nullable
              as String,
      accountNumber: null == accountNumber
          ? _value.accountNumber
          : accountNumber // ignore: cast_nullable_to_non_nullable
              as String,
      leverage: null == leverage
          ? _value.leverage
          : leverage // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AccountInfoImpl implements _AccountInfo {
  const _$AccountInfoImpl(
      {required this.balance,
      required this.equity,
      required this.margin,
      @JsonKey(name: 'free_margin') required this.freeMargin,
      @JsonKey(name: 'margin_level') required this.marginLevel,
      required this.currency,
      @JsonKey(name: 'broker_name') required this.brokerName,
      @JsonKey(name: 'account_number') required this.accountNumber,
      required this.leverage});

  factory _$AccountInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$AccountInfoImplFromJson(json);

  @override
  final double balance;
  @override
  final double equity;
  @override
  final double margin;
  @override
  @JsonKey(name: 'free_margin')
  final double freeMargin;
  @override
  @JsonKey(name: 'margin_level')
  final double marginLevel;
  @override
  final String currency;
  @override
  @JsonKey(name: 'broker_name')
  final String brokerName;
  @override
  @JsonKey(name: 'account_number')
  final String accountNumber;
  @override
  final double leverage;

  @override
  String toString() {
    return 'AccountInfo(balance: $balance, equity: $equity, margin: $margin, freeMargin: $freeMargin, marginLevel: $marginLevel, currency: $currency, brokerName: $brokerName, accountNumber: $accountNumber, leverage: $leverage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AccountInfoImpl &&
            (identical(other.balance, balance) || other.balance == balance) &&
            (identical(other.equity, equity) || other.equity == equity) &&
            (identical(other.margin, margin) || other.margin == margin) &&
            (identical(other.freeMargin, freeMargin) ||
                other.freeMargin == freeMargin) &&
            (identical(other.marginLevel, marginLevel) ||
                other.marginLevel == marginLevel) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.brokerName, brokerName) ||
                other.brokerName == brokerName) &&
            (identical(other.accountNumber, accountNumber) ||
                other.accountNumber == accountNumber) &&
            (identical(other.leverage, leverage) ||
                other.leverage == leverage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, balance, equity, margin,
      freeMargin, marginLevel, currency, brokerName, accountNumber, leverage);

  /// Create a copy of AccountInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AccountInfoImplCopyWith<_$AccountInfoImpl> get copyWith =>
      __$$AccountInfoImplCopyWithImpl<_$AccountInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AccountInfoImplToJson(
      this,
    );
  }
}

abstract class _AccountInfo implements AccountInfo {
  const factory _AccountInfo(
      {required final double balance,
      required final double equity,
      required final double margin,
      @JsonKey(name: 'free_margin') required final double freeMargin,
      @JsonKey(name: 'margin_level') required final double marginLevel,
      required final String currency,
      @JsonKey(name: 'broker_name') required final String brokerName,
      @JsonKey(name: 'account_number') required final String accountNumber,
      required final double leverage}) = _$AccountInfoImpl;

  factory _AccountInfo.fromJson(Map<String, dynamic> json) =
      _$AccountInfoImpl.fromJson;

  @override
  double get balance;
  @override
  double get equity;
  @override
  double get margin;
  @override
  @JsonKey(name: 'free_margin')
  double get freeMargin;
  @override
  @JsonKey(name: 'margin_level')
  double get marginLevel;
  @override
  String get currency;
  @override
  @JsonKey(name: 'broker_name')
  String get brokerName;
  @override
  @JsonKey(name: 'account_number')
  String get accountNumber;
  @override
  double get leverage;

  /// Create a copy of AccountInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AccountInfoImplCopyWith<_$AccountInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
