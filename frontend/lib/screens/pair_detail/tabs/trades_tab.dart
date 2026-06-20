import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/models.dart';
import '../../../state/providers.dart';
import '../../../theme/colors.dart';
import '../../../theme/spacing.dart';
import '../../../widgets/trade_tile.dart';

class TradesTab extends ConsumerWidget {
  final CurrencyPair pair;
  const TradesTab({super.key, required this.pair});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(tradeHistoryProvider);
    final filteredHistory = historyAsync.whenData((trades) => 
        trades.where((t) => t.pair == pair).toList());

    return filteredHistory.when(
      data: (trades) {
        if (trades.isEmpty) return const Center(child: Text("No trade history for this pair."));
        
        return Column(
          children: [
            _buildMetricsHeader(trades),
            Expanded(
              child: ListView.builder(
                itemCount: trades.length,
                itemBuilder: (context, index) => TradeTile(trade: trades[index]),
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text("Error: $e")),
    );
  }

  Widget _buildMetricsHeader(List<TradeRecord> trades) {
    final wins = trades.where((t) => (t.netProfitLoss ?? 0) > 0).length;
    final winRate = (wins / trades.length) * 100;
    final totalPips = trades.fold(0.0, (sum, t) => sum + (t.pipsResult ?? 0));
    final avgPips = totalPips / trades.length;
    final best = trades.map((t) => t.pipsResult ?? 0).reduce((a, b) => a > b ? a : b);
    final worst = trades.map((t) => t.pipsResult ?? 0).reduce((a, b) => a < b ? a : b);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      color: AppColors.backgroundCard,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildMetric("Win Rate", "${winRate.toStringAsFixed(1)}%"),
          _buildMetric("Avg Pips", avgPips.toStringAsFixed(1)),
          _buildMetric("Best", best.toStringAsFixed(1)),
          _buildMetric("Worst", worst.toStringAsFixed(1)),
        ],
      ),
    );
  }

  Widget _buildMetric(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
