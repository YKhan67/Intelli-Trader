import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/providers.dart';
import '../theme/colors.dart';
import '../theme/spacing.dart';

class DailySummaryBar extends ConsumerWidget {
  const DailySummaryBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final perf = ref.watch(performanceProvider).value;
    
    if (perf == null) {
      return const SizedBox(height: 50); 
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
          _MetricTile(
            label: "Today P&L",
            value: "${pnl >= 0 ? '+' : ''}\$${pnl.toStringAsFixed(2)}",
            valueColor: pnl >= 0 ? AppColors.profitGreen : AppColors.lossRed,
          ),
          _MetricTile(
            label: "Trades",
            value: tradeCount.toString(),
          ),
          _MetricTile(
            label: "Win Rate",
            value: "${winRate.toStringAsFixed(1)}%",
            valueColor: winRate >= 50 ? AppColors.profitGreen : AppColors.warningYellow,
          ),
          _MetricTile(
            label: "Drawdown",
            value: "${drawdown.toStringAsFixed(1)}%",
            valueColor: _getDrawdownColor(drawdown),
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

class _MetricTile extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _MetricTile({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      margin: const EdgeInsets.only(right: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: valueColor ?? AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
