import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'services_provider.dart';
import '../brokers/broker_factory.dart';
import '../models/models.dart';

part 'connection_provider.g.dart';

enum ConnectionStatus { connected, disconnected, connecting, error }

class ConnectionState {
  final ConnectionStatus status;
  final DateTime? lastConnected;
  final String? errorMessage;
  final bool isLoading;

  ConnectionState({
    this.status = ConnectionStatus.disconnected,
    this.lastConnected,
    this.errorMessage,
    this.isLoading = false,
  });

  ConnectionState copyWith({
    ConnectionStatus? status,
    DateTime? lastConnected,
    String? errorMessage,
    bool? isLoading,
  }) {
    return ConnectionState(
      status: status ?? this.status,
      lastConnected: lastConnected ?? this.lastConnected,
      errorMessage: errorMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

@riverpod
Future<Map<String, dynamic>> systemStatus(SystemStatusRef ref) async {
  final backend = ref.watch(backendServiceProvider);
  return await backend.getStatus();
}

@riverpod
class BackendConnection extends _$BackendConnection {
  @override
  ConnectionState build() => ConnectionState();

  Future<void> connect() async {
    state = state.copyWith(status: ConnectionStatus.connecting, isLoading: true);
    try {
      final backend = ref.read(backendServiceProvider);
      final status = await backend.getStatus();
      if (status.isNotEmpty) {
        state = state.copyWith(
          status: ConnectionStatus.connected,
          lastConnected: DateTime.now(),
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          status: ConnectionStatus.error, 
          errorMessage: "Backend unavailable",
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        status: ConnectionStatus.error, 
        errorMessage: e.toString(),
        isLoading: false,
      );
    }
  }

  void disconnect() {
    state = ConnectionState();
  }
}

@riverpod
class BrokerConnection extends _$BrokerConnection {
  Timer? _reconnectTimer;

  @override
  ConnectionState build() {
    _init();
    ref.onDispose(() => _reconnectTimer?.cancel());
    return ConnectionState(status: ConnectionStatus.disconnected);
  }

  Future<void> _init() async {
    await _attemptConnection();
    _startReconnectTimer();
  }

  void _startReconnectTimer() {
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer.periodic(const Duration(seconds: 15), (timer) async {
      if (state.status != ConnectionStatus.connected && !state.isLoading) {
        await _attemptConnection();
      }
    });
  }

  Future<void> _attemptConnection() async {
    final storage = ref.read(storageServiceProvider);
    final config = await storage.getBrokerConfig();
    
    if (config['type'] != null && config['credentials'] != null) {
      final type = config['type'] as BrokerType;
      final credentials = Map<String, String>.from(config['credentials']);
      await connect(type, credentials, isAutoRetry: true);
    }
  }

  Future<bool> connect(BrokerType type, Map<String, String> credentials, {bool isAutoRetry = false}) async {
    if (!isAutoRetry) {
      state = state.copyWith(status: ConnectionStatus.connecting, isLoading: true, errorMessage: null);
    }
    
    final brokerService = ref.read(brokerServiceProvider);

    try {
      final success = await brokerService.initializeBroker(type, credentials);
      if (success) {
        state = state.copyWith(
          status: ConnectionStatus.connected,
          lastConnected: DateTime.now(),
          isLoading: false,
          errorMessage: null,
        );
        return true;
      } else {
        if (!isAutoRetry) {
          state = state.copyWith(
            status: ConnectionStatus.error, 
            errorMessage: "Connection failed. Check bridge status.",
            isLoading: false,
          );
        } else {
          state = state.copyWith(status: ConnectionStatus.disconnected, isLoading: false);
        }
        return false;
      }
    } catch (e) {
      if (!isAutoRetry) {
        state = state.copyWith(
          status: ConnectionStatus.error, 
          errorMessage: e.toString(),
          isLoading: false,
        );
      } else {
        state = state.copyWith(status: ConnectionStatus.disconnected, isLoading: false);
      }
      return false;
    }
  }

  void disconnect() {
    _reconnectTimer?.cancel();
    ref.read(brokerServiceProvider).disconnect();
    state = ConnectionState();
  }

  void notifyFailure() {
    if (state.status == ConnectionStatus.connected) {
      state = state.copyWith(status: ConnectionStatus.disconnected);
    }
  }
}
