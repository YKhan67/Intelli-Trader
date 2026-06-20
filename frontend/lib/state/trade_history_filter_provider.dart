import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import 'trade_provider.dart';

class TradeFilters {
  final DateTimeRange? dateRange;
  final CurrencyPair? pair;
  final Strategy? strategy;
  final TradeType? tradeType;

  TradeFilters({
    this.dateRange,
    this.pair,
    this.strategy,
    this.tradeType,
  });

  TradeFilters copyWith({
    DateTimeRange? dateRange,
    CurrencyPair? pair,
    Strategy? strategy,
    TradeType? tradeType,
    bool clearPair = false,
    bool clearStrategy = false,
    bool clearType = false,
  }) {
    return TradeFilters(
      dateRange: dateRange ?? this.dateRange,
      pair: clearPair ? null : (pair ?? this.pair),
      strategy: clearStrategy ? null : (strategy ?? this.strategy),
      tradeType: clearType ? null : (tradeType ?? this.tradeType),
    );
  }
}

final tradeHistoryFilterProvider = StateProvider<TradeFilters>((ref) => TradeFilters());

final filteredTradeHistoryProvider = Provider<AsyncValue<List<TradeRecord>>>((ref) {
  final historyAsync = ref.watch(tradeHistoryProvider);
  final filters = ref.watch(tradeHistoryFilterProvider);

  return historyAsync.whenData((trades) {
    return trades.where((t) {
      if (filters.pair != null && t.pair != filters.pair) return false;
      if (filters.strategy != null && t.strategy != filters.strategy) return false;
      if (filters.tradeType != null && t.tradeType != filters.tradeType) return false;
      if (filters.dateRange != null) {
        if (t.entryTime == null) return false;
        if (t.entryTime!.isBefore(filters.dateRange!.start) || 
            t.entryTime!.isAfter(filters.dateRange!.end.add(const Duration(days: 1)))) {
          return false;
        }
      }
      return true;
    }).toList();
  });
});

class TradeHistorySummary {
  final int count;
  final double netPnL;
  final double winRate;

  TradeHistorySummary({required this.count, required this.netPnL, required this.winRate});
}

final tradeHistorySummaryProvider = Provider<TradeHistorySummary>((ref) {
  final trades = ref.watch(filteredTradeHistoryProvider).value ?? [];
  if (trades.isEmpty) return TradeHistorySummary(count: 0, netPnL: 0, winRate: 0);

  final netPnL = trades.fold<double>(0, (sum, t) => sum + (t.netProfitLoss ?? 0));
  final wins = trades.where((t) => (t.pipsResult ?? 0) > 0).length;
  final winRate = (wins / trades.length) * 100;

  return TradeHistorySummary(
    count: trades.length,
    netPnL: netPnL,
    winRate: winRate,
  );
});
