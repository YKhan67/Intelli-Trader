// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'risk_params.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RiskParams _$RiskParamsFromJson(Map<String, dynamic> json) {
  return _RiskParams.fromJson(json);
}

/// @nodoc
mixin _$RiskParams {
  @JsonKey(name: 'lot_size')
  double get lotSize => throw _privateConstructorUsedError;
  @JsonKey(name: 'stop_loss_pips')
  double get stopLossPips => throw _privateConstructorUsedError;
  @JsonKey(name: 'take_profit_pips')
  double get takeProfitPips => throw _privateConstructorUsedError;
  @JsonKey(name: 'stop_loss_price')
  double get stopLossPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'take_profit_price')
  double get takeProfitPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'partial_close_price')
  double? get partialClosePrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'breakeven_price')
  double? get breakevenPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'risk_percent')
  double get riskPercent => throw _privateConstructorUsedError;
  @JsonKey(name: 'rr_ratio')
  double get rrRatio => throw _privateConstructorUsedError;
  @JsonKey(name: 'daily_halt')
  bool get dailyHalt => throw _privateConstructorUsedError;
  @JsonKey(name: 'hard_daily_halt')
  bool get hardDailyHalt => throw _privateConstructorUsedError;
  @JsonKey(name: 'weekly_review')
  bool get weeklyReview => throw _privateConstructorUsedError;
  @JsonKey(name: 'correlated_exposure')
  bool get correlatedExposure => throw _privateConstructorUsedError;
  @JsonKey(name: 'risk_score')
  double get riskScore => throw _privateConstructorUsedError;

  /// Serializes this RiskParams to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RiskParams
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RiskParamsCopyWith<RiskParams> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RiskParamsCopyWith<$Res> {
  factory $RiskParamsCopyWith(
          RiskParams value, $Res Function(RiskParams) then) =
      _$RiskParamsCopyWithImpl<$Res, RiskParams>;
  @useResult
  $Res call(
      {@JsonKey(name: 'lot_size') double lotSize,
      @JsonKey(name: 'stop_loss_pips') double stopLossPips,
      @JsonKey(name: 'take_profit_pips') double takeProfitPips,
      @JsonKey(name: 'stop_loss_price') double stopLossPrice,
      @JsonKey(name: 'take_profit_price') double takeProfitPrice,
      @JsonKey(name: 'partial_close_price') double? partialClosePrice,
      @JsonKey(name: 'breakeven_price') double? breakevenPrice,
      @JsonKey(name: 'risk_percent') double riskPercent,
      @JsonKey(name: 'rr_ratio') double rrRatio,
      @JsonKey(name: 'daily_halt') bool dailyHalt,
      @JsonKey(name: 'hard_daily_halt') bool hardDailyHalt,
      @JsonKey(name: 'weekly_review') bool weeklyReview,
      @JsonKey(name: 'correlated_exposure') bool correlatedExposure,
      @JsonKey(name: 'risk_score') double riskScore});
}

/// @nodoc
class _$RiskParamsCopyWithImpl<$Res, $Val extends RiskParams>
    implements $RiskParamsCopyWith<$Res> {
  _$RiskParamsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RiskParams
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lotSize = null,
    Object? stopLossPips = null,
    Object? takeProfitPips = null,
    Object? stopLossPrice = null,
    Object? takeProfitPrice = null,
    Object? partialClosePrice = freezed,
    Object? breakevenPrice = freezed,
    Object? riskPercent = null,
    Object? rrRatio = null,
    Object? dailyHalt = null,
    Object? hardDailyHalt = null,
    Object? weeklyReview = null,
    Object? correlatedExposure = null,
    Object? riskScore = null,
  }) {
    return _then(_value.copyWith(
      lotSize: null == lotSize
          ? _value.lotSize
          : lotSize // ignore: cast_nullable_to_non_nullable
              as double,
      stopLossPips: null == stopLossPips
          ? _value.stopLossPips
          : stopLossPips // ignore: cast_nullable_to_non_nullable
              as double,
      takeProfitPips: null == takeProfitPips
          ? _value.takeProfitPips
          : takeProfitPips // ignore: cast_nullable_to_non_nullable
              as double,
      stopLossPrice: null == stopLossPrice
          ? _value.stopLossPrice
          : stopLossPrice // ignore: cast_nullable_to_non_nullable
              as double,
      takeProfitPrice: null == takeProfitPrice
          ? _value.takeProfitPrice
          : takeProfitPrice // ignore: cast_nullable_to_non_nullable
              as double,
      partialClosePrice: freezed == partialClosePrice
          ? _value.partialClosePrice
          : partialClosePrice // ignore: cast_nullable_to_non_nullable
              as double?,
      breakevenPrice: freezed == breakevenPrice
          ? _value.breakevenPrice
          : breakevenPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      riskPercent: null == riskPercent
          ? _value.riskPercent
          : riskPercent // ignore: cast_nullable_to_non_nullable
              as double,
      rrRatio: null == rrRatio
          ? _value.rrRatio
          : rrRatio // ignore: cast_nullable_to_non_nullable
              as double,
      dailyHalt: null == dailyHalt
          ? _value.dailyHalt
          : dailyHalt // ignore: cast_nullable_to_non_nullable
              as bool,
      hardDailyHalt: null == hardDailyHalt
          ? _value.hardDailyHalt
          : hardDailyHalt // ignore: cast_nullable_to_non_nullable
              as bool,
      weeklyReview: null == weeklyReview
          ? _value.weeklyReview
          : weeklyReview // ignore: cast_nullable_to_non_nullable
              as bool,
      correlatedExposure: null == correlatedExposure
          ? _value.correlatedExposure
          : correlatedExposure // ignore: cast_nullable_to_non_nullable
              as bool,
      riskScore: null == riskScore
          ? _value.riskScore
          : riskScore // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RiskParamsImplCopyWith<$Res>
    implements $RiskParamsCopyWith<$Res> {
  factory _$$RiskParamsImplCopyWith(
          _$RiskParamsImpl value, $Res Function(_$RiskParamsImpl) then) =
      __$$RiskParamsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'lot_size') double lotSize,
      @JsonKey(name: 'stop_loss_pips') double stopLossPips,
      @JsonKey(name: 'take_profit_pips') double takeProfitPips,
      @JsonKey(name: 'stop_loss_price') double stopLossPrice,
      @JsonKey(name: 'take_profit_price') double takeProfitPrice,
      @JsonKey(name: 'partial_close_price') double? partialClosePrice,
      @JsonKey(name: 'breakeven_price') double? breakevenPrice,
      @JsonKey(name: 'risk_percent') double riskPercent,
      @JsonKey(name: 'rr_ratio') double rrRatio,
      @JsonKey(name: 'daily_halt') bool dailyHalt,
      @JsonKey(name: 'hard_daily_halt') bool hardDailyHalt,
      @JsonKey(name: 'weekly_review') bool weeklyReview,
      @JsonKey(name: 'correlated_exposure') bool correlatedExposure,
      @JsonKey(name: 'risk_score') double riskScore});
}

/// @nodoc
class __$$RiskParamsImplCopyWithImpl<$Res>
    extends _$RiskParamsCopyWithImpl<$Res, _$RiskParamsImpl>
    implements _$$RiskParamsImplCopyWith<$Res> {
  __$$RiskParamsImplCopyWithImpl(
      _$RiskParamsImpl _value, $Res Function(_$RiskParamsImpl) _then)
      : super(_value, _then);

  /// Create a copy of RiskParams
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lotSize = null,
    Object? stopLossPips = null,
    Object? takeProfitPips = null,
    Object? stopLossPrice = null,
    Object? takeProfitPrice = null,
    Object? partialClosePrice = freezed,
    Object? breakevenPrice = freezed,
    Object? riskPercent = null,
    Object? rrRatio = null,
    Object? dailyHalt = null,
    Object? hardDailyHalt = null,
    Object? weeklyReview = null,
    Object? correlatedExposure = null,
    Object? riskScore = null,
  }) {
    return _then(_$RiskParamsImpl(
      lotSize: null == lotSize
          ? _value.lotSize
          : lotSize // ignore: cast_nullable_to_non_nullable
              as double,
      stopLossPips: null == stopLossPips
          ? _value.stopLossPips
          : stopLossPips // ignore: cast_nullable_to_non_nullable
              as double,
      takeProfitPips: null == takeProfitPips
          ? _value.takeProfitPips
          : takeProfitPips // ignore: cast_nullable_to_non_nullable
              as double,
      stopLossPrice: null == stopLossPrice
          ? _value.stopLossPrice
          : stopLossPrice // ignore: cast_nullable_to_non_nullable
              as double,
      takeProfitPrice: null == takeProfitPrice
          ? _value.takeProfitPrice
          : takeProfitPrice // ignore: cast_nullable_to_non_nullable
              as double,
      partialClosePrice: freezed == partialClosePrice
          ? _value.partialClosePrice
          : partialClosePrice // ignore: cast_nullable_to_non_nullable
              as double?,
      breakevenPrice: freezed == breakevenPrice
          ? _value.breakevenPrice
          : breakevenPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      riskPercent: null == riskPercent
          ? _value.riskPercent
          : riskPercent // ignore: cast_nullable_to_non_nullable
              as double,
      rrRatio: null == rrRatio
          ? _value.rrRatio
          : rrRatio // ignore: cast_nullable_to_non_nullable
              as double,
      dailyHalt: null == dailyHalt
          ? _value.dailyHalt
          : dailyHalt // ignore: cast_nullable_to_non_nullable
              as bool,
      hardDailyHalt: null == hardDailyHalt
          ? _value.hardDailyHalt
          : hardDailyHalt // ignore: cast_nullable_to_non_nullable
              as bool,
      weeklyReview: null == weeklyReview
          ? _value.weeklyReview
          : weeklyReview // ignore: cast_nullable_to_non_nullable
              as bool,
      correlatedExposure: null == correlatedExposure
          ? _value.correlatedExposure
          : correlatedExposure // ignore: cast_nullable_to_non_nullable
              as bool,
      riskScore: null == riskScore
          ? _value.riskScore
          : riskScore // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RiskParamsImpl implements _RiskParams {
  const _$RiskParamsImpl(
      {@JsonKey(name: 'lot_size') this.lotSize = 0.0,
      @JsonKey(name: 'stop_loss_pips') this.stopLossPips = 0.0,
      @JsonKey(name: 'take_profit_pips') this.takeProfitPips = 0.0,
      @JsonKey(name: 'stop_loss_price') this.stopLossPrice = 0.0,
      @JsonKey(name: 'take_profit_price') this.takeProfitPrice = 0.0,
      @JsonKey(name: 'partial_close_price') this.partialClosePrice,
      @JsonKey(name: 'breakeven_price') this.breakevenPrice,
      @JsonKey(name: 'risk_percent') this.riskPercent = 0.0,
      @JsonKey(name: 'rr_ratio') this.rrRatio = 0.0,
      @JsonKey(name: 'daily_halt') this.dailyHalt = false,
      @JsonKey(name: 'hard_daily_halt') this.hardDailyHalt = false,
      @JsonKey(name: 'weekly_review') this.weeklyReview = false,
      @JsonKey(name: 'correlated_exposure') this.correlatedExposure = false,
      @JsonKey(name: 'risk_score') this.riskScore = 0.0});

  factory _$RiskParamsImpl.fromJson(Map<String, dynamic> json) =>
      _$$RiskParamsImplFromJson(json);

  @override
  @JsonKey(name: 'lot_size')
  final double lotSize;
  @override
  @JsonKey(name: 'stop_loss_pips')
  final double stopLossPips;
  @override
  @JsonKey(name: 'take_profit_pips')
  final double takeProfitPips;
  @override
  @JsonKey(name: 'stop_loss_price')
  final double stopLossPrice;
  @override
  @JsonKey(name: 'take_profit_price')
  final double takeProfitPrice;
  @override
  @JsonKey(name: 'partial_close_price')
  final double? partialClosePrice;
  @override
  @JsonKey(name: 'breakeven_price')
  final double? breakevenPrice;
  @override
  @JsonKey(name: 'risk_percent')
  final double riskPercent;
  @override
  @JsonKey(name: 'rr_ratio')
  final double rrRatio;
  @override
  @JsonKey(name: 'daily_halt')
  final bool dailyHalt;
  @override
  @JsonKey(name: 'hard_daily_halt')
  final bool hardDailyHalt;
  @override
  @JsonKey(name: 'weekly_review')
  final bool weeklyReview;
  @override
  @JsonKey(name: 'correlated_exposure')
  final bool correlatedExposure;
  @override
  @JsonKey(name: 'risk_score')
  final double riskScore;

  @override
  String toString() {
    return 'RiskParams(lotSize: $lotSize, stopLossPips: $stopLossPips, takeProfitPips: $takeProfitPips, stopLossPrice: $stopLossPrice, takeProfitPrice: $takeProfitPrice, partialClosePrice: $partialClosePrice, breakevenPrice: $breakevenPrice, riskPercent: $riskPercent, rrRatio: $rrRatio, dailyHalt: $dailyHalt, hardDailyHalt: $hardDailyHalt, weeklyReview: $weeklyReview, correlatedExposure: $correlatedExposure, riskScore: $riskScore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RiskParamsImpl &&
            (identical(other.lotSize, lotSize) || other.lotSize == lotSize) &&
            (identical(other.stopLossPips, stopLossPips) ||
                other.stopLossPips == stopLossPips) &&
            (identical(other.takeProfitPips, takeProfitPips) ||
                other.takeProfitPips == takeProfitPips) &&
            (identical(other.stopLossPrice, stopLossPrice) ||
                other.stopLossPrice == stopLossPrice) &&
            (identical(other.takeProfitPrice, takeProfitPrice) ||
                other.takeProfitPrice == takeProfitPrice) &&
            (identical(other.partialClosePrice, partialClosePrice) ||
                other.partialClosePrice == partialClosePrice) &&
            (identical(other.breakevenPrice, breakevenPrice) ||
                other.breakevenPrice == breakevenPrice) &&
            (identical(other.riskPercent, riskPercent) ||
                other.riskPercent == riskPercent) &&
            (identical(other.rrRatio, rrRatio) || other.rrRatio == rrRatio) &&
            (identical(other.dailyHalt, dailyHalt) ||
                other.dailyHalt == dailyHalt) &&
            (identical(other.hardDailyHalt, hardDailyHalt) ||
                other.hardDailyHalt == hardDailyHalt) &&
            (identical(other.weeklyReview, weeklyReview) ||
                other.weeklyReview == weeklyReview) &&
            (identical(other.correlatedExposure, correlatedExposure) ||
                other.correlatedExposure == correlatedExposure) &&
            (identical(other.riskScore, riskScore) ||
                other.riskScore == riskScore));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      lotSize,
      stopLossPips,
      takeProfitPips,
      stopLossPrice,
      takeProfitPrice,
      partialClosePrice,
      breakevenPrice,
      riskPercent,
      rrRatio,
      dailyHalt,
      hardDailyHalt,
      weeklyReview,
      correlatedExposure,
      riskScore);

  /// Create a copy of RiskParams
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RiskParamsImplCopyWith<_$RiskParamsImpl> get copyWith =>
      __$$RiskParamsImplCopyWithImpl<_$RiskParamsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RiskParamsImplToJson(
      this,
    );
  }
}

abstract class _RiskParams implements RiskParams {
  const factory _RiskParams(
      {@JsonKey(name: 'lot_size') final double lotSize,
      @JsonKey(name: 'stop_loss_pips') final double stopLossPips,
      @JsonKey(name: 'take_profit_pips') final double takeProfitPips,
      @JsonKey(name: 'stop_loss_price') final double stopLossPrice,
      @JsonKey(name: 'take_profit_price') final double takeProfitPrice,
      @JsonKey(name: 'partial_close_price') final double? partialClosePrice,
      @JsonKey(name: 'breakeven_price') final double? breakevenPrice,
      @JsonKey(name: 'risk_percent') final double riskPercent,
      @JsonKey(name: 'rr_ratio') final double rrRatio,
      @JsonKey(name: 'daily_halt') final bool dailyHalt,
      @JsonKey(name: 'hard_daily_halt') final bool hardDailyHalt,
      @JsonKey(name: 'weekly_review') final bool weeklyReview,
      @JsonKey(name: 'correlated_exposure') final bool correlatedExposure,
      @JsonKey(name: 'risk_score') final double riskScore}) = _$RiskParamsImpl;

  factory _RiskParams.fromJson(Map<String, dynamic> json) =
      _$RiskParamsImpl.fromJson;

  @override
  @JsonKey(name: 'lot_size')
  double get lotSize;
  @override
  @JsonKey(name: 'stop_loss_pips')
  double get stopLossPips;
  @override
  @JsonKey(name: 'take_profit_pips')
  double get takeProfitPips;
  @override
  @JsonKey(name: 'stop_loss_price')
  double get stopLossPrice;
  @override
  @JsonKey(name: 'take_profit_price')
  double get takeProfitPrice;
  @override
  @JsonKey(name: 'partial_close_price')
  double? get partialClosePrice;
  @override
  @JsonKey(name: 'breakeven_price')
  double? get breakevenPrice;
  @override
  @JsonKey(name: 'risk_percent')
  double get riskPercent;
  @override
  @JsonKey(name: 'rr_ratio')
  double get rrRatio;
  @override
  @JsonKey(name: 'daily_halt')
  bool get dailyHalt;
  @override
  @JsonKey(name: 'hard_daily_halt')
  bool get hardDailyHalt;
  @override
  @JsonKey(name: 'weekly_review')
  bool get weeklyReview;
  @override
  @JsonKey(name: 'correlated_exposure')
  bool get correlatedExposure;
  @override
  @JsonKey(name: 'risk_score')
  double get riskScore;

  /// Create a copy of RiskParams
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RiskParamsImplCopyWith<_$RiskParamsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
