import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/signal.dart';
import '../models/trade_record.dart';
import '../models/market_data.dart';
import '../models/system_alert.dart';

class ApiService {
  late Dio _dio;
  final _storage = const FlutterSecureStorage();
  
  ApiService() {
    _dio = Dio();
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final apiKey = await _storage.read(key: 'backend_api_key');
        if (apiKey != null) {
          options.headers['X-API-Key'] = apiKey;
        }
        return handler.next(options);
      },
    ));
  }

  Future<void> updateBaseUrl(String url) async {
    _dio.options.baseUrl = url;
    await _storage.write(key: 'backend_url', value: url);
  }

  Future<bool> testConnection(String url, String apiKey) async {
    try {
      final response = await Dio().get(
        '$url/system/status',
        options: Options(headers: {'X-API-Key': apiKey}),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // Market Data
  Future<List<BackendSignal>> getAllSignals() async {
    final response = await _dio.get('/market/signals/all');
    if (response.data['status'] == 'success') {
      final List data = response.data['data'];
      return data.map((e) => BackendSignal.fromJson(e)).toList();
    }
    throw Exception(response.data['message']);
  }

  Future<List<NewsItem>> getNews(String pair) async {
    final response = await _dio.get('/market/news/$pair');
    if (response.data['status'] == 'success') {
      final List data = response.data['data'];
      return data.map((e) => NewsItem.fromJson(e)).toList();
    }
    return [];
  }

  Future<List<CalendarEvent>> getCalendar() async {
    final response = await _dio.get('/market/calendar');
    if (response.data['status'] == 'success') {
      final List data = response.data['data'];
      return data.map((e) => CalendarEvent.fromJson(e)).toList();
    }
    return [];
  }

  // Trades
  Future<List<TradeRecord>> getOpenTrades() async {
    final response = await _dio.get('/trades/open');
    if (response.data['status'] == 'success') {
      final List data = response.data['data'];
      return data.map((e) => TradeRecord.fromJson(e)).toList();
    }
    return [];
  }

  Future<List<TradeRecord>> getTradeHistory() async {
    final response = await _dio.get('/trades/history');
    if (response.data['status'] == 'success') {
      final List data = response.data['data'];
      return data.map((e) => TradeRecord.fromJson(e)).toList();
    }
    return [];
  }

  // System
  Future<Map<String, dynamic>> getSystemStatus() async {
    final response = await _dio.get('/system/status');
    return response.data['data'];
  }
}
