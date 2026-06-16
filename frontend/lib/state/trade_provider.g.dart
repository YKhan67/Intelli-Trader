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
String _$tradeHistoryHash() => r'c977d645ecf929b79c8746deec2a79bd876c8f05';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [tradeHistory].
@ProviderFor(tradeHistory)
const tradeHistoryProvider = TradeHistoryFamily();

/// See also [tradeHistory].
class TradeHistoryFamily extends Family<AsyncValue<List<TradeRecord>>> {
  /// See also [tradeHistory].
  const TradeHistoryFamily();

  /// See also [tradeHistory].
  TradeHistoryProvider call({
    DateTime? dateFrom,
    DateTime? dateTo,
    String? pair,
    String? strategy,
  }) {
    return TradeHistoryProvider(
      dateFrom: dateFrom,
      dateTo: dateTo,
      pair: pair,
      strategy: strategy,
    );
  }

  @override
  TradeHistoryProvider getProviderOverride(
    covariant TradeHistoryProvider provider,
  ) {
    return call(
      dateFrom: provider.dateFrom,
      dateTo: provider.dateTo,
      pair: provider.pair,
      strategy: provider.strategy,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'tradeHistoryProvider';
}

/// See also [tradeHistory].
class TradeHistoryProvider
    extends AutoDisposeFutureProvider<List<TradeRecord>> {
  /// See also [tradeHistory].
  TradeHistoryProvider({
    DateTime? dateFrom,
    DateTime? dateTo,
    String? pair,
    String? strategy,
  }) : this._internal(
          (ref) => tradeHistory(
            ref as TradeHistoryRef,
            dateFrom: dateFrom,
            dateTo: dateTo,
            pair: pair,
            strategy: strategy,
          ),
          from: tradeHistoryProvider,
          name: r'tradeHistoryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$tradeHistoryHash,
          dependencies: TradeHistoryFamily._dependencies,
          allTransitiveDependencies:
              TradeHistoryFamily._allTransitiveDependencies,
          dateFrom: dateFrom,
          dateTo: dateTo,
          pair: pair,
          strategy: strategy,
        );

  TradeHistoryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.dateFrom,
    required this.dateTo,
    required this.pair,
    required this.strategy,
  }) : super.internal();

  final DateTime? dateFrom;
  final DateTime? dateTo;
  final String? pair;
  final String? strategy;

  @override
  Override overrideWith(
    FutureOr<List<TradeRecord>> Function(TradeHistoryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TradeHistoryProvider._internal(
        (ref) => create(ref as TradeHistoryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        dateFrom: dateFrom,
        dateTo: dateTo,
        pair: pair,
        strategy: strategy,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<TradeRecord>> createElement() {
    return _TradeHistoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TradeHistoryProvider &&
        other.dateFrom == dateFrom &&
        other.dateTo == dateTo &&
        other.pair == pair &&
        other.strategy == strategy;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, dateFrom.hashCode);
    hash = _SystemHash.combine(hash, dateTo.hashCode);
    hash = _SystemHash.combine(hash, pair.hashCode);
    hash = _SystemHash.combine(hash, strategy.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TradeHistoryRef on AutoDisposeFutureProviderRef<List<TradeRecord>> {
  /// The parameter `dateFrom` of this provider.
  DateTime? get dateFrom;

  /// The parameter `dateTo` of this provider.
  DateTime? get dateTo;

  /// The parameter `pair` of this provider.
  String? get pair;

  /// The parameter `strategy` of this provider.
  String? get strategy;
}

class _TradeHistoryProviderElement
    extends AutoDisposeFutureProviderElement<List<TradeRecord>>
    with TradeHistoryRef {
  _TradeHistoryProviderElement(super.provider);

  @override
  DateTime? get dateFrom => (origin as TradeHistoryProvider).dateFrom;
  @override
  DateTime? get dateTo => (origin as TradeHistoryProvider).dateTo;
  @override
  String? get pair => (origin as TradeHistoryProvider).pair;
  @override
  String? get strategy => (origin as TradeHistoryProvider).strategy;
}

String _$refreshTradesHash() => r'82634030348b8988d504c408883764a1825b3bb4';

/// See also [RefreshTrades].
@ProviderFor(RefreshTrades)
final refreshTradesProvider =
    AutoDisposeNotifierProvider<RefreshTrades, void>.internal(
  RefreshTrades.new,
  name: r'refreshTradesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$refreshTradesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$RefreshTrades = AutoDisposeNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
