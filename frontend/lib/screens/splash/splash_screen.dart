import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../theme/colors.dart';
import '../../state/providers.dart';
import '../../state/connection_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  String _statusMessage = "Initializing systems...";
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _controller.forward();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startInitialization();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _startInitialization() async {
    setState(() {
      _hasError = false;
      _statusMessage = "Checking configuration...";
    });

    final storage = ref.read(storageServiceProvider);
    final backendConfig = await storage.getBackendConfig();
    final brokerConfig = await storage.getBrokerConfig();

    if (backendConfig['url'] == null || brokerConfig['type'] == null) {
      // Missing configuration, go to login
      if (mounted) context.go('/login');
      return;
    }

    setState(() => _statusMessage = "Connecting to AI Backend & Broker...");

    // Attempt both connections simultaneously
    try {
      final backendFuture = ref.read(backendConnectionProvider.notifier).connect();
      
      // For broker, we need to extract credentials
      final brokerType = brokerConfig['type'];
      final credentials = Map<String, String>.from(brokerConfig['credentials'] ?? {});
      final brokerFuture = ref.read(brokerConnectionProvider.notifier).connect(brokerType, credentials);

      final results = await Future.wait([backendFuture, brokerFuture]);
      
      final backendOk = ref.read(backendConnectionProvider).status == ConnectionStatus.connected;
      final brokerOk = ref.read(brokerConnectionProvider).status == ConnectionStatus.connected;

      if (backendOk && brokerOk) {
        setState(() => _statusMessage = "All systems operational. Launching...");
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) context.go('/dashboard');
      } else {
        String err = "Connection Failed: ";
        if (!backendOk) err += "Backend unreachable. ";
        if (!brokerOk) err += "Broker bridge offline. ";
        setState(() {
          _statusMessage = err;
          _hasError = true;
        });
      }
    } catch (e) {
      setState(() {
        _statusMessage = "Initialization Error: $e";
        _hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.auto_graph, size: 100, color: AppColors.accentBlue),
                const SizedBox(height: 24),
                const Text(
                  "ForexAI",
                  style: TextStyle(
                    fontSize: 42, 
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: -1,
                  ),
                ),
                const Text(
                  "INSTITUTIONAL AI TRADING",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppColors.accentBlue,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 60),
                Text(
                  _statusMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                ),
                const SizedBox(height: 24),
                if (_hasError) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: _startInitialization,
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentBlue),
                        child: const Text("RETRY"),
                      ),
                      const SizedBox(width: 16),
                      OutlinedButton(
                        onPressed: () => context.go('/login'),
                        child: const Text("SETTINGS"),
                      ),
                    ],
                  ),
                ] else
                  const SizedBox(
                    width: 140,
                    child: LinearProgressIndicator(
                      backgroundColor: AppColors.backgroundElevated,
                      color: AppColors.accentBlue,
                      minHeight: 2,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
