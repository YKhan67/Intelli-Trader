// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trade_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$openTradesHash() => r'05aadecfcd9a1bc74e2100bd58c418f597470f57';

/// See also [openTrades].
@ProviderFor(openTrades)
final openTradesProvider = StreamProvider<List<OpenTrade>>.internal(
  openTrades,
  name: r'openTradesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$openTradesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef OpenTradesRef = StreamProviderRef<List<OpenTrade>>;
String _$tradeHistoryNotifierHash() =>
    r'9309e0d2beb744cc12c919962c6d6aadab1069f0';

/// See also [TradeHistoryNotifier].
@ProviderFor(TradeHistoryNotifier)
final tradeHistoryNotifierProvider =
    AsyncNotifierProvider<TradeHistoryNotifier, List<TradeRecord>>.internal(
  TradeHistoryNotifier.new,
  name: r'tradeHistoryNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$tradeHistoryNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TradeHistoryNotifier = AsyncNotifier<List<TradeRecord>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
