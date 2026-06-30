import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/services_provider.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/login/login_screen.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/pair_detail/pair_detail_screen.dart';
import '../screens/trade_history/trade_history_screen.dart';
import '../screens/performance/performance_screen.dart';
import '../screens/news/news_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../widgets/navigation_shell.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

final appRouterPrv = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/',
    redirect: (context, state) async {
      final storage = ref.read(storageServiceProvider);
      final config = await storage.getBackendConfig();
      
      final hasConfig = config['url'] != null;

      final isSplash = state.matchedLocation == '/';
      final isLogin = state.matchedLocation == '/login';

      if (!hasConfig && !isLogin && !isSplash) {
        return '/login';
      }
      
      if (hasConfig && isSplash) {
        return '/dashboard';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => NavigationShell(child: child),
        routes: [
          GoRoute(
            path: '/dashboard',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/pair/:symbol',
            builder: (context, state) => PairDetailScreen(
              symbol: state.pathParameters['symbol'] ?? 'EURUSD',
            ),
          ),
          GoRoute(
            path: '/history',
            builder: (context, state) => const TradeHistoryScreen(),
          ),
          GoRoute(
            path: '/performance',
            builder: (context, state) => const PerformanceScreen(),
          ),
          GoRoute(
            path: '/news',
            builder: (context, state) => const NewsScreen(),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
    ],
  );
});
