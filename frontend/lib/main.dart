import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forex_ai_frontend/navigation/app_router.dart';
import 'package:forex_ai_frontend/theme/app_theme.dart';
import 'package:forex_ai_frontend/theme/colors.dart';
import 'package:forex_ai_frontend/state/services_provider.dart';
import 'package:forex_ai_frontend/services/alert_handler_service.dart';
import 'package:forex_ai_frontend/utils/logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Custom Error Widget for the Global Error Boundary
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Material(
      color: AppColors.backgroundDark,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.bug_report, color: AppColors.sellRed, size: 64),
              const SizedBox(height: 24),
              const Text(
                "INTELLI-TRADER UI ERROR",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 12),
              Text(
                details.exception.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentBlue),
                onPressed: () => main(), // Simple restart
                child: const Text("RESTART APP"),
              )
            ],
          ),
        ),
      ),
    );
  };

  FlutterError.onError = (details) {
    logger.e('UNCAUGHT FLUTTER ERROR: ${details.exception}');
    debugPrint(details.stack.toString());
  };
  
  final container = ProviderContainer();
  try {
    // 1. Initialize Core Storage
    await container.read(storageServiceProvider).init();
    
    // 2. Start Critical Execution Engine
    container.read(executionServiceProvider).start();
    
    // 3. Initialize Notifications
    await container.read(notificationServiceProvider).init();
  } catch (e) {
    logger.e("Failed to init core services: $e");
  }
  
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const ForexAIApp(),
    ),
  );
}

class ForexAIApp extends ConsumerStatefulWidget {
  const ForexAIApp({super.key});

  @override
  ConsumerState<ForexAIApp> createState() => _ForexAIAppState();
}

class _ForexAIAppState extends ConsumerState<ForexAIApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    
    // Initialize Alert Handler after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(alertHandlerServiceProvider).init(
        rootScaffoldMessengerKey,
        rootNavigatorKey.currentState!,
      );
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    logger.i("App Lifecycle Changed: $state");
    
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      // Pause connectivity to save resources/battery
      // Note: Backend will handle trade management, we just pause UI sync
      logger.i("Pausing WebSocket streams...");
      ref.read(webSocketServiceProvider).dispose(); 
    } else if (state == AppLifecycleState.resumed) {
      // Reconnect and force refresh all data
      logger.i("Resuming app: Reconnecting WebSockets...");
      _reconnectAndRefresh();
    }
  }

  Future<void> _reconnectAndRefresh() async {
    final storage = ref.read(storageServiceProvider);
    final config = await storage.getBackendConfig();
    if (config['url'] != null) {
      // Attempt reconnect
      ref.read(webSocketServiceProvider).connect(config['url']!, 'EURUSD');
      
      // Force refresh data providers
      ref.invalidate(systemStatusProvider);
      ref.invalidate(allSignalsProvider);
      ref.invalidate(openTradesProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterPrv);

    return MaterialApp.router(
      title: 'ForexAI',
      theme: AppTheme.dark(),
      routerConfig: router,
      scaffoldMessengerKey: rootScaffoldMessengerKey,
      debugShowCheckedModeBanner: false,
      builder: (context, widget) {
        // Global Error Boundary wrapper
        return widget!;
      },
    );
  }
}
