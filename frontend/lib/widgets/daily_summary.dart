import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/providers.dart';
import '../theme/colors.dart';
import '../theme/spacing.dart';

class DailySummaryBar extends ConsumerWidget {
  const DailySummaryBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dailySummary = ref.watch(dailySummaryProvider);
    
    if (dailySummary == null) {
      return const SizedBox(height: 50); 
    }

    final double pnl = dailySummary.netPnl;
    final int tradeCount = dailySummary.totalTrades;
    final double winRate = dailySummary.winRate;
    final double drawdown = dailySummary.maxDrawdown;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
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
