// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signal_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$signalHash() => r'7dab3c2846d4e7e49f1df74dc93fe031e1b65142';

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

/// See also [signal].
@ProviderFor(signal)
const signalProvider = SignalFamily();

/// See also [signal].
class SignalFamily extends Family<AsyncValue<BackendSignal>> {
  /// See also [signal].
  const SignalFamily();

  /// See also [signal].
  SignalProvider call(
    CurrencyPair pair,
  ) {
    return SignalProvider(
      pair,
    );
  }

  @override
  SignalProvider getProviderOverride(
    covariant SignalProvider provider,
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
  String? get name => r'signalProvider';
}

/// See also [signal].
class SignalProvider extends AutoDisposeStreamProvider<BackendSignal> {
  /// See also [signal].
  SignalProvider(
    CurrencyPair pair,
  ) : this._internal(
          (ref) => signal(
            ref as SignalRef,
            pair,
          ),
          from: signalProvider,
          name: r'signalProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$signalHash,
          dependencies: SignalFamily._dependencies,
          allTransitiveDependencies: SignalFamily._allTransitiveDependencies,
          pair: pair,
        );

  SignalProvider._internal(
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
    Stream<BackendSignal> Function(SignalRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SignalProvider._internal(
        (ref) => create(ref as SignalRef),
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
  AutoDisposeStreamProviderElement<BackendSignal> createElement() {
    return _SignalProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SignalProvider && other.pair == pair;
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
mixin SignalRef on AutoDisposeStreamProviderRef<BackendSignal> {
  /// The parameter `pair` of this provider.
  CurrencyPair get pair;
}

class _SignalProviderElement
    extends AutoDisposeStreamProviderElement<BackendSignal> with SignalRef {
  _SignalProviderElement(super.provider);

  @override
  CurrencyPair get pair => (origin as SignalProvider).pair;
}

String _$allSignalsHash() => r'fae041eb0cdaed97baebf72cd53ea80644b13e4e';

/// See also [allSignals].
@ProviderFor(allSignals)
final allSignalsProvider =
    StreamProvider<Map<CurrencyPair, BackendSignal>>.internal(
  allSignals,
  name: r'allSignalsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$allSignalsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AllSignalsRef = StreamProviderRef<Map<CurrencyPair, BackendSignal>>;
String _$latestSignalHash() => r'6fd4e7df6bd7078ee9f68c24f97250adeba623f9';

/// See also [latestSignal].
@ProviderFor(latestSignal)
const latestSignalProvider = LatestSignalFamily();

/// See also [latestSignal].
class LatestSignalFamily extends Family<BackendSignal?> {
  /// See also [latestSignal].
  const LatestSignalFamily();

  /// See also [latestSignal].
  LatestSignalProvider call(
    CurrencyPair pair,
  ) {
    return LatestSignalProvider(
      pair,
    );
  }

  @override
  LatestSignalProvider getProviderOverride(
    covariant LatestSignalProvider provider,
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
  String? get name => r'latestSignalProvider';
}

/// See also [latestSignal].
class LatestSignalProvider extends AutoDisposeProvider<BackendSignal?> {
  /// See also [latestSignal].
  LatestSignalProvider(
    CurrencyPair pair,
  ) : this._internal(
          (ref) => latestSignal(
            ref as LatestSignalRef,
            pair,
          ),
          from: latestSignalProvider,
          name: r'latestSignalProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$latestSignalHash,
          dependencies: LatestSignalFamily._dependencies,
          allTransitiveDependencies:
              LatestSignalFamily._allTransitiveDependencies,
          pair: pair,
        );

  LatestSignalProvider._internal(
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
    BackendSignal? Function(LatestSignalRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: LatestSignalProvider._internal(
        (ref) => create(ref as LatestSignalRef),
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
  AutoDisposeProviderElement<BackendSignal?> createElement() {
    return _LatestSignalProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LatestSignalProvider && other.pair == pair;
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
mixin LatestSignalRef on AutoDisposeProviderRef<BackendSignal?> {
  /// The parameter `pair` of this provider.
  CurrencyPair get pair;
}

class _LatestSignalProviderElement
    extends AutoDisposeProviderElement<BackendSignal?> with LatestSignalRef {
  _LatestSignalProviderElement(super.provider);

  @override
  CurrencyPair get pair => (origin as LatestSignalProvider).pair;
}

String _$selectedTimeframeHash() => r'e73b5afec5dbf46bf5f6245782f267469cd78d77';

/// See also [SelectedTimeframe].
@ProviderFor(SelectedTimeframe)
final selectedTimeframeProvider =
    NotifierProvider<SelectedTimeframe, Timeframe>.internal(
  SelectedTimeframe.new,
  name: r'selectedTimeframeProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedTimeframeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedTimeframe = Notifier<Timeframe>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
