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

  void connect(String baseUrl, [String? _]) {
    // LOGICAL FIX 2: Explicit IPv4 to bypass Windows DNS/IPv6 resolution lag
    // We force 127.0.0.1 if localhost is provided
    String fixedUrl = baseUrl.replaceAll('localhost', '127.0.0.1');
    _lastBaseUrl = fixedUrl;
    
    final wsBaseUrl = fixedUrl.replaceFirst('http', 'ws');
    _cleanupChannels();
    _connectGlobalBridge(wsBaseUrl);
    _connectAlerts(wsBaseUrl);
  }

  void _cleanupChannels() {
    _signalChannel?.sink.close();
    _alertChannel?.sink.close();
    _signalChannel = null;
    _alertChannel = null;
  }

  void _connectGlobalBridge(String wsBaseUrl) {
    // LOGICAL FIX 3: Connect to the Global Bridge instead of individual pairs
    final url = '$wsBaseUrl/live/all';
    logger.i('Connecting to Global Communication Bridge: $url');
    
    try {
      _signalChannel = WebSocketChannel.connect(Uri.parse(url));
      _signalChannel!.stream.listen(
        (data) {
          _setConnected(true);
          _onBridgeMessage(data);
          _reconnectAttempts = 0;
        },
        onDone: () => _handleReconnect(reason: 'Global Bridge Closed'),
        onError: (e) => _handleReconnect(reason: 'Global Bridge Error: $e'),
        cancelOnError: true,
      );
    } catch (e) {
      _handleReconnect(reason: 'Handshake Failed: $e');
    }
  }

  void _connectAlerts(String wsBaseUrl) {
    final url = '$wsBaseUrl${ApiEndpoints.alertsWebSocket}';
    try {
      _alertChannel = WebSocketChannel.connect(Uri.parse(url));
      _alertChannel!.stream.listen(
        (data) => _onAlertMessage(data),
        onDone: () {},
        onError: (e) {},
      );
    } catch (e) {}
  }

  void _setConnected(bool val) {
    if (_isConnected != val) {
      _isConnected = val;
      _connectionController.add(val);
      if (val) logger.i('>>> SYSTEM CONNECTED: COMMUNICATION BRIDGE ONLINE');
    }
  }

  void _onBridgeMessage(dynamic data) {
    try {
      final json = jsonDecode(data);
      
      // Handle Global Bridge message types
      if (json['type'] == 'heartbeat') {
        // Heartbeat received - system is healthy
        return;
      }
      
      if (json['type'] == 'signal') {
        final signal = BackendSignal.fromJson(json['data']);
        _signalController.add(signal);
      }
    } catch (e) {
      // Ignore malformed heartbeat or debug packets
    }
  }

  void _onAlertMessage(dynamic data) {
    try {
      final json = jsonDecode(data);
      if (json['type'] == 'ping' || json['type'] == 'heartbeat') return;
      final alert = SystemAlert.fromJson(json);
      _alertController.add(alert);
    } catch (e) {}
  }

  void _handleReconnect({String? reason}) {
    _setConnected(false);
    if (reason != null) logger.w('Connection Warning: $reason');
    
    _reconnectAttempts++;
    final delay = min(pow(2, _reconnectAttempts).toInt(), 15);
    
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(Duration(seconds: delay), () {
      if (_lastBaseUrl != null) {
        connect(_lastBaseUrl!);
      }
    });
  }

  void dispose() {
    _reconnectTimer?.cancel();
    _cleanupChannels();
    _signalController.close();
    _alertController.close();
    _connectionController.close();
  }
}
