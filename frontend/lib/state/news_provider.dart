import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'services_provider.dart';
import '../models/models.dart';

part 'news_provider.g.dart';

@Riverpod(keepAlive: true)
Future<List<NewsItem>> news(NewsRef ref, CurrencyPair pair) async {
  final api = ref.watch(backendServiceProvider);
  
  // Refresh every 10 minutes
  final timer = Timer(const Duration(minutes: 10), () => ref.invalidateSelf());
  ref.onDispose(() => timer.cancel());

  try {
    return await api.getNews(pair.displayName);
  } catch (e) {
    return [];
  }
}

@Riverpod(keepAlive: true)
Future<List<NewsItem>> allNews(AllNewsRef ref) async {
  final api = ref.watch(backendServiceProvider);
  
  // Refresh every 10 minutes
  final timer = Timer(const Duration(minutes: 10), () => ref.invalidateSelf());
  ref.onDispose(() => timer.cancel());

  return api.getAllNews();
}

@Riverpod(keepAlive: true)
Future<List<CalendarEvent>> calendar(CalendarRef ref) async {
  final api = ref.watch(backendServiceProvider);
  
  // Refresh every 15 minutes from Backend
  final timer = Timer(const Duration(minutes: 15), () => ref.invalidateSelf());
  ref.onDispose(() => timer.cancel());

  return api.getCalendar();
}
