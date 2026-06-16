// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alert_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$alertStreamHash() => r'd77369dda5bbd02a89e8aa38d99a5aab015a6d87';

/// See also [alertStream].
@ProviderFor(alertStream)
final alertStreamProvider = AutoDisposeStreamProvider<SystemAlert>.internal(
  alertStream,
  name: r'alertStreamProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$alertStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AlertStreamRef = AutoDisposeStreamProviderRef<SystemAlert>;
String _$unreadAlertsHash() => r'ee77113289d522543495fba2da0b7f58f2403813';

/// See also [UnreadAlerts].
@ProviderFor(UnreadAlerts)
final unreadAlertsProvider =
    NotifierProvider<UnreadAlerts, List<SystemAlert>>.internal(
  UnreadAlerts.new,
  name: r'unreadAlertsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$unreadAlertsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$UnreadAlerts = Notifier<List<SystemAlert>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
