import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forex_ai_frontend/navigation/app_router.dart';
import 'package:forex_ai_frontend/theme/app_theme.dart';
import 'package:forex_ai_frontend/theme/colors.dart';
import 'package:forex_ai_frontend/state/services_provider.dart';
import 'package:forex_ai_frontend/utils/logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // GLOBAL CRASH HANDLER (No more Red Screens)
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
                onPressed: () => main(),
                child: const Text("RESTART APP"),
              )
            ],
          ),
        ),
      ),
    );
  };

  FlutterError.onError = (details) {
    logger.e('FLUTTER ERROR: ${details.exception}');
    debugPrint(details.stack.toString());
  };
  
  final container = ProviderContainer();
  try {
    await container.read(storageServiceProvider).init();
    
    // START ORDER EXECUTION SERVICE
    container.read(executionServiceProvider).start();
  } catch (e) {
    logger.e("Failed to init app services: $e");
  }
  
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const ForexAIApp(),
    ),
  );
}

class ForexAIApp extends ConsumerWidget {
  const ForexAIApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterPrv);

    return MaterialApp.router(
      title: 'ForexAI',
      theme: AppTheme.dark(),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
