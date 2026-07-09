import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core_services.dart';
import '../models/models.dart';
import 'engine_provider.dart';

/// Notifier for Pair-Specific Risk Settings.
/// Manages a map of pair names to their specific R:R and Risk % overrides.
class PairRiskSettingsNotifier extends Notifier<Map<String, Map<String, double>>> {
  @override
  Map<String, Map<String, double>> build() {
    final storage = ref.watch(storageServiceProvider);
    final savedSettings = storage.getPairRisk();
    
    // Initial defaults for all pairs defined in CurrencyPair enum
    final Map<String, Map<String, double>> currentSettings = {};
    for (var pair in CurrencyPair.values) {
      if (pair != CurrencyPair.unknown) {
        // Use saved setting if it exists, otherwise use default
        currentSettings[pair.name] = savedSettings[pair.name] ?? {
          'min_rr': 1.5,
          'max_risk': 0.01,
        };
      }
    }
    return currentSettings;
  }

  /// Updates a specific setting for a specific pair and triggers state refresh.
  void updatePair(String pairName, String key, double value) {
    final currentPairSettings = state[pairName] ?? {'min_rr': 1.5, 'max_risk': 0.01};
    state = {
      ...state,
      pairName: {
        ...currentPairSettings,
        key: value,
      }
    };
    
    // Save to local disk immediately
    ref.read(storageServiceProvider).savePairRisk(state);
  }

  /// Synchronizes the current risk matrix to the backend Redis cluster.
  Future<void> syncToBackend() async {
    final api = ref.read(backendServiceProvider);
    final mode = ref.read(tradingModeStateProvider);
    final pairs = ref.read(activePairsStateProvider);
    
    try {
      await api.postSettings(mode, pairs, {'pair_risk': state});
    } catch (e) {
      // Logged by BackendService
    }
  }
}

/// Global provider for pair-specific risk settings.
final pairRiskSettingsProvider = NotifierProvider<PairRiskSettingsNotifier, Map<String, Map<String, double>>>(() {
  return PairRiskSettingsNotifier();
});
