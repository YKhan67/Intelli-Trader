import 'package:freezed_annotation/freezed_annotation.dart';
import 'trade_record.dart';

part 'performance_metrics.freezed.dart';
part 'performance_metrics.g.dart';

@freezed
class PerformanceMetrics with _$PerformanceMetrics {
  const factory PerformanceMetrics({
    @Default({}) Map<String, dynamic> metrics,
    @JsonKey(name: 'strategy_breakdown') @Default({}) Map<String, dynamic> strategyBreakdown,
    @JsonKey(name: 'session_performance') @Default({}) Map<String, double> sessionPerformance,
    @JsonKey(name: 'monthly_returns') @Default({}) Map<String, double> monthlyReturns,
    @JsonKey(name: 'equity_curve') @Default([]) List<Map<String, dynamic>> equityCurve,
    @JsonKey(name: 'best_trades') @Default([]) List<TradeRecord> bestTrades,
    @JsonKey(name: 'worst_trades') @Default([]) List<TradeRecord> worstTrades,
  }) = _PerformanceMetrics;

  factory PerformanceMetrics.fromJson(Map<String, dynamic> json) => _$PerformanceMetricsFromJson(json);
}
