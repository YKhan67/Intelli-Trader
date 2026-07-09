import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forex_ai_frontend/screens/dashboard/dashboard_screen.dart';
import 'package:forex_ai_frontend/state/providers.dart';
import 'package:forex_ai_frontend/services/storage_service.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'dashboard_test.mocks.dart';

@GenerateMocks([StorageService])
void main() {
  late MockStorageService mockStorage;

  setUp(() {
    mockStorage = MockStorageService();
    // Default mock behavior
    when(mockStorage.getEngineState()).thenReturn(false);
    when(mockStorage.getActivePairs()).thenReturn([]);
    when(mockStorage.getTradingMode()).thenReturn(TradingMode.normal);
    when(mockStorage.getBrokerConfig()).thenAnswer((_) async => {
      'type': BrokerType.mt5,
      'credentials': {'bridge_url': 'ws://localhost:8765'},
    });
  });

  group('Dashboard Widget Verification', () {
    testWidgets('Dashboard UI Structure', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            storageServiceProvider.overrideWithValue(mockStorage),
          ],
          child: const MaterialApp(
            home: DashboardScreen(),
          ),
        ),
      );

      // Verify header sections exist
      expect(find.text('ACTIVE SIGNALS'), findsOneWidget);
      expect(find.text('LIVE POSITIONS'), findsOneWidget);
      
      // Verify core controls exist
      expect(find.text('START ENGINE'), findsOneWidget);
      expect(find.text('STOP ENGINE'), findsOneWidget);
    });
  });
}
