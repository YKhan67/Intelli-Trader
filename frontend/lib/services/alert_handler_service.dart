import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forex_ai_frontend/models/models.dart';
import 'package:forex_ai_frontend/state/providers.dart';
import 'package:forex_ai_frontend/theme/colors.dart';
import 'package:forex_ai_frontend/utils/logger.dart';

class AlertHandlerService {
  final Ref _ref;
  StreamSubscription? _subscription;
  GlobalKey<ScaffoldMessengerState>? _scaffoldKey;
  NavigatorState? _navigator;

  AlertHandlerService(this._ref);

  void init(GlobalKey<ScaffoldMessengerState> scaffoldKey, NavigatorState navigator) {
    _scaffoldKey = scaffoldKey;
    _navigator = navigator;
    
    logger.i("Alert Handler Service Initialized");
    
    _subscription = _ref.read(alertStreamProvider).listen((alert) {
      _handleAlert(alert);
    });
  }

  void _handleAlert(SystemAlert alert) async {
    // 1. Local Notification
    await _ref.read(notificationServiceProvider).showAlert(alert);

    // 2. UI Feedback based on severity
    switch (alert.severity) {
      case AlertSeverity.critical:
        _showCriticalDialog(alert);
        break;
      case AlertSeverity.high:
        _showSnackBar(alert, AppColors.sellRed);
        break;
      case AlertSeverity.medium:
        _showSnackBar(alert, Colors.orange);
        break;
      case AlertSeverity.low:
      default:
        // Optional: show a small toast or just notification
        break;
    }
  }

  void _showSnackBar(SystemAlert alert, Color color) {
    _scaffoldKey?.currentState?.showSnackBar(
      SnackBar(
        backgroundColor: color,
        content: Text(
          "[${alert.alertType}] ${alert.message}",
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: "DISMISS",
          textColor: Colors.white70,
          onPressed: () {},
        ),
      ),
    );
  }

  void _showCriticalDialog(SystemAlert alert) {
    final context = _navigator?.context;
    if (context == null) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundElevated,
        title: Row(
          children: [
            const Icon(Icons.report_problem, color: AppColors.sellRed),
            const SizedBox(width: 8),
            Text("CRITICAL: ${alert.alertType}"),
          ],
        ),
        content: Text(alert.message),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.sellRed),
            onPressed: () => Navigator.pop(context),
            child: const Text("ACKNOWLEDGE & DISMISS"),
          ),
        ],
      ),
    );
  }

  void stop() {
    _subscription?.cancel();
    _subscription = null;
  }
}

final alertHandlerServiceProvider = Provider((ref) => AlertHandlerService(ref));
