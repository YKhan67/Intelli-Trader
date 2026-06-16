import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forex_ai_frontend/state/providers.dart';
import 'package:forex_ai_frontend/widgets/trade_tile.dart';

class TradeHistoryScreen extends ConsumerWidget {
  const TradeHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(tradeHistoryProvider());

    return Scaffold(
      appBar: AppBar(title: const Text("Trade History")),
      body: history.when(
        data: (trades) => ListView.separated(
          itemCount: trades.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, index) => TradeTile(trade: trades[index]),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),
      ),
    );
  }
}
