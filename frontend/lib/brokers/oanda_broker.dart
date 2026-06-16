import 'dart:async';
import 'package:dio/dio.dart';
import '../models/models.dart';
import '../utils/app_exception.dart';
import '../utils/logger.dart';
import 'broker_interface.dart';

/// OandaBrokerConnector implementing BrokerInterface.
/// 
/// Uses OANDA v20 REST API.
class OandaBrokerConnector implements BrokerInterface {
  late Dio _dio;
  bool _connected = false;
  String? _accountId;
  final _tradeUpdateController = StreamController<OpenTrade>.broadcast();
  Timer? _pricingTimer;

  OandaBrokerConnector() {
    _dio = Dio();
    _dio.options.receiveTimeout = const Duration(seconds: 15);
    _dio.options.connectTimeout = const Duration(seconds: 15);
  }

  @override
  bool get isConnected => _connected;

  @override
  String get brokerName => "OANDA";

  @override
  Future<bool> connect(Map<String, String> credentials) async {
    final token = credentials['api_token'];
    _accountId = credentials['account_id'];
    final env = credentials['environment'] ?? 'practice'; 
    
    if (token == null || _accountId == null) return false;

    final baseUrl = env == 'live' 
        ? 'https://api-fxtrade.oanda.com/v3' 
        : 'https://api-fxpractice.oanda.com/v3';

    _dio.options.baseUrl = baseUrl;
    _dio.options.headers['Authorization'] = 'Bearer $token';
    _dio.options.headers['Content-Type'] = 'application/json';

    try {
      final response = await _dio.get('/accounts/$_accountId/summary');
      _connected = response.statusCode == 200;
      if (_connected) {
        _startPricingStream();
      }
      return _connected;
    } catch (e) {
      logger.e('OANDA Connection failed: $e');
      _connected = false;
      return false;
    }
  }

  @override
  Future<void> disconnect() async {
    _pricingTimer?.cancel();
    _connected = false;
  }

  @override
  Future<AccountInfo> getAccountInfo() async {
    if (!_connected) throw AuthException(message: 'OANDA not connected');
    
    try {
      final response = await _dio.get('/accounts/$_accountId/summary');
      final data = response.data['account'];
      
      return AccountInfo(
        balance: double.parse(data['balance']),
        equity: double.parse(data['NAV']),
        margin: double.parse(data['marginUsed']),
        freeMargin: double.parse(data['marginAvailable']),
        marginLevel: (double.parse(data['marginCallPercent']) * 100),
        currency: data['currency'],
        brokerName: 'OANDA',
        accountNumber: data['id'],
        leverage: 1 / double.parse(data['marginRate']),
      );
    } catch (e) {
      logger.e('OANDA Account Info Error: $e');
      throw ServerException(message: 'Failed to fetch OANDA account info');
    }
  }

  @override
  Future<List<OpenTrade>> getOpenTrades() async {
    if (!_connected) return [];
    
    try {
      final response = await _dio.get('/accounts/$_accountId/openTrades');
      final List trades = response.data['trades'];
      return trades.map((t) => _parseTrade(t)).toList();
    } catch (e) {
      logger.e('OANDA getOpenTrades Error: $e');
      return [];
    }
  }

  @override
  Future<List<CalendarEvent>> getCalendar() async {
    // OANDA REST v20 does not provide a built-in economic calendar endpoint.
    // In production, this would call a secondary news service.
    return [];
  }

  @override
  Future<double> getLiveSpread(CurrencyPair pair) async {
    if (!_connected) return 0.0;
    try {
      final instrument = _formatInstrument(pair);
      final response = await _dio.get('/accounts/$_accountId/pricing', queryParameters: {
        "instruments": instrument
      });
      final price = response.data['prices'][0];
      final ask = double.parse(price['asks'][0]['price']);
      final bid = double.parse(price['bids'][0]['price']);
      
      double factor = instrument.contains("JPY") ? 100.0 : 10000.0;
      return (ask - bid) * factor;
    } catch (e) {
      return 0.0;
    }
  }

  @override
  Future<String> placeOrder(
    CurrencyPair pair,
    Direction direction,
    double lotSize,
    double stopLoss,
    double takeProfit,
  ) async {
    if (!_connected) throw AuthException(message: "OANDA not connected");
    
    // OANDA uses units, not lots. 1 lot = 100,000 units.
    final units = (lotSize * 100000).toInt() * (direction == Direction.long ? 1 : -1);

    final orderBody = {
      "order": {
        "units": units.toString(),
        "instrument": _formatInstrument(pair),
        "timeInForce": "FOK",
        "type": "MARKET",
        "positionFill": "DEFAULT",
        "stopLossOnFill": {
          "price": stopLoss.toStringAsFixed(5)
        },
        "takeProfitOnFill": {
          "price": takeProfit.toStringAsFixed(5)
        }
      }
    };

    logger.i('OANDA Request: POST /accounts/$_accountId/orders DATA: $orderBody');
    
    try {
      final response = await _dio.post('/accounts/$_accountId/orders', data: orderBody);
      logger.i('OANDA Response: ${response.statusCode} ${response.data}');
      
      if (response.statusCode == 201) {
        // If order was filled immediately
        if (response.data.containsKey('orderFillTransaction')) {
          return response.data['orderFillTransaction']['id'].toString();
        }
        return response.data['orderCreateTransaction']['id'].toString();
      } else {
        throw ServerException(message: "Order placement failed");
      }
    } on DioException catch (e) {
      final msg = e.response?.data['errorMessage'] ?? e.message;
      throw AppException(code: 'OANDA_ERROR', message: msg);
    }
  }

  @override
  Future<bool> closeOrder(String ticketId) async {
    try {
      final response = await _dio.put('/accounts/$_accountId/trades/$ticketId/close');
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> closeAllOrders() async {
    final trades = await getOpenTrades();
    bool allSuccess = true;
    for (var trade in trades) {
      final success = await closeOrder(trade.brokerTicketId);
      if (!success) allSuccess = false;
    }
    return allSuccess;
  }

  @override
  Future<bool> closeOrdersInProfit() async {
    final trades = await getOpenTrades();
    bool allSuccess = true;
    for (var trade in trades) {
      if (trade.currentPnl > 0) {
        final success = await closeOrder(trade.brokerTicketId);
        if (!success) allSuccess = false;
      }
    }
    return allSuccess;
  }

  @override
  Future<bool> closeOrdersAtLoss() async {
    final trades = await getOpenTrades();
    bool allSuccess = true;
    for (var trade in trades) {
      if (trade.currentPnl < 0) {
        final success = await closeOrder(trade.brokerTicketId);
        if (!success) allSuccess = false;
      }
    }
    return allSuccess;
  }

  @override
  Stream<OpenTrade> tradeUpdates() => _tradeUpdateController.stream;

  // Helpers
  String _formatInstrument(CurrencyPair pair) {
    final s = pair.name.toUpperCase();
    return "${s.substring(0, 3)}_${s.substring(3)}";
  }

  OpenTrade _parseTrade(Map<String, dynamic> data) {
    final symbol = data['instrument'].toString().replaceAll('_', '').toLowerCase();
    return OpenTrade(
      brokerTicketId: data['id'],
      pair: CurrencyPair.values.firstWhere((e) => e.name == symbol, orElse: () => CurrencyPair.eurusd),
      direction: double.parse(data['currentUnits']) > 0 ? Direction.long : Direction.short,
      entryPrice: double.parse(data['price']),
      currentPrice: double.parse(data['price']), // Will be updated by pricing stream
      lotSize: double.parse(data['initialUnits']).abs() / 100000.0,
      stopLoss: data['stopLossOrder'] != null ? double.parse(data['stopLossOrder']['price']) : 0.0,
      takeProfit: data['takeProfitOrder'] != null ? double.parse(data['takeProfitOrder']['price']) : 0.0,
      openTime: DateTime.parse(data['openTime']),
    );
  }

  void _startPricingStream() {
    _pricingTimer?.cancel();
    _pricingTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      if (!_connected) return;
      // In a real app, use OANDA's streaming endpoint. For now, we poll.
      final trades = await getOpenTrades();
      for (var trade in trades) {
        _tradeUpdateController.add(trade);
      }
    });
  }
}
