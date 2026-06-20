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
  Map<String, dynamic> get metrics => throw _privateConstructorUsedError;
  @JsonKey(name: 'strategy_breakdown')
  Map<String, dynamic> get strategyBreakdown =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'session_performance')
  Map<String, double> get sessionPerformance =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'monthly_returns')
  Map<String, double> get monthlyReturns => throw _privateConstructorUsedError;
  @JsonKey(name: 'equity_curve')
  List<Map<String, dynamic>> get equityCurve =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'best_trades')
  List<TradeRecord> get bestTrades => throw _privateConstructorUsedError;
  @JsonKey(name: 'worst_trades')
  List<TradeRecord> get worstTrades => throw _privateConstructorUsedError;

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
      {Map<String, dynamic> metrics,
      @JsonKey(name: 'strategy_breakdown')
      Map<String, dynamic> strategyBreakdown,
      @JsonKey(name: 'session_performance')
      Map<String, double> sessionPerformance,
      @JsonKey(name: 'monthly_returns') Map<String, double> monthlyReturns,
      @JsonKey(name: 'equity_curve') List<Map<String, dynamic>> equityCurve,
      @JsonKey(name: 'best_trades') List<TradeRecord> bestTrades,
      @JsonKey(name: 'worst_trades') List<TradeRecord> worstTrades});
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
    Object? metrics = null,
    Object? strategyBreakdown = null,
    Object? sessionPerformance = null,
    Object? monthlyReturns = null,
    Object? equityCurve = null,
    Object? bestTrades = null,
    Object? worstTrades = null,
  }) {
    return _then(_value.copyWith(
      metrics: null == metrics
          ? _value.metrics
          : metrics // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      strategyBreakdown: null == strategyBreakdown
          ? _value.strategyBreakdown
          : strategyBreakdown // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      sessionPerformance: null == sessionPerformance
          ? _value.sessionPerformance
          : sessionPerformance // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      monthlyReturns: null == monthlyReturns
          ? _value.monthlyReturns
          : monthlyReturns // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      equityCurve: null == equityCurve
          ? _value.equityCurve
          : equityCurve // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      bestTrades: null == bestTrades
          ? _value.bestTrades
          : bestTrades // ignore: cast_nullable_to_non_nullable
              as List<TradeRecord>,
      worstTrades: null == worstTrades
          ? _value.worstTrades
          : worstTrades // ignore: cast_nullable_to_non_nullable
              as List<TradeRecord>,
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
      {Map<String, dynamic> metrics,
      @JsonKey(name: 'strategy_breakdown')
      Map<String, dynamic> strategyBreakdown,
      @JsonKey(name: 'session_performance')
      Map<String, double> sessionPerformance,
      @JsonKey(name: 'monthly_returns') Map<String, double> monthlyReturns,
      @JsonKey(name: 'equity_curve') List<Map<String, dynamic>> equityCurve,
      @JsonKey(name: 'best_trades') List<TradeRecord> bestTrades,
      @JsonKey(name: 'worst_trades') List<TradeRecord> worstTrades});
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
    Object? metrics = null,
    Object? strategyBreakdown = null,
    Object? sessionPerformance = null,
    Object? monthlyReturns = null,
    Object? equityCurve = null,
    Object? bestTrades = null,
    Object? worstTrades = null,
  }) {
    return _then(_$PerformanceMetricsImpl(
      metrics: null == metrics
          ? _value._metrics
          : metrics // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      strategyBreakdown: null == strategyBreakdown
          ? _value._strategyBreakdown
          : strategyBreakdown // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      sessionPerformance: null == sessionPerformance
          ? _value._sessionPerformance
          : sessionPerformance // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      monthlyReturns: null == monthlyReturns
          ? _value._monthlyReturns
          : monthlyReturns // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      equityCurve: null == equityCurve
          ? _value._equityCurve
          : equityCurve // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      bestTrades: null == bestTrades
          ? _value._bestTrades
          : bestTrades // ignore: cast_nullable_to_non_nullable
              as List<TradeRecord>,
      worstTrades: null == worstTrades
          ? _value._worstTrades
          : worstTrades // ignore: cast_nullable_to_non_nullable
              as List<TradeRecord>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PerformanceMetricsImpl implements _PerformanceMetrics {
  const _$PerformanceMetricsImpl(
      {final Map<String, dynamic> metrics = const {},
      @JsonKey(name: 'strategy_breakdown')
      final Map<String, dynamic> strategyBreakdown = const {},
      @JsonKey(name: 'session_performance')
      final Map<String, double> sessionPerformance = const {},
      @JsonKey(name: 'monthly_returns')
      final Map<String, double> monthlyReturns = const {},
      @JsonKey(name: 'equity_curve')
      final List<Map<String, dynamic>> equityCurve = const [],
      @JsonKey(name: 'best_trades')
      final List<TradeRecord> bestTrades = const [],
      @JsonKey(name: 'worst_trades')
      final List<TradeRecord> worstTrades = const []})
      : _metrics = metrics,
        _strategyBreakdown = strategyBreakdown,
        _sessionPerformance = sessionPerformance,
        _monthlyReturns = monthlyReturns,
        _equityCurve = equityCurve,
        _bestTrades = bestTrades,
        _worstTrades = worstTrades;

  factory _$PerformanceMetricsImpl.fromJson(Map<String, dynamic> json) =>
      _$$PerformanceMetricsImplFromJson(json);

  final Map<String, dynamic> _metrics;
  @override
  @JsonKey()
  Map<String, dynamic> get metrics {
    if (_metrics is EqualUnmodifiableMapView) return _metrics;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metrics);
  }

  final Map<String, dynamic> _strategyBreakdown;
  @override
  @JsonKey(name: 'strategy_breakdown')
  Map<String, dynamic> get strategyBreakdown {
    if (_strategyBreakdown is EqualUnmodifiableMapView)
      return _strategyBreakdown;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_strategyBreakdown);
  }

  final Map<String, double> _sessionPerformance;
  @override
  @JsonKey(name: 'session_performance')
  Map<String, double> get sessionPerformance {
    if (_sessionPerformance is EqualUnmodifiableMapView)
      return _sessionPerformance;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_sessionPerformance);
  }

  final Map<String, double> _monthlyReturns;
  @override
  @JsonKey(name: 'monthly_returns')
  Map<String, double> get monthlyReturns {
    if (_monthlyReturns is EqualUnmodifiableMapView) return _monthlyReturns;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_monthlyReturns);
  }

  final List<Map<String, dynamic>> _equityCurve;
  @override
  @JsonKey(name: 'equity_curve')
  List<Map<String, dynamic>> get equityCurve {
    if (_equityCurve is EqualUnmodifiableListView) return _equityCurve;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_equityCurve);
  }

  final List<TradeRecord> _bestTrades;
  @override
  @JsonKey(name: 'best_trades')
  List<TradeRecord> get bestTrades {
    if (_bestTrades is EqualUnmodifiableListView) return _bestTrades;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_bestTrades);
  }

  final List<TradeRecord> _worstTrades;
  @override
  @JsonKey(name: 'worst_trades')
  List<TradeRecord> get worstTrades {
    if (_worstTrades is EqualUnmodifiableListView) return _worstTrades;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_worstTrades);
  }

  @override
  String toString() {
    return 'PerformanceMetrics(metrics: $metrics, strategyBreakdown: $strategyBreakdown, sessionPerformance: $sessionPerformance, monthlyReturns: $monthlyReturns, equityCurve: $equityCurve, bestTrades: $bestTrades, worstTrades: $worstTrades)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PerformanceMetricsImpl &&
            const DeepCollectionEquality().equals(other._metrics, _metrics) &&
            const DeepCollectionEquality()
                .equals(other._strategyBreakdown, _strategyBreakdown) &&
            const DeepCollectionEquality()
                .equals(other._sessionPerformance, _sessionPerformance) &&
            const DeepCollectionEquality()
                .equals(other._monthlyReturns, _monthlyReturns) &&
            const DeepCollectionEquality()
                .equals(other._equityCurve, _equityCurve) &&
            const DeepCollectionEquality()
                .equals(other._bestTrades, _bestTrades) &&
            const DeepCollectionEquality()
                .equals(other._worstTrades, _worstTrades));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_metrics),
      const DeepCollectionEquality().hash(_strategyBreakdown),
      const DeepCollectionEquality().hash(_sessionPerformance),
      const DeepCollectionEquality().hash(_monthlyReturns),
      const DeepCollectionEquality().hash(_equityCurve),
      const DeepCollectionEquality().hash(_bestTrades),
      const DeepCollectionEquality().hash(_worstTrades));

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
          {final Map<String, dynamic> metrics,
          @JsonKey(name: 'strategy_breakdown')
          final Map<String, dynamic> strategyBreakdown,
          @JsonKey(name: 'session_performance')
          final Map<String, double> sessionPerformance,
          @JsonKey(name: 'monthly_returns')
          final Map<String, double> monthlyReturns,
          @JsonKey(name: 'equity_curve')
          final List<Map<String, dynamic>> equityCurve,
          @JsonKey(name: 'best_trades') final List<TradeRecord> bestTrades,
          @JsonKey(name: 'worst_trades') final List<TradeRecord> worstTrades}) =
      _$PerformanceMetricsImpl;

  factory _PerformanceMetrics.fromJson(Map<String, dynamic> json) =
      _$PerformanceMetricsImpl.fromJson;

  @override
  Map<String, dynamic> get metrics;
  @override
  @JsonKey(name: 'strategy_breakdown')
  Map<String, dynamic> get strategyBreakdown;
  @override
  @JsonKey(name: 'session_performance')
  Map<String, double> get sessionPerformance;
  @override
  @JsonKey(name: 'monthly_returns')
  Map<String, double> get monthlyReturns;
  @override
  @JsonKey(name: 'equity_curve')
  List<Map<String, dynamic>> get equityCurve;
  @override
  @JsonKey(name: 'best_trades')
  List<TradeRecord> get bestTrades;
  @override
  @JsonKey(name: 'worst_trades')
  List<TradeRecord> get worstTrades;

  /// Create a copy of PerformanceMetrics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PerformanceMetricsImplCopyWith<_$PerformanceMetricsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
