import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forex_ai_frontend/models/models.dart';
import 'package:forex_ai_frontend/state/providers.dart';

void main() {
  testWidgets('SignalDisplayWidget shows live data from signalProvider', (tester) async {
    // Create a mock signal
    final mockSignal = BackendSignal(
      signalId: 'test-123',
      generatedAt: DateTime.now(),
      pair: CurrencyPair.eurusd,
      action: SignalAction.buy,
      strategy: Strategy.trendFollow,
      timeframe: Timeframe.h1,
      session: Session.london,
      entryPrice: 1.1000,
      stopLoss: 1.0950,
      takeProfit: 1.1100,
      lotSize: 0.1,
      confidence: 0.85,
      reason: 'Strong trend',
      regime: Regime.trendingUp,
      regimeConfidence: 0.9,
      sentimentScore: 0.5,
      riskScore: 0.2,
      isValid: true,
      expiresAt: DateTime.now().add(const Duration(hours: 1)),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          // Override signalProvider for EURUSD to return our mock
          signalProvider(CurrencyPair.eurusd).overrideWith((ref) => Stream.value(mockSignal)),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: SignalDisplayWidget(pair: CurrencyPair.eurusd),
          ),
        ),
      ),
    );

    // Initial loading state
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Wait for stream to emit
    await tester.pumpAndSettle();

    // Verify signal data is displayed
    expect(find.text('EURUSD'), findsOneWidget);
    expect(find.text('BUY'), findsOneWidget);
    expect(find.text('Confidence: 85.0%'), findsOneWidget);
  });
}

class SignalDisplayWidget extends ConsumerWidget {
  final CurrencyPair pair;
  const SignalDisplayWidget({super.key, required this.pair});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signalAsync = ref.watch(signalProvider(pair));

    return signalAsync.when(
      data: (signal) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(signal.pair.displayName),
          Text(signal.action.name.toUpperCase()),
          Text('Confidence: ${(signal.confidence * 100).toStringAsFixed(1)}%'),
        ],
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Text('Error: $err'),
    );
  }
}
