import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'services_provider.dart';
import '../models/models.dart';

part 'market_driver_provider.g.dart';

@riverpod
Future<MarketDriver> marketDrivers(MarketDriversRef ref) async {
  final api = ref.watch(backendServiceProvider);
  
  // Auto-refresh every 15 minutes
  final timer = Timer(const Duration(minutes: 15), () => ref.invalidateSelf());
  ref.onDispose(() => timer.cancel());

  return api.getMarketDrivers();
}
