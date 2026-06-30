import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:share_plus/share_plus.dart';
import '../../models/models.dart';
import '../../state/providers.dart';
import '../../state/trade_history_filter_provider.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../widgets/trade_tile.dart';

class TradeHistoryScreen extends ConsumerWidget {
  const TradeHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredTradesAsync = ref.watch(filteredTradeHistoryProvider);
    final summary = ref.watch(tradeHistorySummaryProvider);
    final filters = ref.watch(tradeHistoryFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Trade History"),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () => _exportToCSV(context, filteredTradesAsync.value ?? []),
            tooltip: "Export CSV",
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterBar(context, ref, filters),
          _buildSummaryRow(summary),
          const Divider(height: 1),
          Expanded(
            child: filteredTradesAsync.when(
              data: (trades) => trades.isEmpty 
                ? const Center(child: Text("No trades found matching filters"))
                : ListView.builder(
                    itemCount: trades.length + 1,
                    itemBuilder: (context, index) {
                      if (index == trades.length) {
                        return _buildLoadMoreButton(ref);
                      }
                      return _HistoryTradeTile(trade: trades[index]);
                    },
                  ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text("Error: $e")),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar(BuildContext context, WidgetRef ref, TradeFilters filters) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      color: AppColors.backgroundCard,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            // Date Range
            _FilterChip(
              label: filters.dateRange == null 
                ? "Date Range" 
                : "${DateFormat('MM/dd').format(filters.dateRange!.start)} - ${DateFormat('MM/dd').format(filters.dateRange!.end)}",
              onTap: () async {
                final range = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (range != null) {
                  ref.read(tradeHistoryFilterProvider.notifier).state = filters.copyWith(dateRange: range);
                }
              },
              isActive: filters.dateRange != null,
            ),
            const SizedBox(width: 8),
            // Pair Dropdown
            _buildDropdown<CurrencyPair>(
              value: filters.pair,
              hint: "All Pairs",
              items: CurrencyPair.values.where((p) => p != CurrencyPair.unknown).toList(),
              onChanged: (val) => ref.read(tradeHistoryFilterProvider.notifier).state = 
                  filters.copyWith(pair: val, clearPair: val == null),
              labelBuilder: (p) => p.displayName,
            ),
            const SizedBox(width: 8),
            // Strategy Dropdown
            _buildDropdown<Strategy>(
              value: filters.strategy,
              hint: "All Strategies",
              items: Strategy.values,
              onChanged: (val) => ref.read(tradeHistoryFilterProvider.notifier).state = 
                  filters.copyWith(strategy: val, clearStrategy: val == null),
              labelBuilder: (s) => s.displayName,
            ),
            const SizedBox(width: 8),
            // Type Toggle
            SegmentedButton<TradeType?>(
              segments: const [
                ButtonSegment(value: null, label: Text("Both", style: TextStyle(fontSize: 10))),
                ButtonSegment(value: TradeType.paper, label: Text("Paper", style: TextStyle(fontSize: 10))),
                ButtonSegment(value: TradeType.live, label: Text("Live", style: TextStyle(fontSize: 10))),
              ],
              selected: {filters.tradeType},
              onSelectionChanged: (val) => ref.read(tradeHistoryFilterProvider.notifier).state = 
                  filters.copyWith(tradeType: val.first, clearType: val.first == null),
              showSelectedIcon: false,
              style: const ButtonStyle(visualDensity: VisualDensity.compact),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(TradeHistorySummary summary) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      color: AppColors.backgroundDark,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _SummaryItem(label: "Trades", value: summary.count.toString()),
          _SummaryItem(
            label: "Net P&L", 
            value: "${summary.netPnL >= 0 ? '+' : ''}\$${summary.netPnL.toStringAsFixed(2)}",
            color: summary.netPnL >= 0 ? AppColors.profitGreen : AppColors.lossRed,
          ),
          _SummaryItem(
            label: "Win Rate", 
            value: "${summary.winRate.toStringAsFixed(1)}%",
            color: summary.winRate >= 50 ? AppColors.profitGreen : AppColors.warningYellow,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadMoreButton(WidgetRef ref) {
    final notifier = ref.watch(tradeHistoryNotifierProvider.notifier);
    final hasMore = notifier.hasMore;
    final isLoading = notifier.isLoadingMore;

    if (!hasMore) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: OutlinedButton(
        onPressed: isLoading ? null : () => ref.read(tradeHistoryNotifierProvider.notifier).loadMore(),
        child: isLoading 
          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
          : const Text("Load More Trades"),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required T? value,
    required String hint,
    required List<T> items,
    required Function(T?) onChanged,
    required String Function(T) labelBuilder,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.backgroundElevated,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: DropdownButton<T>(
        value: value,
        hint: Text(hint, style: const TextStyle(fontSize: 12)),
        underline: const SizedBox(),
        items: [
          DropdownMenuItem<T>(value: null, child: Text("All", style: const TextStyle(fontSize: 12))),
          ...items.map((i) => DropdownMenuItem<T>(value: i, child: Text(labelBuilder(i), style: const TextStyle(fontSize: 12)))),
        ],
        onChanged: onChanged,
      ),
    );
  }

  Future<void> _exportToCSV(BuildContext context, List<TradeRecord> trades) async {
    if (trades.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No trades to export")),
      );
      return;
    }

    try {
      final List<List<dynamic>> rows = [];
      
      // Header
      rows.add([
        "UUID", "Pair", "Direction", "Strategy", "Entry Price", "Exit Price", 
        "Entry Time", "Exit Time", "Lots", "Pips", "PnL", "Status", "Type"
      ]);

      // Data Rows
      for (var t in trades) {
        rows.add([
          t.tradeUuid,
          t.pair.displayName,
          t.direction.name.toUpperCase(),
          t.strategy.displayName,
          t.entryPrice?.toStringAsFixed(5) ?? "",
          t.exitPrice?.toStringAsFixed(5) ?? "",
          t.entryTime?.toIso8601String() ?? "",
          t.exitTime?.toIso8601String() ?? "",
          t.lotSize?.toStringAsFixed(2) ?? "",
          t.pipsResult?.toStringAsFixed(1) ?? "",
          t.netProfitLoss?.toStringAsFixed(2) ?? "",
          t.status.name.toUpperCase(),
          t.tradeType.name.toUpperCase(),
        ]);
      }

      String csvData = const ListToCsvConverter().convert(rows);
      
      final directory = await getTemporaryDirectory();
      final String path = "${directory.path}/trade_history_${DateTime.now().millisecondsSinceEpoch}.csv";
      final File file = File(path);
      await file.writeAsString(csvData);

      final result = await Share.shareXFiles([XFile(path)], text: 'ForexAI Trade History Export');

      if (result.status == ShareResultStatus.success) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("CSV Exported Successfully")),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Export failed: $e"), backgroundColor: AppColors.sellRed),
        );
      }
    }
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isActive;

  const _FilterChip({required this.label, required this.onTap, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(label, style: const TextStyle(fontSize: 10)),
      onPressed: onTap,
      backgroundColor: isActive ? AppColors.accentBlue.withOpacity(0.2) : null,
      side: BorderSide(color: isActive ? AppColors.accentBlue : AppColors.borderColor),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;
  const _SummaryItem({required this.label, required this.value, this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
        Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }
}

class _HistoryTradeTile extends StatelessWidget {
  final TradeRecord trade;
  const _HistoryTradeTile({required this.trade});

  @override
  Widget build(BuildContext context) {
    final bool isWin = (trade.pipsResult ?? 0) > 0;
    final color = isWin ? AppColors.profitGreen : AppColors.lossRed;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 4),
      child: Material(
        color: color.withOpacity(0.05),
        clipBehavior: Clip.antiAlias,
        child: Container(
          decoration: BoxDecoration(
            border: Border(left: BorderSide(color: color, width: 4)),
          ),
          child: ListTile(
            onTap: () => _showDetail(context, trade),
            dense: true,
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  trade.direction == Direction.long ? Icons.arrow_upward : Icons.arrow_downward,
                  color: color,
                  size: 16,
                ),
                Text(trade.pair.displayName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            ),
            title: Row(
              children: [
                _Badge(label: trade.strategy.displayName, color: AppColors.primaryBlue),
                const SizedBox(width: 4),
                _Badge(label: trade.timeframe.displayName, color: AppColors.accentBlue),
              ],
            ),
            subtitle: Text(
              "${DateFormat('MMM dd, HH:mm').format(trade.entryTime ?? DateTime.now())} • ${trade.durationString}",
              style: const TextStyle(fontSize: 10),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "${isWin ? '+' : ''}${trade.pipsResult?.toStringAsFixed(1)} Pips",
                  style: TextStyle(fontWeight: FontWeight.bold, color: color),
                ),
                Text(
                  "${trade.netProfitLoss?.toStringAsFixed(2)} ${trade.pair.name.contains('usd') ? 'USD' : ''}",
                  style: const TextStyle(fontSize: 10),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDetail(BuildContext context, TradeRecord trade) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _TradeDetailSheet(trade: trade),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(label, style: TextStyle(fontSize: 8, color: color, fontWeight: FontWeight.bold)),
    );
  }
}

class _TradeDetailSheet extends StatelessWidget {
  final TradeRecord trade;
  const _TradeDetailSheet({required this.trade});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Trade Details", style: Theme.of(context).textTheme.headlineSmall),
          const Divider(),
          _DetailRow(label: "Regime at Entry", value: trade.regimeAtEntry.displayName),
          _DetailRow(label: "Sentiment at Entry", value: trade.sentimentAtEntry.toStringAsFixed(2)),
          _DetailRow(label: "AI Confidence", value: "${(trade.confidenceAtEntry * 100).toInt()}%"),
          _DetailRow(label: "Entry Price", value: trade.entryPrice?.toStringAsFixed(5) ?? "-"),
          _DetailRow(label: "Exit Price", value: trade.exitPrice?.toStringAsFixed(5) ?? "-"),
          _DetailRow(label: "Stop Loss", value: trade.stopLoss?.toStringAsFixed(5) ?? "-"),
          _DetailRow(label: "Take Profit", value: trade.takeProfit?.toStringAsFixed(5) ?? "-"),
          _DetailRow(label: "Exit Reason", value: trade.exitReason?.displayName ?? "Unknown"),
          const Divider(),
          _DetailRow(label: "Commission", value: "-\$${trade.commission.toStringAsFixed(2)}", color: Colors.red),
          _DetailRow(label: "Swap", value: "${trade.swap >= 0 ? '+' : ''}\$${trade.swap.toStringAsFixed(2)}"),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;
  const _DetailRow({required this.label, required this.value, this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textMuted)),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}
