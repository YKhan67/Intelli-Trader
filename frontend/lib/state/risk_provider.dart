import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core_services.dart';
import '../models/models.dart';

/// Provider for real-time risk parameters and circuit breaker status from the backend.
final riskProvider = FutureProvider<RiskParams>((ref) async {
  final api = ref.watch(backendServiceProvider);
  
  // Auto-refresh risk data every 30 seconds
  final timer = Timer(const Duration(seconds: 30), () {
    ref.invalidateSelf();
  });
  
  ref.onDispose(() => timer.cancel());

  return api.getRisk();
});

/// Exposes the circuit breaker flags as a map for the UI.
final circuitBreakerProvider = Provider<Map<String, bool>>((ref) {
  final riskAsync = ref.watch(riskProvider);
  final r = riskAsync.value;
  if (r == null) return {};
  
  return {
    'Daily Halt': r.dailyHalt,
    'Hard Daily Halt': r.hardDailyHalt,
    'Weekly Review': r.weeklyReview,
    'Correlated Exposure': r.correlatedExposure,
  };
});

/// Returns true if any circuit breaker is currently active.
final anyHaltActiveProvider = Provider<bool>((ref) {
  final breakers = ref.watch(circuitBreakerProvider);
  return breakers.values.any((halted) => halted);
});
