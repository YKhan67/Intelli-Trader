// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'performance_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$performanceHash() => r'36bc2f4df7431cfaf7eb96e3dd3d89e0d4a9670c';

/// See also [performance].
@ProviderFor(performance)
final performanceProvider = FutureProvider<PerformanceMetrics>.internal(
  performance,
  name: r'performanceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$performanceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PerformanceRef = FutureProviderRef<PerformanceMetrics>;
String _$dailySummaryHash() => r'2b47822bdcba9e909ec30e079281d416656cd51c';

/// See also [dailySummary].
@ProviderFor(dailySummary)
final dailySummaryProvider = AutoDisposeProvider<PerformanceMetrics?>.internal(
  dailySummary,
  name: r'dailySummaryProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$dailySummaryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DailySummaryRef = AutoDisposeProviderRef<PerformanceMetrics?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
