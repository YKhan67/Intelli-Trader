import 'package:freezed_annotation/freezed_annotation.dart';

part 'performance_metrics.freezed.dart';
part 'performance_metrics.g.dart';

@freezed
class PerformanceMetrics with _$PerformanceMetrics {
  const factory PerformanceMetrics({
    @JsonKey(name: 'total_trades') required int totalTrades,
    @JsonKey(name: 'win_rate') required double winRate,
    @JsonKey(name: 'gross_profit') required double grossProfit,
    @JsonKey(name: 'gross_loss') required double grossLoss,
    @JsonKey(name: 'net_pnl') required double netPnl,
    @JsonKey(name: 'max_drawdown') required double maxDrawdown,
    @JsonKey(name: 'sharpe_ratio') required double sharpeRatio,
    @JsonKey(name: 'profit_factor') required double profitFactor,
    @JsonKey(name: 'avg_rr') required double avgRR,
    @JsonKey(name: 'best_trade_pips') required double bestTradePips,
    @JsonKey(name: 'worst_trade_pips') required double worstTradePips,
  }) = _PerformanceMetrics;

  factory PerformanceMetrics.fromJson(Map<String, dynamic> json) => _$PerformanceMetricsFromJson(json);
}
