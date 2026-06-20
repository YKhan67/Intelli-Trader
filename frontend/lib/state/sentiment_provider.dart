import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'services_provider.dart';
import '../models/models.dart';

part 'sentiment_provider.g.dart';

@Riverpod(keepAlive: true)
Future<SentimentOverview> sentimentOverview(SentimentOverviewRef ref) async {
  final api = ref.watch(backendServiceProvider);
  
  // Refresh every 5 minutes
  final timer = Timer(const Duration(minutes: 5), () => ref.invalidateSelf());
  ref.onDispose(() => timer.cancel());

  return api.getSentimentOverview();
}
