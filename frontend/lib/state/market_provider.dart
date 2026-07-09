import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'core_services.dart';
import '../models/models.dart';

part 'market_provider.g.dart';

@riverpod
Future<Map<String, dynamic>> market(MarketRef ref, CurrencyPair pair) async {
  final api = ref.watch(backendServiceProvider);
  
  // Refresh every 60 seconds
  final timer = Timer(const Duration(seconds: 60), () => ref.invalidateSelf());
  ref.onDispose(() => timer.cancel());

  return api.getMarket(pair.displayName);
}

@riverpod
Future<List<OHLCVBar>> ohlcv(OhlcvRef ref, CurrencyPair pair, {Timeframe tf = Timeframe.h1}) async {
  final api = ref.watch(backendServiceProvider);
  
  // Refresh every 5 minutes for candles
  final timer = Timer(const Duration(minutes: 5), () => ref.invalidateSelf());
  ref.onDispose(() => timer.cancel());

  return api.getOHLCV(pair.displayName, timeframe: tf.name.toUpperCase(), limit: 200);
}

@riverpod
Future<List<IndicatorSet>> indicators(IndicatorsRef ref, CurrencyPair pair, {Timeframe tf = Timeframe.h1}) async {
  final api = ref.watch(backendServiceProvider);
  return api.getIndicators(pair.displayName, timeframe: tf.name.toUpperCase(), limit: 200);
}

@riverpod
Future<List<SMCZone>> smcZones(SmcZonesRef ref, CurrencyPair pair, {Timeframe tf = Timeframe.h1}) async {
  final api = ref.watch(backendServiceProvider);
  return api.getSMCZones(pair.displayName, timeframe: tf.name.toUpperCase());
}

@riverpod
RegimeResult? regime(RegimeRef ref, CurrencyPair pair) {
  final marketData = ref.watch(marketProvider(pair)).value;
  if (marketData == null || marketData['regime'] == null) return null;
  
  try {
    return RegimeResult.fromJson(marketData['regime']);
  } catch (e) {
    print('Error parsing regime for ${pair.name}: $e');
    return null;
  }
}

@riverpod
SentimentResult? sentiment(SentimentRef ref, CurrencyPair pair) {
  final marketData = ref.watch(marketProvider(pair)).value;
  if (marketData == null || marketData['sentiment'] == null) return null;
  return SentimentResult.fromJson(marketData['sentiment']);
}

@riverpod
Future<List<Map<String, dynamic>>> immunityLogs(ImmunityLogsRef ref) async {
  final api = ref.watch(backendServiceProvider);
  final status = await api.getStatus();
  return List<Map<String, dynamic>>.from(status['immunity_logs'] ?? []);
}

@Riverpod(keepAlive: true)
Future<Map<String, COTData>> cotPositions(CotPositionsRef ref) async {
  final api = ref.watch(backendServiceProvider);
  final data = await api.getAllCOT();
  return data.map((key, value) => MapEntry(key, COTData.fromJson(value as Map<String, dynamic>)));
}
