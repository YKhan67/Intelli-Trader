import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'services_provider.dart';
import '../models/models.dart';

import 'package:forex_ai_frontend/state/connection_provider.dart';
import 'package:forex_ai_frontend/utils/logger.dart';

part 'trade_provider.g.dart';

@Riverpod(keepAlive: true)
Stream<List<OpenTrade>> openTrades(OpenTradesRef ref) async* {
  final broker = ref.watch(brokerServiceProvider);
  final connection = ref.watch(brokerConnectionProvider);
  
  if (connection.status != ConnectionStatus.connected || broker.activeBroker == null) {
    yield [];
  } else {
    while (true) {
      try {
        final trades = await broker.getActiveTrades();
        yield trades;
      } catch (e) {
        logger.e('OpenTradesProvider Error: $e');
        ref.read(brokerConnectionProvider.notifier).notifyFailure();
        yield [];
      }
      await Future.delayed(const Duration(seconds: 5));
    }
  }
}

@riverpod
Future<List<TradeRecord>> tradeHistory(TradeHistoryRef ref, {
  DateTime? dateFrom,
  DateTime? dateTo,
  String? pair,
  String? strategy,
}) async {
  final api = ref.watch(backendServiceProvider);
  return api.getTradeHistory(
    dateFrom: dateFrom,
    dateTo: dateTo,
    pair: pair,
    strategy: strategy,
  );
}

@riverpod
class RefreshTrades extends _$RefreshTrades {
  @override
  void build() {}

  void refresh() {
    ref.invalidate(openTradesProvider);
  }
}
