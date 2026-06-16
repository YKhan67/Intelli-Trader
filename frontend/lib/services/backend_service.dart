import 'package:dio/dio.dart';
import 'package:forex_ai_frontend/config/api_endpoints.dart';
import 'package:forex_ai_frontend/models/models.dart';
import 'package:forex_ai_frontend/utils/app_exception.dart';
import 'package:forex_ai_frontend/utils/logger.dart';
import 'storage_service.dart';

class BackendService {
  final Dio _dio;
  final StorageService _storage;

  BackendService(this._storage) : _dio = Dio() {
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
    
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final config = await _storage.getBackendConfig();
        if (config['url'] != null) {
          String url = config['url']!;
          if (url.endsWith('/')) {
            url = url.substring(0, url.length - 1);
          }
          options.baseUrl = url;
        }
        if (config['apiKey'] != null) {
          options.headers['X-API-Key'] = config['apiKey'];
        }
        
        // Remove leading slash from path if baseUrl is set to avoid double slashes
        if (options.path.startsWith('/')) {
          // Dio handles this usually, but let's be explicit
        }
        
        logger.i('API Request: ${options.method} ${options.path}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        logger.i('API Response: ${response.statusCode} ${response.requestOptions.path}');
        return handler.next(response);
      },
      onError: (DioException e, handler) async {
        if (e.response?.statusCode == 401) {
          logger.w('Auth failure (401). Clearing key.');
          await _storage.clearApiKey();
          // In a real app, notify state to trigger login flow
        }
        return handler.next(e);
      },
    ));
  }

  Future<T> _handleRequest<T>(Future<Response> request, T Function(dynamic) parser) async {
    try {
      final response = await request;
      if (response.data['status'] == 'success') {
        return parser(response.data['data']);
      } else {
        throw ServerException(message: response.data['message'] ?? 'Unknown server error');
      }
    } on DioException catch (e) {
      throw _wrapDioException(e);
    } catch (e) {
      throw AppException(code: 'UNKNOWN', message: e.toString());
    }
  }

  AppException _wrapDioException(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout) {
      return TimeoutException(message: 'Connection timed out');
    }
    if (e.response?.statusCode == 401) {
      return AuthException(message: 'Unauthorized access');
    }
    if (e.response?.statusCode == 404) {
      return NetworkException(message: 'Resource not found');
    }
    return ServerException(message: e.message ?? 'Network error');
  }

  // API Methods
  Future<Map<String, dynamic>> testConnection(String url, String apiKey) async {
    final testDio = Dio(BaseOptions(
      baseUrl: url,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'X-API-Key': apiKey},
    ));
    
    return _handleRequest(
      testDio.get(ApiEndpoints.status),
      (data) => data as Map<String, dynamic>,
    );
  }

  Future<Map<String, dynamic>> getStatus() => _handleRequest(
        _dio.get(ApiEndpoints.status),
        (data) => data as Map<String, dynamic>,
      );

  Future<BackendSignal> getSignal(String pair) => _handleRequest(
        _dio.get('${ApiEndpoints.signal}/$pair'),
        (data) => BackendSignal.fromJson(data as Map<String, dynamic>),
      );

  Future<List<BackendSignal>> getAllSignals({String timeframe = 'H1'}) => _handleRequest(
        _dio.get(ApiEndpoints.allSignals, queryParameters: {'timeframe': timeframe}),
        (data) => (data as List?)?.map((e) => BackendSignal.fromJson(e as Map<String, dynamic>)).toList() ?? [],
      );

  Future<Map<String, dynamic>> getMarket(String pair) => _handleRequest(
        _dio.get('${ApiEndpoints.market}/$pair'),
        (data) => data as Map<String, dynamic>? ?? {},
      );

  Future<List<OpenTrade>> getOpenTrades() => _handleRequest(
        _dio.get(ApiEndpoints.openTrades),
        (data) => (data as List?)?.map((e) => OpenTrade.fromJson(e as Map<String, dynamic>)).toList() ?? [],
      );

  Future<List<TradeRecord>> getTradeHistory({
    DateTime? dateFrom,
    DateTime? dateTo,
    String? pair,
    String? strategy,
  }) => _handleRequest(
        _dio.get(ApiEndpoints.tradeHistory, queryParameters: {
          if (dateFrom != null) 'date_from': dateFrom.toIso8601String(),
          if (dateTo != null) 'date_to': dateTo.toIso8601String(),
          if (pair != null) 'pair': pair,
          if (strategy != null) 'strategy': strategy,
        }),
        (data) => (data as List?)?.map((e) => TradeRecord.fromJson(e as Map<String, dynamic>)).toList() ?? [],
      );

  Future<PerformanceMetrics> getPerformance() => _handleRequest(
        _dio.get(ApiEndpoints.performance),
        (data) => PerformanceMetrics.fromJson(data as Map<String, dynamic>),
      );

  Future<List<NewsItem>> getNews(String pair) => _handleRequest(
        _dio.get('${ApiEndpoints.news}/$pair'),
        (data) => (data as List?)?.map((e) => NewsItem.fromJson(e as Map<String, dynamic>)).toList() ?? [],
      );

  Future<List<OHLCVBar>> getOHLCV(String pair, {String timeframe = 'H1', int limit = 100}) => _handleRequest(
        _dio.get('${ApiEndpoints.market}/ohlcv/$pair', queryParameters: {
          'timeframe': timeframe,
          'limit': limit,
        }),
        (data) => (data as List?)?.map((e) => OHLCVBar.fromJson({
          ...e as Map<String, dynamic>,
          'pair': pair,
          'timeframe': timeframe.toLowerCase(),
          'spread_pips': 0.0, // Default for historical
        })).toList() ?? [],
      );

  Future<List<IndicatorSet>> getIndicators(String pair, {String timeframe = 'H1', int limit = 100}) => _handleRequest(
        _dio.get('${ApiEndpoints.market}/indicators/$pair', queryParameters: {
          'timeframe': timeframe,
          'limit': limit,
        }),
        (data) => (data as List?)?.map((e) => IndicatorSet.fromJson(e as Map<String, dynamic>)).toList() ?? [],
      );

  Future<List<SMCZone>> getSMCZones(String pair, {String timeframe = 'H1'}) => _handleRequest(
        _dio.get('${ApiEndpoints.market}/smc/$pair', queryParameters: {
          'timeframe': timeframe,
        }),
        (data) => (data as List?)?.map((e) => SMCZone.fromJson(e as Map<String, dynamic>)).toList() ?? [],
      );

  Future<List<CalendarEvent>> getCalendar() => _handleRequest(
        _dio.get(ApiEndpoints.calendar),
        (data) => (data as List?)?.map((e) => CalendarEvent.fromJson(e as Map<String, dynamic>)).toList() ?? [],
      );

  Future<RiskParams> getRisk() => _handleRequest(
        _dio.get(ApiEndpoints.risk),
        (data) => RiskParams.fromJson(data as Map<String, dynamic>),
      );

  Future<void> postSettings(TradingMode mode, List<CurrencyPair> pairs) => _handleRequest(
        _dio.post(ApiEndpoints.settings, data: {
          'trading_mode': mode.name,
          'active_pairs': pairs.map((e) => e.name).toList(),
        }),
        (data) => null,
      );

  Future<void> postRetrain() => _handleRequest(
        _dio.post(ApiEndpoints.retrain),
        (data) => null,
      );
}
