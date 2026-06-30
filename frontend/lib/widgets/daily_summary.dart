import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/providers.dart';
import '../theme/colors.dart';
import '../theme/spacing.dart';
import 'metric_card.dart';

class DailySummaryBar extends ConsumerWidget {
  const DailySummaryBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final perf = ref.watch(performanceProvider).value;
    
    if (perf == null) {
      return const SizedBox(height: 70); 
    }

    final m = perf.metrics;
    final double pnl = (m['net_pnl'] ?? 0.0).toDouble();
    final int tradeCount = (m['total_trades'] ?? 0).toInt();
    final double winRate = (m['win_rate'] ?? 0.0).toDouble();
    final double drawdown = (m['max_drawdown'] ?? 0.0).toDouble();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      child: Row(
        children: [
          SizedBox(
            width: 130,
            child: MetricCard(
              label: "Today P&L",
              value: "${pnl >= 0 ? '+' : ''}\$${pnl.toStringAsFixed(2)}",
              valueColor: pnl >= 0 ? AppColors.profitGreen : AppColors.lossRed,
            ),
          ),
          const SizedBox(width: 4),
          SizedBox(
            width: 100,
            child: MetricCard(
              label: "Trades",
              value: tradeCount.toString(),
            ),
          ),
          const SizedBox(width: 4),
          SizedBox(
            width: 110,
            child: MetricCard(
              label: "Win Rate",
              value: "${winRate.toStringAsFixed(2)}%",
              valueColor: winRate >= 50 ? AppColors.profitGreen : AppColors.warningYellow,
            ),
          ),
          const SizedBox(width: 4),
          SizedBox(
            width: 110,
            child: MetricCard(
              label: "Drawdown",
              value: "${drawdown.toStringAsFixed(2)}%",
              valueColor: _getDrawdownColor(drawdown),
            ),
          ),
        ],
      ),
    );
  }

  Color _getDrawdownColor(double dd) {
    if (dd > 3.0) return AppColors.sellRed;
    if (dd > 2.0) return AppColors.warningYellow;
    return AppColors.profitGreen;
  }
}
