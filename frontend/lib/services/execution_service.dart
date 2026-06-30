import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forex_ai_frontend/models/models.dart';
import 'package:forex_ai_frontend/state/engine_provider.dart';
import 'package:forex_ai_frontend/state/connection_provider.dart';
import 'package:forex_ai_frontend/state/services_provider.dart';
import 'package:forex_ai_frontend/utils/logger.dart';

/// The most critical service in the ForexAI ecosystem.
/// Responsible for receiving AI signals and executing real broker orders.
class ExecutionService {
  final Ref _ref;
  StreamSubscription? _signalSubscription;
  
  // Safety Registry: Prevent duplicate orders for the same signal
  final Set<String> _processedSignalIds = {};
  
  // Rate Limiting: Prevent more than one order per pair every 2 minutes
  final Map<CurrencyPair, DateTime> _lastOrderTime = {};

  ExecutionService(this._ref);

  void start() {
    logger.i("INSTITUTIONAL EXECUTION SERVICE: ONLINE");
    
    final wsService = _ref.read(webSocketServiceProvider);
    _signalSubscription = wsService.signalStream.listen((signal) {
      processSignal(signal);
    });
  }

  Future<void> processSignal(BackendSignal signal) async {
    final pairName = signal.pair.displayName;
    
    // 1. GLOBAL ENGINE CHECK
    final isRunning = _ref.read(engineStateProvider);
    if (!isRunning) return;

    // 2. CONNECTION STATUS CHECK (Safety Pause)
    final backendConn = _ref.read(backendConnectionProvider);
    final brokerConn = _ref.read(brokerConnectionProvider);
    
    if (backendConn.status != ConnectionStatus.connected || 
        brokerConn.status != ConnectionStatus.connected) {
      logger.w("EXECUTION PAUSED [$pairName]: System disconnected (Backend: ${backendConn.status}, Broker: ${brokerConn.status})");
      return;
    }

    // 3. DUPLICATE PROTECTION
    if (_processedSignalIds.contains(signal.signalId)) {
      logger.d("EXECUTION BLOCKED [$pairName]: Duplicate signal ID ${signal.signalId}");
      return;
    }

    // 4. DIRECTIONAL FILTER
    if (signal.action != SignalAction.buy && signal.action != SignalAction.sell) {
      return;
    }

    // 5. RATE LIMITING (Institutional Safety)
    final now = DateTime.now();
    if (_lastOrderTime.containsKey(signal.pair)) {
      final diff = now.difference(_lastOrderTime[signal.pair]!);
      if (diff < const Duration(minutes: 2)) {
        logger.w("EXECUTION BLOCKED [$pairName]: Rate limit active (${diff.inSeconds}s since last order)");
        return;
      }
    }

    // 6. VALIDITY & EXPIRATION CHECK
    if (!signal.isValid || signal.isExpired) {
      logger.w("EXECUTION BLOCKED [$pairName]: Signal invalid or expired");
      return;
    }

    // 7. BROKER SERVICE VERIFICATION
    final brokerService = _ref.read(brokerServiceProvider);
    if (brokerService.activeBroker == null) {
      logger.e("EXECUTION FAILED [$pairName]: No active broker instance");
      return;
    }

    // 8. PRE-TRADE ACCOUNT VALIDATION
    try {
      final account = await brokerService.activeBroker!.getAccountInfo();
      if (account.marginLevel < 100.0) {
        logger.e("EXECUTION BLOCKED [$pairName]: Insufficient Margin Level (${account.marginLevel}%)");
        return;
      }
    } catch (e) {
      logger.w("EXECUTION WARNING [$pairName]: Could not verify account margin, proceeding with caution...");
    }

    // --- EXECUTION PHASE ---
    try {
      _processedSignalIds.add(signal.signalId);
      _lastOrderTime[signal.pair] = now;
      
      logger.i(">>> INITIATING ORDER: $pairName | ${signal.action.name.toUpperCase()} | Lots: ${signal.lotSize}");
      
      final direction = signal.action == SignalAction.buy ? Direction.long : Direction.short;

      final ticketId = await brokerService.activeBroker!.placeOrder(
        signal.pair,
        direction,
        signal.lotSize ?? 0.01,
        signal.stopLoss ?? 0.0,
        signal.takeProfit ?? 0.0,
      );
      
      logger.i("ORDER SUCCESSFUL [$pairName]: Ticket ID $ticketId");
      
      _ref.read(notificationServiceProvider).showTradeNotification(
        title: "Trade Executed",
        body: "${signal.action.name.toUpperCase()} $pairName @ ${signal.entryPrice}",
      );

      // Maintain registry size
      if (_processedSignalIds.length > 500) _processedSignalIds.clear();

    } catch (e) {
      logger.e("CRITICAL EXECUTION ERROR [$pairName]: $e");
      _processedSignalIds.remove(signal.signalId);
    }
  }

  void stop() {
    _signalSubscription?.cancel();
    _signalSubscription = null;
    logger.i("INSTITUTIONAL EXECUTION SERVICE: SHUTDOWN");
  }
}

final executionServiceProvider = Provider((ref) => ExecutionService(ref));
