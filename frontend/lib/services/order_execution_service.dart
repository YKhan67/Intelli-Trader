import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../state/engine_provider.dart';
import '../state/broker_provider.dart';
import '../state/services_provider.dart';
import '../utils/logger.dart';

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
    final engineStatus = _ref.read(engineStatusProvider);
    if (engineStatus != EngineStatus.running) {
      logger.i("Signal ignored for ${signal.pair.displayName}: Engine is stopped");
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

    final brokerState = _ref.read(brokerProvider);
    if (!brokerState.isConnected || brokerState.activeBroker == null) {
      logger.w("Signal ignored for ${signal.pair.displayName}: Broker not connected");
      return;
    }

    // Additional checks could go here (e.g. max drawdown, session check)
    
    try {
      logger.i("Executing trade for ${signal.pair.displayName} via broker...");
      
      final direction = signal.action == SignalAction.buy ? Direction.long : Direction.short;

      final ticketId = await brokerState.activeBroker!.placeOrder(
        signal.pair,
        direction,
        signal.lotSize,
        signal.stopLoss,
        signal.takeProfit,
      );
      
      logger.i("Trade placed successfully. Ticket: $ticketId");
      
      // Notify user / UI
      final notificationService = _ref.read(notificationServiceProvider);
      notificationService.showTradeNotification(
        title: "Trade Executed",
        body: "${signal.action.name.toUpperCase()} ${signal.pair.displayName} @ ${signal.entryPrice}",
      );

      // Start monitoring for partial close / exits if needed
      _startMonitoring(ticketId, signal);
      
    } catch (e) {
      logger.e("Trade execution failed for ${signal.pair.displayName}: $e");
    }
  }

  void _startMonitoring(String ticketId, BackendSignal signal) {
    // Monitor trade for dynamic exits or trail SL
    // This could be moved to a separate TradeMonitorService for better scale
  }

  void stop() {
    _signalSubscription?.cancel();
    _signalSubscription = null;
    logger.i("Order Execution Service Stopped");
  }
}

final executionServiceProvider = Provider((ref) => OrderExecutionService(ref));
