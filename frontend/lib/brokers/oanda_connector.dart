import 'package:dio/dio.dart';
import 'broker_interface.dart';
import '../models/enums.dart';

class OandaConnector implements BrokerInterface {
  late Dio _dio;
  bool _connected = false;
  String? _accountId;

  OandaConnector() {
    _dio = Dio();
  }

  @override
  bool get isConnected => _connected;

  @override
  Future<bool> connect(Map<String, String> credentials) async {
    final token = credentials['api_token'];
    _accountId = credentials['account_id'];
    final env = credentials['environment'] ?? 'practice'; // practice or live
    
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
      return _connected;
    } catch (e) {
      _connected = false;
      return false;
    }
  }

  @override
  Future<Map<String, dynamic>> getAccountInfo() async {
    if (!_connected) return {};
    try {
      final response = await _dio.get('/accounts/$_accountId/summary');
      return response.data['account'];
    } catch (e) {
      return {};
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getOpenTrades() async {
    if (!_connected) return [];
    try {
      final response = await _dio.get('/accounts/$_accountId/openTrades');
      return List<Map<String, dynamic>>.from(response.data['trades']);
    } catch (e) {
      return [];
    }
  }

  @override
  Future<String> placeOrder({
    required String pair,
    required SignalAction direction,
    required double lotSize,
    required double stopLoss,
    required double takeProfit,
  }) async {
    if (!_connected) throw Exception("OANDA not connected");
    
    final instrument = pair.replaceFirst('/', '_').toUpperCase();
    if (!instrument.contains('_')) {
      // If pair is like EURUSD, we need to convert to EUR_USD
      // OANDA uses EUR_USD format
    }
    
    final units = (lotSize * 100000).toInt() * (direction == SignalAction.buy ? 1 : -1);

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

    try {
      final response = await _dio.post('/accounts/$_accountId/orders', data: orderBody);
      if (response.statusCode == 201) {
        return response.data['orderFillTransaction']['id'].toString();
      } else {
        throw Exception("Failed to place order: ${response.data['errorMessage']}");
      }
    } catch (e) {
      throw Exception("OANDA Order Error: $e");
    }
  }

  String _formatInstrument(String pair) {
    String p = pair.toUpperCase().replaceAll('/', '').replaceAll('_', '');
    if (p.length == 6) {
      return "${p.substring(0, 3)}_${p.substring(3)}";
    }
    return pair;
  }

  @override
  Future<bool> closeTrade(String ticketId) async {
    if (!_connected) return false;
    try {
      final response = await _dio.put('/accounts/$_accountId/trades/$ticketId/close');
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> closeTradePartial(String ticketId, double percentage) async {
    if (!_connected) return false;
    try {
      // First get trade to find current units
      final tradeRes = await _dio.get('/accounts/$_accountId/trades/$ticketId');
      final currentUnits = double.parse(tradeRes.data['trade']['currentUnits']);
      final unitsToClose = (currentUnits * percentage).abs().toInt().toString();

      final response = await _dio.put(
        '/accounts/$_accountId/trades/$ticketId/close',
        data: {"units": unitsToClose},
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> updateStopLoss(String ticketId, double newStopPrice) async {
    if (!_connected) return false;
    try {
      final body = {
        "stopLoss": {
          "price": newStopPrice.toStringAsFixed(5),
          "timeInForce": "GTC"
        }
      };
      final response = await _dio.put('/accounts/$_accountId/trades/$ticketId/orders', data: body);
      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> closeAllTrades() async {
    final trades = await getOpenTrades();
    bool allSuccess = true;
    for (var trade in trades) {
      final success = await closeTrade(trade['id']);
      if (!success) allSuccess = false;
    }
    return allSuccess;
  }

  @override
  Future<double> getLiveSpread(String pair) async {
    if (!_connected) return 0.0;
    try {
      final instrument = _formatInstrument(pair);
      final response = await _dio.get('/accounts/$_accountId/pricing', queryParameters: {
        "instruments": instrument
      });
      final price = response.data['prices'][0];
      final ask = double.parse(price['asks'][0]['price']);
      final bid = double.parse(price['bids'][0]['price']);
      
      // OANDA prices are in decimals, spread is (ask - bid) * factor
      // Factor depends on the pair (usually 10000 or 100 for JPY)
      double factor = instrument.contains("JPY") ? 100.0 : 10000.0;
      return (ask - bid) * factor;
    } catch (e) {
      return 0.0;
    }
  }
}
