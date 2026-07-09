import 'package:flutter_test/flutter_test.dart';
import 'package:forex_ai_frontend/models/models.dart';

void main() {
  group('Full Signal Flow Integration', () {
    test('Signal Serialization and Validity', () {
      final now = DateTime.now();
      // Models expect a flat JSON structure as the service handles flattening
      final signalJson = {
        'signal_id': 'test-sig-123',
        'generated_at': now.toIso8601String(),
        'pair': 'XAUUSD',
        'action': 'BUY',
        'strategy': 'MEAN_REVERSION',
        'timeframe': 'H1',
        'session': 'NEWYORK',
        'entry_price': 2350.50,
        'stop_loss': 2340.00,
        'take_profit': 2380.00,
        'lot_size': 0.05,
        'confidence': 0.88,
        'reason': 'Institutional demand at support',
        'model_version': 'v1.2',
        'is_valid': true,
        'expires_at': now.add(const Duration(hours: 1)).toIso8601String(),
      };

      final signal = BackendSignal.fromJson(signalJson);
      
      expect(signal.pair, CurrencyPair.xauusd);
      expect(signal.action, SignalAction.buy);
      expect(signal.confidence, 0.88);
      expect(signal.isExpired, isFalse);
    });
  });
}
