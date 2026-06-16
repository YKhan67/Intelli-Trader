import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:forex_ai_frontend/theme/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    // Wait for 2 seconds to show the brand
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      // Go to login/setup. The router will redirect to dashboard 
      // if already configured.
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.auto_graph, size: 80, color: AppColors.accentBlue),
            SizedBox(height: 20),
            Text(
              "ForexAI",
              style: TextStyle(
                fontSize: 32, 
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              "v1.0.0",
              style: TextStyle(color: AppColors.textSecondary),
            ),
            SizedBox(height: 40),
            CircularProgressIndicator(color: AppColors.accentBlue),
          ],
        ),
      ),
    );
  }
}
