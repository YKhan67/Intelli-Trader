import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forex_ai_frontend/services/backend_service.dart';
import 'package:forex_ai_frontend/services/websocket_service.dart';
import 'package:forex_ai_frontend/services/storage_service.dart';
import 'package:forex_ai_frontend/services/notification_service.dart';
import 'package:forex_ai_frontend/services/broker_service.dart';
import 'package:forex_ai_frontend/services/execution_service.dart';
export 'package:forex_ai_frontend/services/execution_service.dart' show executionServiceProvider;

final storageServiceProvider = Provider((ref) => StorageService());

final backendServiceProvider = Provider((ref) {
  final storage = ref.watch(storageServiceProvider);
  return BackendService(storage);
});

final webSocketServiceProvider = Provider((ref) => WebSocketService());

final notificationServiceProvider = Provider((ref) => NotificationService());

final brokerServiceProvider = Provider((ref) => BrokerService());
