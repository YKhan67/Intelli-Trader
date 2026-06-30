import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/connection_provider.dart';
import '../theme/colors.dart';
import 'app_bottom_nav.dart';
import 'app_side_nav.dart';

class NavigationShell extends ConsumerWidget {
  final Widget child;

  const NavigationShell({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backendConn = ref.watch(backendConnectionProvider);
    final brokerConn = ref.watch(brokerConnectionProvider);

    final showBackendBanner = backendConn.status != ConnectionStatus.connected;
    final showBrokerBanner = brokerConn.status != ConnectionStatus.connected;

    return Scaffold(
      body: Column(
        children: [
          if (showBackendBanner)
            _buildBanner(
              "Backend disconnected — reconnecting...", 
              AppColors.sellRed
            ),
          if (!showBackendBanner && showBrokerBanner)
            _buildBanner(
              "Broker disconnected — check bridge status", 
              Colors.orange
            ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth >= 600) {
                  return Row(
                    children: [
                      const AppSideNav(),
                      const VerticalDivider(thickness: 1, width: 1),
                      Expanded(child: child),
                    ],
                  );
                } else {
                  return child;
                }
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            return const AppBottomNav();
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildBanner(String message, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      color: color,
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
