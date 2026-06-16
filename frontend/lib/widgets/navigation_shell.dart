import 'package:flutter/material.dart';
import 'app_bottom_nav.dart';
import 'app_side_nav.dart';

class NavigationShell extends StatelessWidget {
  final Widget child;

  const NavigationShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
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
}
