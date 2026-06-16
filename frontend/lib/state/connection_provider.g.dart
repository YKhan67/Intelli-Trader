// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connection_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$systemStatusHash() => r'1dd2a3e8e9062aafcf9743d6667b3b852d3cb2c3';

/// See also [systemStatus].
@ProviderFor(systemStatus)
final systemStatusProvider =
    AutoDisposeFutureProvider<Map<String, dynamic>>.internal(
  systemStatus,
  name: r'systemStatusProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$systemStatusHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SystemStatusRef = AutoDisposeFutureProviderRef<Map<String, dynamic>>;
String _$backendConnectionHash() => r'adf45bb283eb153af35668e9341167ac0ade8c97';

/// See also [BackendConnection].
@ProviderFor(BackendConnection)
final backendConnectionProvider =
    AutoDisposeNotifierProvider<BackendConnection, ConnectionState>.internal(
  BackendConnection.new,
  name: r'backendConnectionProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$backendConnectionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$BackendConnection = AutoDisposeNotifier<ConnectionState>;
String _$brokerConnectionHash() => r'd2900198281a0ce7ce2a31255d7cf7aa93280d87';

/// See also [BrokerConnection].
@ProviderFor(BrokerConnection)
final brokerConnectionProvider =
    AutoDisposeNotifierProvider<BrokerConnection, ConnectionState>.internal(
  BrokerConnection.new,
  name: r'brokerConnectionProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$brokerConnectionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$BrokerConnection = AutoDisposeNotifier<ConnectionState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
