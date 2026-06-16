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
