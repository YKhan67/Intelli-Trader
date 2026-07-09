import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'core_services.dart';
import '../models/models.dart';
import 'connection_provider.dart';
import '../utils/logger.dart';

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

@Riverpod(keepAlive: true)
class TradeHistoryNotifier extends _$TradeHistoryNotifier {
  int _currentPage = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  @override
  Future<List<TradeRecord>> build() async {
    _currentPage = 1;
    _hasMore = true;
    return _fetchTrades();
  }

  Future<List<TradeRecord>> _fetchTrades() async {
    final api = ref.read(backendServiceProvider);
    return await api.getTradeHistory(page: _currentPage, size: 50);
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMore) return;
    
    _isLoadingMore = true;
    _currentPage++;
    
    try {
      final newTrades = await _fetchTrades();
      if (newTrades.isEmpty) {
        _hasMore = false;
      } else {
        final currentTrades = state.value ?? [];
        state = AsyncValue.data([...currentTrades, ...newTrades]);
      }
    } catch (e) {
      _currentPage--;
      logger.e("Error loading more trades: $e");
    } finally {
      _isLoadingMore = false;
    }
  }

  bool get hasMore => _hasMore;
  bool get isLoadingMore => _isLoadingMore;
}

// Keep the old provider as a compatibility alias if needed, or update consumers
final tradeHistoryProvider = Provider((ref) => ref.watch(tradeHistoryNotifierProvider));
