import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forex_ai_frontend/models/models.dart';
import 'package:forex_ai_frontend/state/alert_provider.dart';
import 'package:forex_ai_frontend/state/core_services.dart';
import 'package:forex_ai_frontend/theme/colors.dart';
import 'package:forex_ai_frontend/utils/logger.dart';

class AlertHandlerService {
  final Ref _ref;
  GlobalKey<ScaffoldMessengerState>? _scaffoldKey;
  NavigatorState? _navigator;

  AlertHandlerService(this._ref);

  void init(GlobalKey<ScaffoldMessengerState> scaffoldKey, NavigatorState navigator) {
    _scaffoldKey = scaffoldKey;
    _navigator = navigator;
    logger.i("Alert Handler Service Initialized and Listening...");
    
    // Listen to the stream via the ref
    _ref.listen(alertStreamProvider, (prev, next) {
      if (next.hasValue) {
        _handleAlert(next.value!);
      }
    });
  }

  void _handleAlert(SystemAlert alert) async {
    // 1. Local Notification
    await _ref.read(notificationServiceProvider).showAlert(alert);

    // 2. UI Feedback
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
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("ACKNOWLEDGE"),
          ),
        ],
      ),
    );
  }
}

final alertHandlerServiceProvider = Provider((ref) => AlertHandlerService(ref));
