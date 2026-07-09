import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'core_services.dart';
import '../models/models.dart';

part 'performance_provider.g.dart';

@Riverpod(keepAlive: true)
Future<PerformanceMetrics> performance(PerformanceRef ref) async {
  final api = ref.watch(backendServiceProvider);
  
  final timer = Timer(const Duration(minutes: 5), () => ref.invalidateSelf());
  ref.onDispose(() => timer.cancel());

  return api.getPerformance();
}

@riverpod
PerformanceMetrics? dailySummary(DailySummaryRef ref) {
  final perf = ref.watch(performanceProvider).value;
  // In a real app, logic here to filter for today's metrics
  return perf;
}
