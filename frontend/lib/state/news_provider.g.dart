// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$newsHash() => r'd79f8f306dd3fb9fbc0f45dee8bc9296c36a8840';

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

/// See also [news].
@ProviderFor(news)
const newsProvider = NewsFamily();

/// See also [news].
class NewsFamily extends Family<AsyncValue<List<NewsItem>>> {
  /// See also [news].
  const NewsFamily();

  /// See also [news].
  NewsProvider call(
    CurrencyPair pair,
  ) {
    return NewsProvider(
      pair,
    );
  }

  @override
  NewsProvider getProviderOverride(
    covariant NewsProvider provider,
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
  String? get name => r'newsProvider';
}

/// See also [news].
class NewsProvider extends FutureProvider<List<NewsItem>> {
  /// See also [news].
  NewsProvider(
    CurrencyPair pair,
  ) : this._internal(
          (ref) => news(
            ref as NewsRef,
            pair,
          ),
          from: newsProvider,
          name: r'newsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product') ? null : _$newsHash,
          dependencies: NewsFamily._dependencies,
          allTransitiveDependencies: NewsFamily._allTransitiveDependencies,
          pair: pair,
        );

  NewsProvider._internal(
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
    FutureOr<List<NewsItem>> Function(NewsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: NewsProvider._internal(
        (ref) => create(ref as NewsRef),
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
  FutureProviderElement<List<NewsItem>> createElement() {
    return _NewsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is NewsProvider && other.pair == pair;
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
mixin NewsRef on FutureProviderRef<List<NewsItem>> {
  /// The parameter `pair` of this provider.
  CurrencyPair get pair;
}

class _NewsProviderElement extends FutureProviderElement<List<NewsItem>>
    with NewsRef {
  _NewsProviderElement(super.provider);

  @override
  CurrencyPair get pair => (origin as NewsProvider).pair;
}

String _$allNewsHash() => r'3957ec412e7201cc7eb65c368831834b0b56aaf3';

/// See also [allNews].
@ProviderFor(allNews)
final allNewsProvider = FutureProvider<List<NewsItem>>.internal(
  allNews,
  name: r'allNewsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$allNewsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AllNewsRef = FutureProviderRef<List<NewsItem>>;
String _$calendarHash() => r'deeac6876d9f9c434b27f4500c74efac4e76ecdb';

/// See also [calendar].
@ProviderFor(calendar)
final calendarProvider = FutureProvider<List<CalendarEvent>>.internal(
  calendar,
  name: r'calendarProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$calendarHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CalendarRef = FutureProviderRef<List<CalendarEvent>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
