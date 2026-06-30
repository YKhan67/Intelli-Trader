import 'package:dio/dio.dart';
import 'dart:convert';
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
        options.baseUrl = config['url'] ?? 'http://localhost:8081';
        options.headers['X-API-Key'] = config['apiKey'] ?? 'dev_key';
        return handler.next(options);
      },
      onError: (DioException e, handler) async {
        if (e.response?.statusCode == 401) {
          logger.w('Auth failure (401).');
          await _storage.clearApiKey();
        }
        return handler.next(e);
      },
    ));
  }

  Future<T> _handleRequest<T>(Future<Response> request, T Function(dynamic) parser) async {
    try {
      final response = await request;
      final data = response.data;
      if (data is Map && data['status'] == 'success') {
        try {
          return parser(data['data']);
        } catch (e, stack) {
          logger.e('DATA PARSING ERROR: $e');
          logger.e('RAW DATA: ${jsonEncode(data['data'])}');
          logger.e('STACKTRACE: $stack');
          throw AppException(code: 'PARSE_ERROR', message: 'Model parse failed: $e');
        }
      } else {
        logger.e('API ERROR: ${data['message'] ?? 'Unknown error'}');
        throw ServerException(message: data['message'] ?? 'Unknown server error');
      }
    } on DioException catch (e) {
      throw _wrapDioException(e);
    } catch (e) {
      logger.e('REQUEST ERROR: $e');
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
      return NetworkException(message: 'Resource not found: ${e.requestOptions.path}');
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
        (data) => BackendSignal.fromJson(_flattenSignal(data as Map<String, dynamic>)),
      );

  Future<List<BackendSignal>> getAllSignals({String timeframe = 'H1'}) => _handleRequest(
        _dio.get(ApiEndpoints.allSignals, queryParameters: {'timeframe': timeframe}),
        (data) => (data is List) 
            ? data.map((e) => BackendSignal.fromJson(_flattenSignal(e as Map<String, dynamic>))).toList() 
            : [],
      );

  Map<String, dynamic> _flattenSignal(Map<String, dynamic> json) {
    final Map<String, dynamic> flat = Map.from(json);
    
    // Trade Decision fields
    if (json.containsKey('trade_decision')) {
      flat.addAll(json['trade_decision'] as Map<String, dynamic>);
    } else if (json.containsKey('decision')) {
      flat.addAll(json['decision'] as Map<String, dynamic>);
    }

    // Regime Result fields
    if (json.containsKey('regime_result')) {
      final rr = json['regime_result'] as Map<String, dynamic>;
      flat['regime_confidence'] = rr['confidence'] ?? 0.0;
      flat['bars_in_regime'] = rr['bars_in_regime'] ?? 0;
      flat['h4_bias'] = rr['h4_bias'];
      flat['h1_regime'] = rr['h1_regime'];
      if (!flat.containsKey('regime')) flat['regime'] = rr['regime'];
    } else if (json.containsKey('regime')) {
      final rData = json['regime'];
      if (rData is Map<String, dynamic>) {
        flat['regime_confidence'] = rData['confidence'] ?? 0.0;
        flat['bars_in_regime'] = rData['bars_in_regime'] ?? 0;
        flat['h4_bias'] = rData['h4_bias'];
        flat['h1_regime'] = rData['h1_regime'];
      }
    }

    // Scores
    if (json.containsKey('sentiment_result')) {
      flat['sentiment_score'] = json['sentiment_result']['pair_score'] ?? 0.0;
    }
    if (json.containsKey('risk_params')) {
      flat['risk_score'] = json['risk_params']['risk_score'] ?? 0.0;
    }

    return flat;
  }

  Future<Map<String, dynamic>> getMarket(String pair) => _handleRequest(
        _dio.get('${ApiEndpoints.market}/$pair'),
        (data) => data as Map<String, dynamic>? ?? {},
      );

  Future<List<OpenTrade>> getOpenTrades() => _handleRequest(
        _dio.get(ApiEndpoints.openTrades),
        (data) => (data is List) 
            ? data.map((e) => OpenTrade.fromJson(e as Map<String, dynamic>)).toList() 
            : [],
      );

  Future<List<TradeRecord>> getTradeHistory({
    DateTime? dateFrom,
    DateTime? dateTo,
    String? pair,
    String? strategy,
    int page = 1,
    int size = 50,
  }) => _handleRequest(
        _dio.get(ApiEndpoints.tradeHistory, queryParameters: {
          if (dateFrom != null) 'date_from': dateFrom.toIso8601String(),
          if (dateTo != null) 'date_to': dateTo.toIso8601String(),
          if (pair != null) 'pair': pair,
          if (strategy != null) 'strategy': strategy,
          'page': page,
          'size': size,
        }),
        (data) => (data is List) 
            ? data.map((e) => TradeRecord.fromJson(e as Map<String, dynamic>)).toList() 
            : [],
      );

  Future<PerformanceMetrics> getPerformance() => _handleRequest(
        _dio.get(ApiEndpoints.performance),
        (data) => PerformanceMetrics.fromJson(data as Map<String, dynamic>),
      );

  Future<List<NewsItem>> getNews(String pair) => _handleRequest(
        _dio.get('${ApiEndpoints.news}/$pair'),
        (data) => (data is List) 
            ? data.map((e) => NewsItem.fromJson(e as Map<String, dynamic>)).toList() 
            : [],
      );

  Future<List<NewsItem>> getAllNews({int limit = 50}) => _handleRequest(
        _dio.get(ApiEndpoints.allNews, queryParameters: {'limit': limit}),
        (data) => (data is List) 
            ? data.map((e) => NewsItem.fromJson(e as Map<String, dynamic>)).toList() 
            : [],
      );

  Future<SentimentOverview> getSentimentOverview() => _handleRequest(
        _dio.get(ApiEndpoints.sentimentOverview),
        (data) => SentimentOverview.fromJson(data as Map<String, dynamic>),
      );

  Future<MarketDriver> getMarketDrivers() => _handleRequest(
        _dio.get('/market/drivers'),
        (data) => MarketDriver.fromJson(data as Map<String, dynamic>),
      );

  Future<Map<String, dynamic>> getAllCOT() => _handleRequest(
        _dio.get('/market/cot/all'),
        (data) => data as Map<String, dynamic>,
      );

  Future<List<Map<String, dynamic>>> getSentimentHistory(String currency) => _handleRequest(
        _dio.get('/market/sentiment/history/$currency'),
        (data) => (data as List).map((e) => e as Map<String, dynamic>).toList(),
      );

  Future<List<OHLCVBar>> getOHLCV(String pair, {String timeframe = 'H1', int limit = 100}) => _handleRequest(
        _dio.get('${ApiEndpoints.market}/ohlcv/$pair', queryParameters: {
          'timeframe': timeframe,
          'limit': limit,
        }),
        (data) => (data is List) 
            ? data.map((e) => OHLCVBar.fromJson({
                ...e as Map<String, dynamic>,
                'pair': pair,
                'timeframe': timeframe.toLowerCase(),
                'spread_pips': 0.0,
              })).toList() 
            : [],
      );

  Future<List<IndicatorSet>> getIndicators(String pair, {String timeframe = 'H1', int limit = 100}) => _handleRequest(
        _dio.get('${ApiEndpoints.market}/indicators/$pair', queryParameters: {
          'timeframe': timeframe,
          'limit': limit,
        }),
        (data) => (data is List) 
            ? data.map((e) => IndicatorSet.fromJson(e as Map<String, dynamic>)).toList() 
            : [],
      );

  Future<List<SMCZone>> getSMCZones(String pair, {String timeframe = 'H1'}) => _handleRequest(
        _dio.get('${ApiEndpoints.market}/smc/$pair', queryParameters: {
          'timeframe': timeframe,
        }),
        (data) => (data is List) 
            ? data.map((e) => SMCZone.fromJson(e as Map<String, dynamic>)).toList() 
            : [],
      );

  Future<List<CalendarEvent>> getCalendar() => _handleRequest(
        _dio.get(ApiEndpoints.calendar),
        (data) => (data is List) 
            ? data.map((e) => CalendarEvent.fromJson(e as Map<String, dynamic>)).toList() 
            : [],
      );

  Future<RiskParams> getRisk() => _handleRequest(
        _dio.get(ApiEndpoints.risk),
        (data) => RiskParams.fromJson(data as Map<String, dynamic>),
      );

  Future<void> postSettings(TradingMode mode, List<CurrencyPair> pairs, Map<String, double> risk) => _handleRequest(
        _dio.post(ApiEndpoints.settings, data: {
          'trading_mode': mode.name,
          'active_pairs': pairs.map((e) => e.name).toList(),
          'min_rr_ratio': risk['min_rr_ratio'],
          'max_risk_per_trade': risk['max_risk_per_trade'],
        }),
        (data) => null,
      );

  Future<void> postRetrain() => _handleRequest(
        _dio.post(ApiEndpoints.retrain),
        (data) => null,
      );
}
