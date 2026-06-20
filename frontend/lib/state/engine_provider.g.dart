// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'engine_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$engineStateHash() => r'8e04432bb60a0a3191dca94241a1ab6dd93e266f';

/// See also [EngineState].
@ProviderFor(EngineState)
final engineStateProvider = NotifierProvider<EngineState, bool>.internal(
  EngineState.new,
  name: r'engineStateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$engineStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$EngineState = Notifier<bool>;
String _$tradingModeStateHash() => r'304f82c1a6a1d2c44f8a36a7223e3b3c4928f1df';

/// See also [TradingModeState].
@ProviderFor(TradingModeState)
final tradingModeStateProvider =
    NotifierProvider<TradingModeState, TradingMode>.internal(
  TradingModeState.new,
  name: r'tradingModeStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$tradingModeStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TradingModeState = Notifier<TradingMode>;
String _$activePairsStateHash() => r'36698569accc5a0f4e859b641c9469feef39225a';

/// See also [ActivePairsState].
@ProviderFor(ActivePairsState)
final activePairsStateProvider =
    NotifierProvider<ActivePairsState, List<CurrencyPair>>.internal(
  ActivePairsState.new,
  name: r'activePairsStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$activePairsStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ActivePairsState = Notifier<List<CurrencyPair>>;
String _$riskSettingsStateHash() => r'f0ad9752ec275ae1e00a7b8e4889075c37e0f6e3';

/// See also [RiskSettingsState].
@ProviderFor(RiskSettingsState)
final riskSettingsStateProvider =
    NotifierProvider<RiskSettingsState, Map<String, double>>.internal(
  RiskSettingsState.new,
  name: r'riskSettingsStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$riskSettingsStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$RiskSettingsState = Notifier<Map<String, double>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
