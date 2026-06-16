// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'performance_metrics.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PerformanceMetrics _$PerformanceMetricsFromJson(Map<String, dynamic> json) {
  return _PerformanceMetrics.fromJson(json);
}

/// @nodoc
mixin _$PerformanceMetrics {
  @JsonKey(name: 'total_trades')
  int get totalTrades => throw _privateConstructorUsedError;
  @JsonKey(name: 'win_rate')
  double get winRate => throw _privateConstructorUsedError;
  @JsonKey(name: 'gross_profit')
  double get grossProfit => throw _privateConstructorUsedError;
  @JsonKey(name: 'gross_loss')
  double get grossLoss => throw _privateConstructorUsedError;
  @JsonKey(name: 'net_pnl')
  double get netPnl => throw _privateConstructorUsedError;
  @JsonKey(name: 'max_drawdown')
  double get maxDrawdown => throw _privateConstructorUsedError;
  @JsonKey(name: 'sharpe_ratio')
  double get sharpeRatio => throw _privateConstructorUsedError;
  @JsonKey(name: 'profit_factor')
  double get profitFactor => throw _privateConstructorUsedError;
  @JsonKey(name: 'avg_rr')
  double get avgRR => throw _privateConstructorUsedError;
  @JsonKey(name: 'best_trade_pips')
  double get bestTradePips => throw _privateConstructorUsedError;
  @JsonKey(name: 'worst_trade_pips')
  double get worstTradePips => throw _privateConstructorUsedError;

  /// Serializes this PerformanceMetrics to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PerformanceMetrics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PerformanceMetricsCopyWith<PerformanceMetrics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PerformanceMetricsCopyWith<$Res> {
  factory $PerformanceMetricsCopyWith(
          PerformanceMetrics value, $Res Function(PerformanceMetrics) then) =
      _$PerformanceMetricsCopyWithImpl<$Res, PerformanceMetrics>;
  @useResult
  $Res call(
      {@JsonKey(name: 'total_trades') int totalTrades,
      @JsonKey(name: 'win_rate') double winRate,
      @JsonKey(name: 'gross_profit') double grossProfit,
      @JsonKey(name: 'gross_loss') double grossLoss,
      @JsonKey(name: 'net_pnl') double netPnl,
      @JsonKey(name: 'max_drawdown') double maxDrawdown,
      @JsonKey(name: 'sharpe_ratio') double sharpeRatio,
      @JsonKey(name: 'profit_factor') double profitFactor,
      @JsonKey(name: 'avg_rr') double avgRR,
      @JsonKey(name: 'best_trade_pips') double bestTradePips,
      @JsonKey(name: 'worst_trade_pips') double worstTradePips});
}

/// @nodoc
class _$PerformanceMetricsCopyWithImpl<$Res, $Val extends PerformanceMetrics>
    implements $PerformanceMetricsCopyWith<$Res> {
  _$PerformanceMetricsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PerformanceMetrics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalTrades = null,
    Object? winRate = null,
    Object? grossProfit = null,
    Object? grossLoss = null,
    Object? netPnl = null,
    Object? maxDrawdown = null,
    Object? sharpeRatio = null,
    Object? profitFactor = null,
    Object? avgRR = null,
    Object? bestTradePips = null,
    Object? worstTradePips = null,
  }) {
    return _then(_value.copyWith(
      totalTrades: null == totalTrades
          ? _value.totalTrades
          : totalTrades // ignore: cast_nullable_to_non_nullable
              as int,
      winRate: null == winRate
          ? _value.winRate
          : winRate // ignore: cast_nullable_to_non_nullable
              as double,
      grossProfit: null == grossProfit
          ? _value.grossProfit
          : grossProfit // ignore: cast_nullable_to_non_nullable
              as double,
      grossLoss: null == grossLoss
          ? _value.grossLoss
          : grossLoss // ignore: cast_nullable_to_non_nullable
              as double,
      netPnl: null == netPnl
          ? _value.netPnl
          : netPnl // ignore: cast_nullable_to_non_nullable
              as double,
      maxDrawdown: null == maxDrawdown
          ? _value.maxDrawdown
          : maxDrawdown // ignore: cast_nullable_to_non_nullable
              as double,
      sharpeRatio: null == sharpeRatio
          ? _value.sharpeRatio
          : sharpeRatio // ignore: cast_nullable_to_non_nullable
              as double,
      profitFactor: null == profitFactor
          ? _value.profitFactor
          : profitFactor // ignore: cast_nullable_to_non_nullable
              as double,
      avgRR: null == avgRR
          ? _value.avgRR
          : avgRR // ignore: cast_nullable_to_non_nullable
              as double,
      bestTradePips: null == bestTradePips
          ? _value.bestTradePips
          : bestTradePips // ignore: cast_nullable_to_non_nullable
              as double,
      worstTradePips: null == worstTradePips
          ? _value.worstTradePips
          : worstTradePips // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PerformanceMetricsImplCopyWith<$Res>
    implements $PerformanceMetricsCopyWith<$Res> {
  factory _$$PerformanceMetricsImplCopyWith(_$PerformanceMetricsImpl value,
          $Res Function(_$PerformanceMetricsImpl) then) =
      __$$PerformanceMetricsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'total_trades') int totalTrades,
      @JsonKey(name: 'win_rate') double winRate,
      @JsonKey(name: 'gross_profit') double grossProfit,
      @JsonKey(name: 'gross_loss') double grossLoss,
      @JsonKey(name: 'net_pnl') double netPnl,
      @JsonKey(name: 'max_drawdown') double maxDrawdown,
      @JsonKey(name: 'sharpe_ratio') double sharpeRatio,
      @JsonKey(name: 'profit_factor') double profitFactor,
      @JsonKey(name: 'avg_rr') double avgRR,
      @JsonKey(name: 'best_trade_pips') double bestTradePips,
      @JsonKey(name: 'worst_trade_pips') double worstTradePips});
}

/// @nodoc
class __$$PerformanceMetricsImplCopyWithImpl<$Res>
    extends _$PerformanceMetricsCopyWithImpl<$Res, _$PerformanceMetricsImpl>
    implements _$$PerformanceMetricsImplCopyWith<$Res> {
  __$$PerformanceMetricsImplCopyWithImpl(_$PerformanceMetricsImpl _value,
      $Res Function(_$PerformanceMetricsImpl) _then)
      : super(_value, _then);

  /// Create a copy of PerformanceMetrics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalTrades = null,
    Object? winRate = null,
    Object? grossProfit = null,
    Object? grossLoss = null,
    Object? netPnl = null,
    Object? maxDrawdown = null,
    Object? sharpeRatio = null,
    Object? profitFactor = null,
    Object? avgRR = null,
    Object? bestTradePips = null,
    Object? worstTradePips = null,
  }) {
    return _then(_$PerformanceMetricsImpl(
      totalTrades: null == totalTrades
          ? _value.totalTrades
          : totalTrades // ignore: cast_nullable_to_non_nullable
              as int,
      winRate: null == winRate
          ? _value.winRate
          : winRate // ignore: cast_nullable_to_non_nullable
              as double,
      grossProfit: null == grossProfit
          ? _value.grossProfit
          : grossProfit // ignore: cast_nullable_to_non_nullable
              as double,
      grossLoss: null == grossLoss
          ? _value.grossLoss
          : grossLoss // ignore: cast_nullable_to_non_nullable
              as double,
      netPnl: null == netPnl
          ? _value.netPnl
          : netPnl // ignore: cast_nullable_to_non_nullable
              as double,
      maxDrawdown: null == maxDrawdown
          ? _value.maxDrawdown
          : maxDrawdown // ignore: cast_nullable_to_non_nullable
              as double,
      sharpeRatio: null == sharpeRatio
          ? _value.sharpeRatio
          : sharpeRatio // ignore: cast_nullable_to_non_nullable
              as double,
      profitFactor: null == profitFactor
          ? _value.profitFactor
          : profitFactor // ignore: cast_nullable_to_non_nullable
              as double,
      avgRR: null == avgRR
          ? _value.avgRR
          : avgRR // ignore: cast_nullable_to_non_nullable
              as double,
      bestTradePips: null == bestTradePips
          ? _value.bestTradePips
          : bestTradePips // ignore: cast_nullable_to_non_nullable
              as double,
      worstTradePips: null == worstTradePips
          ? _value.worstTradePips
          : worstTradePips // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PerformanceMetricsImpl implements _PerformanceMetrics {
  const _$PerformanceMetricsImpl(
      {@JsonKey(name: 'total_trades') required this.totalTrades,
      @JsonKey(name: 'win_rate') required this.winRate,
      @JsonKey(name: 'gross_profit') required this.grossProfit,
      @JsonKey(name: 'gross_loss') required this.grossLoss,
      @JsonKey(name: 'net_pnl') required this.netPnl,
      @JsonKey(name: 'max_drawdown') required this.maxDrawdown,
      @JsonKey(name: 'sharpe_ratio') required this.sharpeRatio,
      @JsonKey(name: 'profit_factor') required this.profitFactor,
      @JsonKey(name: 'avg_rr') required this.avgRR,
      @JsonKey(name: 'best_trade_pips') required this.bestTradePips,
      @JsonKey(name: 'worst_trade_pips') required this.worstTradePips});

  factory _$PerformanceMetricsImpl.fromJson(Map<String, dynamic> json) =>
      _$$PerformanceMetricsImplFromJson(json);

  @override
  @JsonKey(name: 'total_trades')
  final int totalTrades;
  @override
  @JsonKey(name: 'win_rate')
  final double winRate;
  @override
  @JsonKey(name: 'gross_profit')
  final double grossProfit;
  @override
  @JsonKey(name: 'gross_loss')
  final double grossLoss;
  @override
  @JsonKey(name: 'net_pnl')
  final double netPnl;
  @override
  @JsonKey(name: 'max_drawdown')
  final double maxDrawdown;
  @override
  @JsonKey(name: 'sharpe_ratio')
  final double sharpeRatio;
  @override
  @JsonKey(name: 'profit_factor')
  final double profitFactor;
  @override
  @JsonKey(name: 'avg_rr')
  final double avgRR;
  @override
  @JsonKey(name: 'best_trade_pips')
  final double bestTradePips;
  @override
  @JsonKey(name: 'worst_trade_pips')
  final double worstTradePips;

  @override
  String toString() {
    return 'PerformanceMetrics(totalTrades: $totalTrades, winRate: $winRate, grossProfit: $grossProfit, grossLoss: $grossLoss, netPnl: $netPnl, maxDrawdown: $maxDrawdown, sharpeRatio: $sharpeRatio, profitFactor: $profitFactor, avgRR: $avgRR, bestTradePips: $bestTradePips, worstTradePips: $worstTradePips)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PerformanceMetricsImpl &&
            (identical(other.totalTrades, totalTrades) ||
                other.totalTrades == totalTrades) &&
            (identical(other.winRate, winRate) || other.winRate == winRate) &&
            (identical(other.grossProfit, grossProfit) ||
                other.grossProfit == grossProfit) &&
            (identical(other.grossLoss, grossLoss) ||
                other.grossLoss == grossLoss) &&
            (identical(other.netPnl, netPnl) || other.netPnl == netPnl) &&
            (identical(other.maxDrawdown, maxDrawdown) ||
                other.maxDrawdown == maxDrawdown) &&
            (identical(other.sharpeRatio, sharpeRatio) ||
                other.sharpeRatio == sharpeRatio) &&
            (identical(other.profitFactor, profitFactor) ||
                other.profitFactor == profitFactor) &&
            (identical(other.avgRR, avgRR) || other.avgRR == avgRR) &&
            (identical(other.bestTradePips, bestTradePips) ||
                other.bestTradePips == bestTradePips) &&
            (identical(other.worstTradePips, worstTradePips) ||
                other.worstTradePips == worstTradePips));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      totalTrades,
      winRate,
      grossProfit,
      grossLoss,
      netPnl,
      maxDrawdown,
      sharpeRatio,
      profitFactor,
      avgRR,
      bestTradePips,
      worstTradePips);

  /// Create a copy of PerformanceMetrics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PerformanceMetricsImplCopyWith<_$PerformanceMetricsImpl> get copyWith =>
      __$$PerformanceMetricsImplCopyWithImpl<_$PerformanceMetricsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PerformanceMetricsImplToJson(
      this,
    );
  }
}

abstract class _PerformanceMetrics implements PerformanceMetrics {
  const factory _PerformanceMetrics(
      {@JsonKey(name: 'total_trades') required final int totalTrades,
      @JsonKey(name: 'win_rate') required final double winRate,
      @JsonKey(name: 'gross_profit') required final double grossProfit,
      @JsonKey(name: 'gross_loss') required final double grossLoss,
      @JsonKey(name: 'net_pnl') required final double netPnl,
      @JsonKey(name: 'max_drawdown') required final double maxDrawdown,
      @JsonKey(name: 'sharpe_ratio') required final double sharpeRatio,
      @JsonKey(name: 'profit_factor') required final double profitFactor,
      @JsonKey(name: 'avg_rr') required final double avgRR,
      @JsonKey(name: 'best_trade_pips') required final double bestTradePips,
      @JsonKey(name: 'worst_trade_pips')
      required final double worstTradePips}) = _$PerformanceMetricsImpl;

  factory _PerformanceMetrics.fromJson(Map<String, dynamic> json) =
      _$PerformanceMetricsImpl.fromJson;

  @override
  @JsonKey(name: 'total_trades')
  int get totalTrades;
  @override
  @JsonKey(name: 'win_rate')
  double get winRate;
  @override
  @JsonKey(name: 'gross_profit')
  double get grossProfit;
  @override
  @JsonKey(name: 'gross_loss')
  double get grossLoss;
  @override
  @JsonKey(name: 'net_pnl')
  double get netPnl;
  @override
  @JsonKey(name: 'max_drawdown')
  double get maxDrawdown;
  @override
  @JsonKey(name: 'sharpe_ratio')
  double get sharpeRatio;
  @override
  @JsonKey(name: 'profit_factor')
  double get profitFactor;
  @override
  @JsonKey(name: 'avg_rr')
  double get avgRR;
  @override
  @JsonKey(name: 'best_trade_pips')
  double get bestTradePips;
  @override
  @JsonKey(name: 'worst_trade_pips')
  double get worstTradePips;

  /// Create a copy of PerformanceMetrics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PerformanceMetricsImplCopyWith<_$PerformanceMetricsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
