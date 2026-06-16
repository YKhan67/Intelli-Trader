import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models/models.dart';
import '../utils/logger.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        logger.i('Notification clicked: ${details.payload}');
      },
    );
  }

  Future<void> showAlert(SystemAlert alert) async {
    const androidDetails = AndroidNotificationDetails(
      'forexai_alerts',
      'System Alerts',
      channelDescription: 'Alerts for circuit breakers, news, and trade events',
      importance: Importance.high,
      priority: Priority.high,
    );
    
    const iosDetails = DarwinNotificationDetails();
    
    const platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      alert.hashCode,
      'ForexAI: ${alert.alertType}',
      alert.message,
      platformDetails,
      payload: alert.pair?.name,
    );
  }

  Future<void> showTradeNotification({required String title, required String body}) async {
    const androidDetails = AndroidNotificationDetails(
      'forexai_trades',
      'Trade Updates',
      importance: Importance.high,
      priority: Priority.high,
    );
    
    const platformDetails = NotificationDetails(android: androidDetails);
    
    await _notifications.show(
      DateTime.now().millisecond,
      title,
      body,
      platformDetails,
    );
  }
}
