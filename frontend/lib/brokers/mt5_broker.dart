import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:forex_ai_frontend/models/models.dart';
import 'package:forex_ai_frontend/utils/app_exception.dart';
import 'package:forex_ai_frontend/utils/logger.dart';
import 'broker_interface.dart';

class MT5BrokerConnector implements BrokerInterface {
  WebSocketChannel? _channel;
  bool _connected = false;
  final _tradeUpdateController = StreamController<OpenTrade>.broadcast();
  
  @override
  bool get isConnected => _connected;

  @override
  String get brokerName => "MetaTrader 5";

  @override
  Future<bool> connect(Map<String, String> credentials) async {
    final url = credentials['bridge_url'] ?? 'ws://127.0.0.1:8765';
    logger.i('MT5: Connecting to bridge at $url');
    
    try {
      _channel = WebSocketChannel.connect(Uri.parse(url));
      
      _channel!.stream.listen(
        (message) => _handleIncomingMessage(message),
        onDone: () => _onDisconnected(),
        onError: (e) => _onDisconnected(error: e),
      );

      final response = await _sendCommand('PING', {});
      _connected = response['status'] == 'success';
      return _connected;
    } catch (e) {
      logger.e('MT5: Connection failed: $e');
      return false;
    }
  }

  @override
  Future<void> disconnect() async {
    await _channel?.sink.close();
    _onDisconnected();
  }

  void _onDisconnected({dynamic error}) {
    if (error != null) logger.w('MT5: Disconnected with error: $error');
    _connected = false;
    _channel = null;
  }

  @override
  Future<AccountInfo> getAccountInfo() async {
    try {
      final res = await _sendCommand('GET_ACCOUNT', {});
      if (res['status'] != 'success') throw ServerException(message: res['error'] ?? 'MT5 Fetch Account Failed');
      return AccountInfo.fromJson(res['data'] as Map<String, dynamic>);
    } catch (e) {
      logger.e('MT5 Account Parsing Error: $e');
      rethrow;
    }
  }

  @override
  Future<List<OpenTrade>> getOpenTrades() async {
    try {
      final res = await _sendCommand('GET_POSITIONS', {});
      if (res['status'] != 'success' || res['data'] == null) return [];
      
      final List positions = res['data'];
      final List<OpenTrade> trades = [];
      
      for (var p in positions) {
        try {
          trades.add(OpenTrade.fromJson(p as Map<String, dynamic>));
        } catch (e) {
          logger.e('MT5 Individual Trade Parsing Error: $e | Data: $p');
        }
      }
      return trades;
    } catch (e) {
      logger.e('MT5 getOpenTrades Top-level Error: $e');
      return [];
    }
  }

  @override
  Future<List<CalendarEvent>> getCalendar() async {
    try {
      final res = await _sendCommand('GET_CALENDAR', {});
      if (res['status'] != 'success' || res['data'] == null) return [];
      
      final List events = res['data'];
      return events.map((e) => CalendarEvent.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      logger.e('MT5 getCalendar Error: $e');
      return [];
    }
  }

  @override
  Future<double> getLiveSpread(CurrencyPair pair) async {
    try {
      final res = await _sendCommand('GET_SYMBOL', {'symbol': pair.displayName});
      if (res['status'] != 'success') return 0.0;
      return (res['data']['spread'] as num).toDouble();
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
    final payload = {
      'symbol': pair.displayName,
      'type': direction == Direction.long ? 'BUY' : 'SELL',
      'volume': lotSize,
      'sl': stopLoss,
      'tp': takeProfit,
    };
    
    final res = await _sendCommand('PLACE_ORDER', payload);
    if (res['status'] == 'success') {
      return res['ticket'].toString();
    } else {
      throw AppException(
        code: 'MT5_ERROR',
        message: res['error'] ?? 'Failed to place order',
      );
    }
  }

  @override
  Future<bool> closeOrder(String ticketId) async {
    final res = await _sendCommand('CLOSE_ORDER', {'ticket': ticketId});
    return res['status'] == 'success';
  }

  @override
  Future<bool> closeAllOrders() async => (await _sendCommand('CLOSE_ALL', {}))['status'] == 'success';

  @override
  Future<bool> closeOrdersInProfit() async => (await _sendCommand('CLOSE_PROFIT', {}))['status'] == 'success';

  @override
  Future<bool> closeOrdersAtLoss() async => (await _sendCommand('CLOSE_LOSS', {}))['status'] == 'success';

  @override
  Stream<OpenTrade> tradeUpdates() => _tradeUpdateController.stream;

  final Map<String, Completer<Map<String, dynamic>>> _pendingRequests = {};

  Future<Map<String, dynamic>> _sendCommand(String action, Map<String, dynamic> params) async {
    if (_channel == null) throw NetworkException(message: 'MT5 Bridge not connected');
    
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final command = jsonEncode({
      'id': id,
      'action': action,
      'params': params,
    });
    
    final completer = Completer<Map<String, dynamic>>();
    _pendingRequests[id] = completer;
    _channel!.sink.add(command);
    
    return completer.future.timeout(const Duration(seconds: 10), onTimeout: () {
      _pendingRequests.remove(id);
      throw TimeoutException(message: 'MT5 Bridge timeout ($action)');
    });
  }

  void _handleIncomingMessage(dynamic message) {
    try {
      final res = jsonDecode(message);
      final String? id = res['id'];
      
      if (id != null && _pendingRequests.containsKey(id)) {
        _pendingRequests.remove(id)!.complete(res);
      } else if (res['type'] == 'TRADE_UPDATE') {
        try {
          _tradeUpdateController.add(OpenTrade.fromJson(res['data']));
        } catch (e) {
          logger.e('MT5 Push Update Parsing Error: $e');
        }
      }
    } catch (e) {
      logger.e('MT5 Bridge Message Error: $e');
    }
  }
}
