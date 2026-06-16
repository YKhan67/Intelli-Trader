import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/backend_service.dart';
import '../services/websocket_service.dart';
import '../services/storage_service.dart';
import '../services/notification_service.dart';
import '../services/broker_service.dart';

final storageServiceProvider = Provider((ref) => StorageService());

final backendServiceProvider = Provider((ref) {
  final storage = ref.watch(storageServiceProvider);
  return BackendService(storage);
});

final webSocketServiceProvider = Provider((ref) => WebSocketService());

final notificationServiceProvider = Provider((ref) => NotificationService());

final brokerServiceProvider = Provider((ref) => BrokerService());
