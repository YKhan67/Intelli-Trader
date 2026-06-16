/// README: Entry point for the ForexAI Trading System frontend.
/// Wraps the app in ProviderScope for Riverpod and sets up the root widget.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forex_ai_frontend/navigation/app_router.dart';
import 'package:forex_ai_frontend/theme/app_theme.dart';
import 'package:forex_ai_frontend/state/services_provider.dart';
import 'package:forex_ai_frontend/utils/logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (details) {
    logger.e('FLUTTER ERROR: ${details.exception}');
    debugPrint(details.stack.toString());
  };
  
  // Create a container to initialize services before app start
  final container = ProviderContainer();
  await container.read(storageServiceProvider).init();
  
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
