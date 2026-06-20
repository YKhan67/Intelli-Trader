import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'services_provider.dart';
import '../models/models.dart';

part 'engine_provider.g.dart';

@Riverpod(keepAlive: true)
class EngineState extends _$EngineState {
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

@Riverpod(keepAlive: true)
class TradingModeState extends _$TradingModeState {
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

@Riverpod(keepAlive: true)
class ActivePairsState extends _$ActivePairsState {
  @override
  List<CurrencyPair> build() {
    final storage = ref.watch(storageServiceProvider);
    return storage.getActivePairs();
  }

  Future<void> setPairs(List<CurrencyPair> pairs) async {
    final storage = ref.read(storageServiceProvider);
    await storage.saveActivePairs(pairs);
    state = pairs;
  }
}

@Riverpod(keepAlive: true)
class RiskSettingsState extends _$RiskSettingsState {
  @override
  Map<String, double> build() {
    // Default values
    return {
      'min_rr_ratio': 1.5,
      'max_risk_per_trade': 0.01,
    };
  }

  void update(String key, double value) {
    state = {...state, key: value};
  }
}
