import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'services_provider.dart';
import '../models/models.dart';

part 'signal_provider.g.dart';

@riverpod
Stream<BackendSignal> signal(SignalRef ref, CurrencyPair pair) {
  final ws = ref.watch(webSocketServiceProvider);
  return ws.signalStream.where((s) => s.pair == pair);
}

@Riverpod(keepAlive: true)
class SelectedTimeframe extends _$SelectedTimeframe {
  @override
  Timeframe build() => Timeframe.h1;

  void set(Timeframe tf) => state = tf;
}

@Riverpod(keepAlive: true)
Stream<Map<CurrencyPair, BackendSignal>> allSignals(AllSignalsRef ref) async* {
  final ws = ref.watch(webSocketServiceProvider);
  final api = ref.watch(backendServiceProvider);
  final timeframe = ref.watch(selectedTimeframeProvider);
  
  final Map<CurrencyPair, BackendSignal> latestSignals = {};
  
  // 1. Initial fetch from REST for immediate display
  try {
    final initialSignals = await api.getAllSignals(timeframe: timeframe.name.toUpperCase());
    for (final sig in initialSignals) {
      latestSignals[sig.pair] = sig;
    }
    yield Map.from(latestSignals);
  } catch (e) {
    yield {};
  }

  // 2. Listen to WebSocket for real-time updates
  await for (final signal in ws.signalStream) {
    latestSignals[signal.pair] = signal;
    yield Map.from(latestSignals);
  }
}

@riverpod
BackendSignal? latestSignal(LatestSignalRef ref, CurrencyPair pair) {
  final all = ref.watch(allSignalsProvider).value ?? {};
  return all[pair];
}
