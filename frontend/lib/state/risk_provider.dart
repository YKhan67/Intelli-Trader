import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'services_provider.dart';
import '../models/models.dart';

part 'risk_provider.g.dart';

@Riverpod(keepAlive: true)
Future<RiskParams> risk(RiskRef ref) async {
  final api = ref.watch(backendServiceProvider);
  
  final timer = Timer(const Duration(seconds: 30), () => ref.invalidateSelf());
  ref.onDispose(() => timer.cancel());

  return api.getRisk();
}

@riverpod
Map<String, bool> circuitBreaker(CircuitBreakerRef ref) {
  final r = ref.watch(riskProvider).value;
  if (r == null) return {};
  
  return {
    'Daily Halt': r.dailyHalt,
    'Hard Daily Halt': r.hardDailyHalt,
    'Weekly Review': r.weeklyReview,
    'Correlated Exposure': r.correlatedExposure,
  };
}

@riverpod
bool anyHaltActive(AnyHaltActiveRef ref) {
  final breakers = ref.watch(circuitBreakerProvider);
  return breakers.values.any((halted) => halted);
}
