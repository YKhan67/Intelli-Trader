// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'market_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$marketHash() => r'dd61ed4204a396f004d12d812f3e8cde126193cc';

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

/// See also [market].
@ProviderFor(market)
const marketProvider = MarketFamily();

/// See also [market].
class MarketFamily extends Family<AsyncValue<Map<String, dynamic>>> {
  /// See also [market].
  const MarketFamily();

  /// See also [market].
  MarketProvider call(
    CurrencyPair pair,
  ) {
    return MarketProvider(
      pair,
    );
  }

  @override
  MarketProvider getProviderOverride(
    covariant MarketProvider provider,
  ) {
    return call(
      provider.pair,
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
  String? get name => r'marketProvider';
}

/// See also [market].
class MarketProvider extends AutoDisposeFutureProvider<Map<String, dynamic>> {
  /// See also [market].
  MarketProvider(
    CurrencyPair pair,
  ) : this._internal(
          (ref) => market(
            ref as MarketRef,
            pair,
          ),
          from: marketProvider,
          name: r'marketProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$marketHash,
          dependencies: MarketFamily._dependencies,
          allTransitiveDependencies: MarketFamily._allTransitiveDependencies,
          pair: pair,
        );

  MarketProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.pair,
  }) : super.internal();

  final CurrencyPair pair;

  @override
  Override overrideWith(
    FutureOr<Map<String, dynamic>> Function(MarketRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MarketProvider._internal(
        (ref) => create(ref as MarketRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        pair: pair,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Map<String, dynamic>> createElement() {
    return _MarketProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MarketProvider && other.pair == pair;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, pair.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MarketRef on AutoDisposeFutureProviderRef<Map<String, dynamic>> {
  /// The parameter `pair` of this provider.
  CurrencyPair get pair;
}

class _MarketProviderElement
    extends AutoDisposeFutureProviderElement<Map<String, dynamic>>
    with MarketRef {
  _MarketProviderElement(super.provider);

  @override
  CurrencyPair get pair => (origin as MarketProvider).pair;
}

String _$ohlcvHash() => r'3c4d2783bf519b5335456a326c8707cd711b8c3c';

/// See also [ohlcv].
@ProviderFor(ohlcv)
const ohlcvProvider = OhlcvFamily();

/// See also [ohlcv].
class OhlcvFamily extends Family<AsyncValue<List<OHLCVBar>>> {
  /// See also [ohlcv].
  const OhlcvFamily();

  /// See also [ohlcv].
  OhlcvProvider call(
    CurrencyPair pair, {
    Timeframe tf = Timeframe.h1,
  }) {
    return OhlcvProvider(
      pair,
      tf: tf,
    );
  }

  @override
  OhlcvProvider getProviderOverride(
    covariant OhlcvProvider provider,
  ) {
    return call(
      provider.pair,
      tf: provider.tf,
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
  String? get name => r'ohlcvProvider';
}

/// See also [ohlcv].
class OhlcvProvider extends AutoDisposeFutureProvider<List<OHLCVBar>> {
  /// See also [ohlcv].
  OhlcvProvider(
    CurrencyPair pair, {
    Timeframe tf = Timeframe.h1,
  }) : this._internal(
          (ref) => ohlcv(
            ref as OhlcvRef,
            pair,
            tf: tf,
          ),
          from: ohlcvProvider,
          name: r'ohlcvProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$ohlcvHash,
          dependencies: OhlcvFamily._dependencies,
          allTransitiveDependencies: OhlcvFamily._allTransitiveDependencies,
          pair: pair,
          tf: tf,
        );

  OhlcvProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.pair,
    required this.tf,
  }) : super.internal();

  final CurrencyPair pair;
  final Timeframe tf;

  @override
  Override overrideWith(
    FutureOr<List<OHLCVBar>> Function(OhlcvRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: OhlcvProvider._internal(
        (ref) => create(ref as OhlcvRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        pair: pair,
        tf: tf,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<OHLCVBar>> createElement() {
    return _OhlcvProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is OhlcvProvider && other.pair == pair && other.tf == tf;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, pair.hashCode);
    hash = _SystemHash.combine(hash, tf.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin OhlcvRef on AutoDisposeFutureProviderRef<List<OHLCVBar>> {
  /// The parameter `pair` of this provider.
  CurrencyPair get pair;

  /// The parameter `tf` of this provider.
  Timeframe get tf;
}

class _OhlcvProviderElement
    extends AutoDisposeFutureProviderElement<List<OHLCVBar>> with OhlcvRef {
  _OhlcvProviderElement(super.provider);

  @override
  CurrencyPair get pair => (origin as OhlcvProvider).pair;
  @override
  Timeframe get tf => (origin as OhlcvProvider).tf;
}

String _$indicatorsHash() => r'f9dd2f3fa322881a3751592a81b95a6bca23f63c';

/// See also [indicators].
@ProviderFor(indicators)
const indicatorsProvider = IndicatorsFamily();

/// See also [indicators].
class IndicatorsFamily extends Family<AsyncValue<List<IndicatorSet>>> {
  /// See also [indicators].
  const IndicatorsFamily();

  /// See also [indicators].
  IndicatorsProvider call(
    CurrencyPair pair, {
    Timeframe tf = Timeframe.h1,
  }) {
    return IndicatorsProvider(
      pair,
      tf: tf,
    );
  }

  @override
  IndicatorsProvider getProviderOverride(
    covariant IndicatorsProvider provider,
  ) {
    return call(
      provider.pair,
      tf: provider.tf,
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
  String? get name => r'indicatorsProvider';
}

/// See also [indicators].
class IndicatorsProvider extends AutoDisposeFutureProvider<List<IndicatorSet>> {
  /// See also [indicators].
  IndicatorsProvider(
    CurrencyPair pair, {
    Timeframe tf = Timeframe.h1,
  }) : this._internal(
          (ref) => indicators(
            ref as IndicatorsRef,
            pair,
            tf: tf,
          ),
          from: indicatorsProvider,
          name: r'indicatorsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$indicatorsHash,
          dependencies: IndicatorsFamily._dependencies,
          allTransitiveDependencies:
              IndicatorsFamily._allTransitiveDependencies,
          pair: pair,
          tf: tf,
        );

  IndicatorsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.pair,
    required this.tf,
  }) : super.internal();

  final CurrencyPair pair;
  final Timeframe tf;

  @override
  Override overrideWith(
    FutureOr<List<IndicatorSet>> Function(IndicatorsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: IndicatorsProvider._internal(
        (ref) => create(ref as IndicatorsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        pair: pair,
        tf: tf,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<IndicatorSet>> createElement() {
    return _IndicatorsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is IndicatorsProvider && other.pair == pair && other.tf == tf;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, pair.hashCode);
    hash = _SystemHash.combine(hash, tf.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin IndicatorsRef on AutoDisposeFutureProviderRef<List<IndicatorSet>> {
  /// The parameter `pair` of this provider.
  CurrencyPair get pair;

  /// The parameter `tf` of this provider.
  Timeframe get tf;
}

class _IndicatorsProviderElement
    extends AutoDisposeFutureProviderElement<List<IndicatorSet>>
    with IndicatorsRef {
  _IndicatorsProviderElement(super.provider);

  @override
  CurrencyPair get pair => (origin as IndicatorsProvider).pair;
  @override
  Timeframe get tf => (origin as IndicatorsProvider).tf;
}

String _$smcZonesHash() => r'10428a99cac312aeee3e742c3ef9b365bd99e375';

/// See also [smcZones].
@ProviderFor(smcZones)
const smcZonesProvider = SmcZonesFamily();

/// See also [smcZones].
class SmcZonesFamily extends Family<AsyncValue<List<SMCZone>>> {
  /// See also [smcZones].
  const SmcZonesFamily();

  /// See also [smcZones].
  SmcZonesProvider call(
    CurrencyPair pair, {
    Timeframe tf = Timeframe.h1,
  }) {
    return SmcZonesProvider(
      pair,
      tf: tf,
    );
  }

  @override
  SmcZonesProvider getProviderOverride(
    covariant SmcZonesProvider provider,
  ) {
    return call(
      provider.pair,
      tf: provider.tf,
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
  String? get name => r'smcZonesProvider';
}

/// See also [smcZones].
class SmcZonesProvider extends AutoDisposeFutureProvider<List<SMCZone>> {
  /// See also [smcZones].
  SmcZonesProvider(
    CurrencyPair pair, {
    Timeframe tf = Timeframe.h1,
  }) : this._internal(
          (ref) => smcZones(
            ref as SmcZonesRef,
            pair,
            tf: tf,
          ),
          from: smcZonesProvider,
          name: r'smcZonesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$smcZonesHash,
          dependencies: SmcZonesFamily._dependencies,
          allTransitiveDependencies: SmcZonesFamily._allTransitiveDependencies,
          pair: pair,
          tf: tf,
        );

  SmcZonesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.pair,
    required this.tf,
  }) : super.internal();

  final CurrencyPair pair;
  final Timeframe tf;

  @override
  Override overrideWith(
    FutureOr<List<SMCZone>> Function(SmcZonesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SmcZonesProvider._internal(
        (ref) => create(ref as SmcZonesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        pair: pair,
        tf: tf,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<SMCZone>> createElement() {
    return _SmcZonesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SmcZonesProvider && other.pair == pair && other.tf == tf;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, pair.hashCode);
    hash = _SystemHash.combine(hash, tf.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SmcZonesRef on AutoDisposeFutureProviderRef<List<SMCZone>> {
  /// The parameter `pair` of this provider.
  CurrencyPair get pair;

  /// The parameter `tf` of this provider.
  Timeframe get tf;
}

class _SmcZonesProviderElement
    extends AutoDisposeFutureProviderElement<List<SMCZone>> with SmcZonesRef {
  _SmcZonesProviderElement(super.provider);

  @override
  CurrencyPair get pair => (origin as SmcZonesProvider).pair;
  @override
  Timeframe get tf => (origin as SmcZonesProvider).tf;
}

String _$regimeHash() => r'229c1d84ca4bb5162dd20963ba61a1007b0368bd';

/// See also [regime].
@ProviderFor(regime)
const regimeProvider = RegimeFamily();

/// See also [regime].
class RegimeFamily extends Family<RegimeResult?> {
  /// See also [regime].
  const RegimeFamily();

  /// See also [regime].
  RegimeProvider call(
    CurrencyPair pair,
  ) {
    return RegimeProvider(
      pair,
    );
  }

  @override
  RegimeProvider getProviderOverride(
    covariant RegimeProvider provider,
  ) {
    return call(
      provider.pair,
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
  String? get name => r'regimeProvider';
}

/// See also [regime].
class RegimeProvider extends AutoDisposeProvider<RegimeResult?> {
  /// See also [regime].
  RegimeProvider(
    CurrencyPair pair,
  ) : this._internal(
          (ref) => regime(
            ref as RegimeRef,
            pair,
          ),
          from: regimeProvider,
          name: r'regimeProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$regimeHash,
          dependencies: RegimeFamily._dependencies,
          allTransitiveDependencies: RegimeFamily._allTransitiveDependencies,
          pair: pair,
        );

  RegimeProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.pair,
  }) : super.internal();

  final CurrencyPair pair;

  @override
  Override overrideWith(
    RegimeResult? Function(RegimeRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RegimeProvider._internal(
        (ref) => create(ref as RegimeRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        pair: pair,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<RegimeResult?> createElement() {
    return _RegimeProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RegimeProvider && other.pair == pair;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, pair.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RegimeRef on AutoDisposeProviderRef<RegimeResult?> {
  /// The parameter `pair` of this provider.
  CurrencyPair get pair;
}

class _RegimeProviderElement extends AutoDisposeProviderElement<RegimeResult?>
    with RegimeRef {
  _RegimeProviderElement(super.provider);

  @override
  CurrencyPair get pair => (origin as RegimeProvider).pair;
}

String _$sentimentHash() => r'c098c901093fe3e33a5fe6837bfa4a72594e7429';

/// See also [sentiment].
@ProviderFor(sentiment)
const sentimentProvider = SentimentFamily();

/// See also [sentiment].
class SentimentFamily extends Family<SentimentResult?> {
  /// See also [sentiment].
  const SentimentFamily();

  /// See also [sentiment].
  SentimentProvider call(
    CurrencyPair pair,
  ) {
    return SentimentProvider(
      pair,
    );
  }

  @override
  SentimentProvider getProviderOverride(
    covariant SentimentProvider provider,
  ) {
    return call(
      provider.pair,
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
  String? get name => r'sentimentProvider';
}

/// See also [sentiment].
class SentimentProvider extends AutoDisposeProvider<SentimentResult?> {
  /// See also [sentiment].
  SentimentProvider(
    CurrencyPair pair,
  ) : this._internal(
          (ref) => sentiment(
            ref as SentimentRef,
            pair,
          ),
          from: sentimentProvider,
          name: r'sentimentProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$sentimentHash,
          dependencies: SentimentFamily._dependencies,
          allTransitiveDependencies: SentimentFamily._allTransitiveDependencies,
          pair: pair,
        );

  SentimentProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.pair,
  }) : super.internal();

  final CurrencyPair pair;

  @override
  Override overrideWith(
    SentimentResult? Function(SentimentRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SentimentProvider._internal(
        (ref) => create(ref as SentimentRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        pair: pair,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<SentimentResult?> createElement() {
    return _SentimentProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SentimentProvider && other.pair == pair;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, pair.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SentimentRef on AutoDisposeProviderRef<SentimentResult?> {
  /// The parameter `pair` of this provider.
  CurrencyPair get pair;
}

class _SentimentProviderElement
    extends AutoDisposeProviderElement<SentimentResult?> with SentimentRef {
  _SentimentProviderElement(super.provider);

  @override
  CurrencyPair get pair => (origin as SentimentProvider).pair;
}

String _$cotPositionsHash() => r'cf8fe3af633e3ad39403caa114b6585c5f29a070';

/// See also [cotPositions].
@ProviderFor(cotPositions)
final cotPositionsProvider = FutureProvider<Map<String, COTData>>.internal(
  cotPositions,
  name: r'cotPositionsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$cotPositionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CotPositionsRef = FutureProviderRef<Map<String, COTData>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
