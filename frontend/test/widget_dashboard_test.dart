import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forex_ai_frontend/screens/dashboard/dashboard_screen.dart';

void main() {
  testWidgets('Dashboard Renders Critical Panels', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: DashboardScreen(),
        ),
      ),
    );

    // Verify presence of critical dashboard elements
    expect(find.text('ACTIVE SIGNALS'), findsOneWidget);
    expect(find.text('LIVE POSITIONS'), findsOneWidget);
    expect(find.text('START ENGINE'), findsOneWidget);
  });
}
