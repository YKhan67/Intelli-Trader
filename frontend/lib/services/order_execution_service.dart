import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forex_ai_frontend/models/models.dart';
import 'package:forex_ai_frontend/state/engine_provider.dart';
import 'package:forex_ai_frontend/state/connection_provider.dart';
import 'package:forex_ai_frontend/state/services_provider.dart';
import 'package:forex_ai_frontend/utils/logger.dart';

class OrderExecutionService {
  final Ref _ref;
  StreamSubscription? _signalSubscription;

  OrderExecutionService(this._ref);

  void start() {
    logger.i("Order Execution Service Started");
    
    // Listen to all signals from the WebSocket
    final wsService = _ref.read(webSocketServiceProvider);
    _signalSubscription = wsService.signalStream.listen((signal) {
      processSignal(signal);
    });
  }

  Future<void> processSignal(BackendSignal signal) async {
    final isRunning = _ref.read(engineStateProvider);
    if (!isRunning) {
      logger.i("Signal ignored for ${signal.pair.displayName}: Engine is stopped in UI");
      return;
    }

    if (signal.isExpired) {
      logger.i("Signal ignored for ${signal.pair.displayName}: Expired");
      return;
    }

    if (!signal.isValid) {
      logger.i("Signal ignored for ${signal.pair.displayName}: Marked invalid by backend");
      return;
    }

    if (signal.action != SignalAction.buy && signal.action != SignalAction.sell) {
      // Ignore HOLD or CLOSE signals for this automated entry flow
      return;
    }

    final connection = _ref.read(brokerConnectionProvider);
    final brokerService = _ref.read(brokerServiceProvider);
    
    if (connection.status != ConnectionStatus.connected || brokerService.activeBroker == null) {
      logger.w("Signal ignored for ${signal.pair.displayName}: Broker not connected");
      return;
    }

    try {
      logger.i("Executing trade for ${signal.pair.displayName} via broker...");
      
      final direction = signal.action == SignalAction.buy ? Direction.long : Direction.short;

      final ticketId = await brokerService.activeBroker!.placeOrder(
        signal.pair,
        direction,
        signal.lotSize ?? 0.01,
        signal.stopLoss ?? 0.0,
        signal.takeProfit ?? 0.0,
      );
      
      logger.i("Trade placed successfully. Ticket: $ticketId");
      
      // Notify user / UI
      final notificationService = _ref.read(notificationServiceProvider);
      notificationService.showTradeNotification(
        title: "Trade Executed",
        body: "${signal.action.name.toUpperCase()} ${signal.pair.displayName} @ ${signal.entryPrice}",
      );

      _startMonitoring(ticketId, signal);
      
    } catch (e) {
      logger.e("Trade execution failed for ${signal.pair.displayName}: $e");
    }
  }

  void _startMonitoring(String ticketId, BackendSignal signal) {
    // Monitor trade for dynamic exits or trail SL
  }

  void stop() {
    _signalSubscription?.cancel();
    _signalSubscription = null;
    logger.i("Order Execution Service Stopped");
  }
}

final executionServiceProvider = Provider((ref) => OrderExecutionService(ref));
