import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/models.dart';
import 'tabs/chart_tab.dart';
import 'tabs/signal_tab.dart';
import 'tabs/analysis_tab.dart';
import 'tabs/trades_tab.dart';
import 'tabs/news_tab.dart';

class PairDetailScreen extends ConsumerWidget {
  final String symbol;

  const PairDetailScreen({super.key, required this.symbol});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pair = CurrencyPair.values.firstWhere(
      (e) => e.name == symbol.toLowerCase() || e.displayName == symbol.toUpperCase(),
      orElse: () => CurrencyPair.unknown,
    );

    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: Text(pair.displayName),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: "Chart"),
              Tab(text: "Signal"),
              Tab(text: "Analysis"),
              Tab(text: "Trades"),
              Tab(text: "News"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ChartTab(pair: pair),
            SignalTab(pair: pair),
            AnalysisTab(pair: pair),
            TradesTab(pair: pair),
            NewsTab(pair: pair),
          ],
        ),
      ),
    );
  }
}
