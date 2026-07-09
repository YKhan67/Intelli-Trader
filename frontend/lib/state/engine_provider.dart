import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core_services.dart';
import '../models/models.dart';

/// Manages the Global Engine Start/Stop state.
class EngineStateNotifier extends Notifier<bool> {
  @override
  bool build() {
    final storage = ref.watch(storageServiceProvider);
    return storage.getEngineState();
  }

  Future<void> toggle(bool running) async {
    final storage = ref.read(storageServiceProvider);
    await storage.saveEngineState(running);
    state = running;
  }
}

final engineStateProvider = NotifierProvider<EngineStateNotifier, bool>(() => EngineStateNotifier());

/// Manages the Trading Mode (Paper, Live, Seeded).
class TradingModeStateNotifier extends Notifier<TradingMode> {
  @override
  TradingMode build() {
    final storage = ref.watch(storageServiceProvider);
    return storage.getTradingMode();
  }

  Future<void> setMode(TradingMode mode) async {
    final storage = ref.read(storageServiceProvider);
    await storage.saveTradingMode(mode);
    state = mode;
  }
}

final tradingModeStateProvider = NotifierProvider<TradingModeStateNotifier, TradingMode>(() => TradingModeStateNotifier());

/// Manages the list of Active Trading Pairs.
class ActivePairsStateNotifier extends Notifier<List<CurrencyPair>> {
  @override
  List<CurrencyPair> build() {
    final storage = ref.watch(storageServiceProvider);
    final active = storage.getActivePairs();
    
    // MIGRATION LOGIC: Ensure BTCEUR is added if it's missing from existing settings
    if (!active.contains(CurrencyPair.btceur)) {
      final updated = [...active, CurrencyPair.btceur];
      storage.saveActivePairs(updated);
      return updated;
    }
    
    return active;
  }

  Future<void> setPairs(List<CurrencyPair> pairs) async {
    final storage = ref.read(storageServiceProvider);
    await storage.saveActivePairs(pairs);
    state = pairs;
  }
}

final activePairsStateProvider = NotifierProvider<ActivePairsStateNotifier, List<CurrencyPair>>(() => ActivePairsStateNotifier());

/// Manages Global Risk Settings (Legacy/Fallback).
class RiskSettingsStateNotifier extends Notifier<Map<String, double>> {
  @override
  Map<String, double> build() {
    return {
      'min_rr_ratio': 1.5,
      'max_risk_per_trade': 0.01,
    };
  }

  void update(String key, double value) {
    state = {...state, key: value};
  }
}

final riskSettingsStateProvider = NotifierProvider<RiskSettingsStateNotifier, Map<String, double>>(() => RiskSettingsStateNotifier());
