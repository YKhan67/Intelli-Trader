import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forex_ai_frontend/navigation/app_router.dart';
import 'package:forex_ai_frontend/theme/app_theme.dart';
import 'package:forex_ai_frontend/theme/colors.dart';
import 'package:forex_ai_frontend/state/providers.dart';
import 'package:forex_ai_frontend/utils/logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final container = ProviderContainer();

  // Custom Global Error Boundary
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
              const Text("INTELLI-TRADER UI ERROR", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
              const SizedBox(height: 12),
              Text(details.exception.toString(), textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentBlue),
                onPressed: () {
                   container.dispose();
                   main();
                },
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
  };
  
  try {
    logger.i("Initializing Core Storage...");
    await container.read(storageServiceProvider).init();
    
    logger.i("Starting Execution Engine...");
    container.read(executionServiceProvider).start();
    
    logger.i("Initializing Notification Service...");
    await container.read(notificationServiceProvider).init();
  } catch (e, stack) {
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
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final navigator = rootNavigatorKey.currentState;
      if (navigator != null) {
        ref.read(alertHandlerServiceProvider).init(rootScaffoldMessengerKey, navigator);
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      logger.i("App backgrounded: Pausing connectivity...");
      ref.read(backendConnectionProvider.notifier).disconnect(); 
    } else if (state == AppLifecycleState.resumed) {
      logger.i("App resumed: Restoring connectivity...");
      ref.read(backendConnectionProvider.notifier).connect();
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
    );
  }
}
