import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:forex_ai_frontend/models/models.dart';
import 'package:forex_ai_frontend/state/engine_provider.dart';
import 'package:forex_ai_frontend/state/connection_provider.dart';
import 'package:forex_ai_frontend/state/core_services.dart';
import 'package:forex_ai_frontend/utils/logger.dart';

/// The most critical service in the ForexAI ecosystem.
/// Responsible for receiving AI signals and executing real broker orders.
class ExecutionService {
  final Ref _ref;
  StreamSubscription? _signalSubscription;
  
  // Persistent Safety Registry: Prevent duplicate orders for the same signal
  final Set<String> _processedSignalIds = {};
  
  // Rate Limiting: Prevent more than one order per pair every 2 minutes
  final Map<CurrencyPair, DateTime> _lastOrderTime = {};

  ExecutionService(this._ref);

  Future<void> start() async {
    logger.i("INSTITUTIONAL EXECUTION SERVICE: ONLINE");
    
    // Load persisted signal IDs to prevent duplicate entries after app restart
    await _loadProcessedIds();
    
    final wsService = _ref.read(webSocketServiceProvider);
    _signalSubscription = wsService.signalStream.listen((signal) {
      processSignal(signal);
    });
  }

  Future<void> _loadProcessedIds() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final ids = prefs.getStringList('processed_signal_ids') ?? [];
      _processedSignalIds.addAll(ids);
      logger.d("Loaded ${_processedSignalIds.length} processed signal IDs from storage");
    } catch (e) {
      logger.e("Failed to load signal registry: $e");
    }
  }

  Future<void> _persistSignalId(String id) async {
    _processedSignalIds.add(id);
    try {
      final prefs = await SharedPreferences.getInstance();
      // Keep only the last 100 IDs to avoid slowing down SharedPreferences
      final listToSave = _processedSignalIds.toList();
      if (listToSave.length > 100) {
        listToSave.removeRange(0, listToSave.length - 100);
      }
      await prefs.setStringList('processed_signal_ids', listToSave);
    } catch (e) {
      logger.e("Failed to persist signal registry: $e");
    }
  }

  Future<void> processSignal(BackendSignal signal) async {
    final pairName = signal.pair.displayName;
    
    // 1. GLOBAL ENGINE CHECK
    final isRunning = _ref.read(engineStateProvider);
    if (!isRunning) return;

    // 2. CONNECTION STATUS CHECK
    final backendConn = _ref.read(backendConnectionProvider);
    final brokerConn = _ref.read(brokerConnectionProvider);
    
    if (backendConn.status != ConnectionStatus.connected || 
        brokerConn.status != ConnectionStatus.connected) {
      logger.w("EXECUTION PAUSED [$pairName]: System disconnected");
      return;
    }

    // 3. PERSISTENT DUPLICATE PROTECTION
    if (_processedSignalIds.contains(signal.signalId)) {
      return;
    }

    // 4. DIRECTIONAL FILTER
    if (signal.action != SignalAction.buy && signal.action != SignalAction.sell) {
      return;
    }

    // 5. RATE LIMITING
    final now = DateTime.now();
    if (_lastOrderTime.containsKey(signal.pair)) {
      final diff = now.difference(_lastOrderTime[signal.pair]!);
      if (diff < const Duration(minutes: 5)) { // Extended to 5m for institutional safety
        logger.w("EXECUTION BLOCKED [$pairName]: Cooling down (${diff.inSeconds}s since last order)");
        return;
      }
    }

    // 6. VALIDITY & EXPIRATION
    if (!signal.isValid || signal.isExpired) {
      logger.w("EXECUTION BLOCKED [$pairName]: Signal invalid or expired");
      return;
    }

    // 7. BROKER SERVICE VERIFICATION
    final brokerService = _ref.read(brokerServiceProvider);
    if (brokerService.activeBroker == null) {
      logger.e("EXECUTION FAILED [$pairName]: No active broker");
      return;
    }

    // 8. PRE-TRADE ACCOUNT VALIDATION (Real MT5 Balance Check)
    try {
      final account = await brokerService.activeBroker!.getAccountInfo();
      if (account.marginLevel < 200.0) { // Raised to 200% for institutional grade
        logger.e("EXECUTION BLOCKED [$pairName]: Low Margin Level (${account.marginLevel}%)");
        return;
      }
    } catch (e) {
      logger.w("EXECUTION WARNING [$pairName]: Margin check failed, proceeding...");
    }

    // --- EXECUTION PHASE ---
    try {
      await _persistSignalId(signal.signalId);
      _lastOrderTime[signal.pair] = now;
      
      logger.i(">>> INITIATING INSTITUTIONAL ORDER: $pairName | ${signal.action.name.toUpperCase()} | Lots: ${signal.lotSize}");
      
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
        title: "Institutional Entry: ${signal.pair.displayName}",
        body: "${signal.action.name.toUpperCase()} executed @ ${signal.entryPrice}",
      );

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
