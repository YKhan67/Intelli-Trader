import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:forex_ai_frontend/state/providers.dart';
import 'package:forex_ai_frontend/theme/colors.dart';
import 'package:forex_ai_frontend/theme/spacing.dart';
import 'package:forex_ai_frontend/models/models.dart';

class OpenTradesPanel extends ConsumerWidget {
  const OpenTradesPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tradesAsync = ref.watch(openTradesProvider);

    return tradesAsync.when(
      data: (trades) {
        if (trades.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(AppSpacing.xl),
            child: Center(child: Text("No active trades found", style: TextStyle(color: AppColors.textMuted))),
          );
        }

        final totalPnl = trades.fold(0.0, (sum, t) => sum + t.currentPnl);
        
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("OPEN TRADES (${trades.length})", style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                    "${totalPnl >= 0 ? '+' : ''}${totalPnl.toStringAsFixed(2)} USD",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: totalPnl >= 0 ? AppColors.profitGreen : AppColors.lossRed,
                    ),
                  ),
                ],
              ),
            ),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: trades.length,
              separatorBuilder: (_, __) => const Divider(height: 1, indent: AppSpacing.md),
              itemBuilder: (context, index) => _TradeRow(trade: trades[index]),
            ),
          ],
        );
      },
      loading: () => const Center(child: Padding(padding: EdgeInsets.all(AppSpacing.xl), child: CircularProgressIndicator())),
      error: (e, _) => Center(child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Text("Sync Error: $e", style: const TextStyle(color: AppColors.sellRed, fontSize: 10)),
      )),
    );
  }
}

class _TradeRow extends StatelessWidget {
  final OpenTrade trade;
  const _TradeRow({required this.trade});

  @override
  Widget build(BuildContext context) {
    final bool isLong = trade.direction == Direction.long;
    
    return ListTile(
      onTap: () => _showTradeDetail(context, trade),
      leading: Icon(
        isLong ? Icons.arrow_upward : Icons.arrow_downward,
        color: isLong ? AppColors.buyGreen : AppColors.sellRed,
        size: 20,
      ),
      title: Row(
        children: [
          Text(trade.pair.displayName, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Text("${trade.lotSize} Lots", style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
        ],
      ),
      subtitle: Row(
        children: [
          Text(trade.entryPrice.toStringAsFixed(5), style: const TextStyle(fontSize: 12)),
          const Icon(Icons.chevron_right, size: 12, color: AppColors.textMuted),
          Text(trade.currentPrice.toStringAsFixed(5), style: const TextStyle(fontSize: 12, color: AppColors.textPrimary)),
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            "${trade.currentPips >= 0 ? '+' : ''}${trade.currentPips.toStringAsFixed(1)} pips",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: trade.currentPnl >= 0 ? AppColors.profitGreen : AppColors.lossRed,
            ),
          ),
          Text(
            "${trade.currentPnl >= 0 ? '+' : ''}${trade.currentPnl.toStringAsFixed(2)} USD",
            style: TextStyle(fontSize: 10, color: trade.currentPnl >= 0 ? AppColors.profitGreen : AppColors.lossRed),
          ),
        ],
      ),
    );
  }

  void _showTradeDetail(BuildContext context, OpenTrade trade) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.backgroundCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusCard)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Trade Detail: ${trade.pair.displayName}", style: Theme.of(context).textTheme.headlineSmall),
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
              ],
            ),
            const Divider(),
            _DetailItem(label: "Ticket ID", value: trade.brokerTicketId),
            _DetailItem(label: "Direction", value: trade.direction.name.toUpperCase(), color: trade.direction == Direction.long ? AppColors.buyGreen : AppColors.sellRed),
            _DetailItem(label: "Lots", value: trade.lotSize.toString()),
            _DetailItem(label: "Stop Loss", value: (trade.stopLoss ?? 0.0).toStringAsFixed(5), color: AppColors.sellRed),
            _DetailItem(label: "Take Profit", value: (trade.takeProfit ?? 0.0).toStringAsFixed(5), color: AppColors.profitGreen),
            _DetailItem(label: "Open Time", value: DateFormat('yyyy-MM-dd HH:mm').format(trade.openTime.toLocal())),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.sellRed),
                child: const Text("CLOSE TRADE IMMEDIATELY"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;
  const _DetailItem({required this.label, required this.value, this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary)),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}
