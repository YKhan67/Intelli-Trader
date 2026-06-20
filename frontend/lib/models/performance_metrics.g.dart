// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'performance_metrics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PerformanceMetricsImpl _$$PerformanceMetricsImplFromJson(
        Map<String, dynamic> json) =>
    _$PerformanceMetricsImpl(
      metrics: json['metrics'] as Map<String, dynamic>? ?? const {},
      strategyBreakdown:
          json['strategy_breakdown'] as Map<String, dynamic>? ?? const {},
      sessionPerformance:
          (json['session_performance'] as Map<String, dynamic>?)?.map(
                (k, e) => MapEntry(k, (e as num).toDouble()),
              ) ??
              const {},
      monthlyReturns: (json['monthly_returns'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toDouble()),
          ) ??
          const {},
      equityCurve: (json['equity_curve'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          const [],
      bestTrades: (json['best_trades'] as List<dynamic>?)
              ?.map((e) => TradeRecord.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      worstTrades: (json['worst_trades'] as List<dynamic>?)
              ?.map((e) => TradeRecord.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$PerformanceMetricsImplToJson(
        _$PerformanceMetricsImpl instance) =>
    <String, dynamic>{
      'metrics': instance.metrics,
      'strategy_breakdown': instance.strategyBreakdown,
      'session_performance': instance.sessionPerformance,
      'monthly_returns': instance.monthlyReturns,
      'equity_curve': instance.equityCurve,
      'best_trades': instance.bestTrades,
      'worst_trades': instance.worstTrades,
    };
