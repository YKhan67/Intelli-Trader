// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'performance_metrics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PerformanceMetricsImpl _$$PerformanceMetricsImplFromJson(
        Map<String, dynamic> json) =>
    _$PerformanceMetricsImpl(
      totalTrades: (json['total_trades'] as num).toInt(),
      winRate: (json['win_rate'] as num).toDouble(),
      grossProfit: (json['gross_profit'] as num).toDouble(),
      grossLoss: (json['gross_loss'] as num).toDouble(),
      netPnl: (json['net_pnl'] as num).toDouble(),
      maxDrawdown: (json['max_drawdown'] as num).toDouble(),
      sharpeRatio: (json['sharpe_ratio'] as num).toDouble(),
      profitFactor: (json['profit_factor'] as num).toDouble(),
      avgRR: (json['avg_rr'] as num).toDouble(),
      bestTradePips: (json['best_trade_pips'] as num).toDouble(),
      worstTradePips: (json['worst_trade_pips'] as num).toDouble(),
    );

Map<String, dynamic> _$$PerformanceMetricsImplToJson(
        _$PerformanceMetricsImpl instance) =>
    <String, dynamic>{
      'total_trades': instance.totalTrades,
      'win_rate': instance.winRate,
      'gross_profit': instance.grossProfit,
      'gross_loss': instance.grossLoss,
      'net_pnl': instance.netPnl,
      'max_drawdown': instance.maxDrawdown,
      'sharpe_ratio': instance.sharpeRatio,
      'profit_factor': instance.profitFactor,
      'avg_rr': instance.avgRR,
      'best_trade_pips': instance.bestTradePips,
      'worst_trade_pips': instance.worstTradePips,
    };
