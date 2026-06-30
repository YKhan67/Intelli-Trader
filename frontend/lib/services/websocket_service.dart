import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:forex_ai_frontend/config/api_endpoints.dart';
import 'package:forex_ai_frontend/models/models.dart';
import 'package:forex_ai_frontend/utils/logger.dart';

class WebSocketService {
  WebSocketChannel? _signalChannel;
  WebSocketChannel? _alertChannel;
  
  final _signalController = StreamController<BackendSignal>.broadcast();
  final _alertController = StreamController<SystemAlert>.broadcast();
  final _connectionController = StreamController<bool>.broadcast();

  Stream<BackendSignal> get signalStream => _signalController.stream;
  Stream<SystemAlert> get alertStream => _alertController.stream;
  Stream<bool> get connectionStream => _connectionController.stream;

  bool _isConnected = false;
  bool get isConnected => _isConnected;

  Timer? _reconnectTimer;
  int _reconnectAttempts = 0;
  String? _lastBaseUrl;
  String? _lastPair;

  void connect(String baseUrl, String pair) {
    _lastBaseUrl = baseUrl;
    _lastPair = pair;
    
    final wsBaseUrl = baseUrl.replaceFirst('http', 'ws');
    _connectSignals(wsBaseUrl, pair);
    _connectAlerts(wsBaseUrl);
  }

  void _connectSignals(String wsBaseUrl, String pair) {
    final url = '$wsBaseUrl${ApiEndpoints.liveWebSocket}/$pair';
    logger.i('Connecting to Signal WebSocket: $url');
    
    try {
      _signalChannel = WebSocketChannel.connect(Uri.parse(url));
      _signalChannel!.stream.listen(
        (data) {
          _setConnected(true);
          _onSignalMessage(data);
        },
        onDone: () => _handleReconnect(),
        onError: (e) => _handleReconnect(error: e),
      );
      _reconnectAttempts = 0;
    } catch (e) {
      _handleReconnect(error: e);
    }
  }

  void _connectAlerts(String wsBaseUrl) {
    final url = '$wsBaseUrl${ApiEndpoints.alertsWebSocket}';
    logger.i('Connecting to Alerts WebSocket: $url');
    
    try {
      _alertChannel = WebSocketChannel.connect(Uri.parse(url));
      _alertChannel!.stream.listen(
        (data) => _onAlertMessage(data),
        onDone: () => {},
        onError: (e) => {},
      );
    } catch (e) {
      logger.e('Alert WebSocket connection failed: $e');
    }
  }

  void _setConnected(bool val) {
    if (_isConnected != val) {
      _isConnected = val;
      _connectionController.add(val);
    }
  }

  void _onSignalMessage(dynamic data) {
    try {
      final json = jsonDecode(data);
      if (json['type'] == 'ping') return;
      
      final signal = BackendSignal.fromJson(json);
      _signalController.add(signal);
    } catch (e) {
      logger.e('Error parsing WebSocket signal: $e');
    }
  }

  void _onAlertMessage(dynamic data) {
    try {
      final json = jsonDecode(data);
      if (json['type'] == 'ping') return;

      final alert = SystemAlert.fromJson(json);
      _alertController.add(alert);
    } catch (e) {
      logger.e('Error parsing WebSocket alert: $e');
    }
  }

  void _handleReconnect({dynamic error}) {
    _setConnected(false);
    if (error != null) logger.w('WebSocket error: $error');
    
    _reconnectAttempts++;
    final delay = min(pow(2, _reconnectAttempts).toInt(), 30);
    logger.i('Attempting WebSocket reconnect in ${delay}s...');
    
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(Duration(seconds: delay), () {
      if (_lastBaseUrl != null && _lastPair != null) {
        connect(_lastBaseUrl!, _lastPair!);
      }
    });
  }

  void dispose() {
    _reconnectTimer?.cancel();
    _signalChannel?.sink.close();
    _alertChannel?.sink.close();
    _signalController.close();
    _alertController.close();
    _connectionController.close();
  }
}
