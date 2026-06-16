import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../models/models.dart';
import '../utils/app_exception.dart';
import '../utils/logger.dart';
import 'broker_interface.dart';

/// MT4BrokerConnector implementing BrokerInterface.
/// 
/// NOTE: The user must install the companion Expert Advisor (EA) in their MetaTrader 4 terminal.
/// The EA exposes a WebSocket server on localhost:8764 to bridge commands.
/// MT4 uses "Orders" for everything (Market, Limit, Stop), unlike MT5 which uses "Positions".
/// This connector handles the mapping internally.
class MT4BrokerConnector implements BrokerInterface {
  WebSocketChannel? _channel;
  bool _connected = false;
  final _tradeUpdateController = StreamController<OpenTrade>.broadcast();
  
  @override
  bool get isConnected => _connected;

  @override
  String get brokerName => "MetaTrader 4";

  @override
  Future<bool> connect(Map<String, String> credentials) async {
    final url = credentials['bridge_url'] ?? 'ws://localhost:8764';
    logger.i('MT4: Connecting to bridge at $url');
    
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
      logger.e('MT4: Connection failed: $e');
      return false;
    }
  }

  @override
  Future<void> disconnect() async {
    await _channel?.sink.close();
    _onDisconnected();
  }

  void _onDisconnected({dynamic error}) {
    if (error != null) logger.w('MT4: Disconnected with error: $error');
    _connected = false;
    _channel = null;
  }

  @override
  Future<AccountInfo> getAccountInfo() async {
    try {
      final res = await _sendCommand('GET_ACCOUNT', {});
      if (res['status'] != 'success') throw ServerException(message: res['error'] ?? 'MT4 Fetch Account Failed');
      
      final data = res['data'];
      return AccountInfo(
        balance: (data['balance'] as num).toDouble(),
        equity: (data['equity'] as num).toDouble(),
        margin: (data['margin'] as num).toDouble(),
        freeMargin: (data['free_margin'] as num).toDouble(),
        marginLevel: (data['margin_level'] as num).toDouble(),
        currency: data['currency'] ?? 'USD',
        brokerName: data['broker'] ?? 'MT4',
        accountNumber: data['login'].toString(),
        leverage: (data['leverage'] as num).toDouble(),
      );
    } catch (e) {
      logger.e('MT4 Error: $e');
      rethrow;
    }
  }

  @override
  Future<List<OpenTrade>> getOpenTrades() async {
    try {
      final res = await _sendCommand('GET_ORDERS', {'type': 'OPEN'});
      if (res['status'] != 'success') return [];
      
      final List orders = res['data'];
      return orders.map((o) => _parseOrder(o)).toList();
    } catch (e) {
      logger.e('MT4 getOpenTrades Error: $e');
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
      logger.e('MT4 getCalendar Error: $e');
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
      'cmd': direction == Direction.long ? 0 : 1, // MT4: 0=Buy, 1=Sell
      'volume': lotSize,
      'sl': stopLoss,
      'tp': takeProfit,
    };
    
    logger.i('MT4: Placing order: $payload');
    
    final res = await _sendCommand('ORDER_SEND', payload);
    logger.i('MT4 Response: $res');

    if (res['status'] == 'success') {
      return res['ticket'].toString();
    } else {
      throw AppException(
        code: res['error_code']?.toString() ?? 'MT4_EXECUTION_ERROR',
        message: res['error_message'] ?? 'Failed to place order',
      );
    }
  }

  @override
  Future<bool> closeOrder(String ticketId) async {
    final res = await _sendCommand('ORDER_CLOSE', {'ticket': ticketId});
    return res['status'] == 'success';
  }

  @override
  Future<bool> closeAllOrders() async {
    final res = await _sendCommand('CLOSE_ALL', {});
    return res['status'] == 'success';
  }

  @override
  Future<bool> closeOrdersInProfit() async {
    final res = await _sendCommand('CLOSE_PROFIT', {});
    return res['status'] == 'success';
  }

  @override
  Future<bool> closeOrdersAtLoss() async {
    final res = await _sendCommand('CLOSE_LOSS', {});
    return res['status'] == 'success';
  }

  @override
  Stream<OpenTrade> tradeUpdates() => _tradeUpdateController.stream;

  // Internal Helpers
  final Map<String, Completer<Map<String, dynamic>>> _pendingRequests = {};

  Future<Map<String, dynamic>> _sendCommand(String action, Map<String, dynamic> params) async {
    if (_channel == null) throw NetworkException(message: 'MT4 Bridge not connected');
    
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final command = jsonEncode({
      'id': id,
      'action': action,
      'params': params,
    });
    
    _channel!.sink.add(command);
    
    final completer = Completer<Map<String, dynamic>>();
    _pendingRequests[id] = completer;
    return completer.future.timeout(const Duration(seconds: 15), onTimeout: () {
      _pendingRequests.remove(id);
      throw TimeoutException(message: 'MT4 Bridge timeout');
    });
  }

  void _handleIncomingMessage(dynamic message) {
    try {
      final res = jsonDecode(message);
      final String? id = res['id'];
      
      if (id != null && _pendingRequests.containsKey(id)) {
        _pendingRequests.remove(id)!.complete(res);
      } else if (res['type'] == 'TRADE_UPDATE') {
        _tradeUpdateController.add(_parseOrder(res['data']));
      }
    } catch (e) {
      logger.e('MT4: Error parsing message: $e');
    }
  }

  OpenTrade _parseOrder(Map<String, dynamic> data) {
    return OpenTrade(
      brokerTicketId: data['ticket'].toString(),
      pair: CurrencyPair.values.firstWhere(
        (e) => e.displayName == data['symbol'],
        orElse: () => CurrencyPair.eurusd
      ),
      direction: data['cmd'] == 0 ? Direction.long : Direction.short,
      entryPrice: (data['open_price'] as num).toDouble(),
      currentPrice: (data['current_price'] as num).toDouble(),
      lotSize: (data['volume'] as num).toDouble(),
      stopLoss: (data['sl'] as num).toDouble(),
      takeProfit: (data['tp'] as num).toDouble(),
      openTime: DateTime.parse(data['time']),
    );
  }
}
