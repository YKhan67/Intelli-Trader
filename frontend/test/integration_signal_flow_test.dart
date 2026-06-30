import 'package:flutter_test/flutter_test.dart';
import 'package:forex_ai_frontend/models/models.dart';
import 'dart:convert';
import 'package:uuid/uuid.dart';

void main() {
  group('Signal Flow Logic', () {
    test('Signal Parsing and Expiry Verification', () {
      final now = DateTime.now();
      final uuid = const Uuid().v4();
      
      final rawJson = {
        'signal_id': uuid,
        'generated_at': now.toIso8601String(),
        'pair': 'EURUSD',
        'trade_decision': {
          'timestamp': now.toIso8601String(),
          'pair': 'EURUSD',
          'action': 'BUY',
          'strategy': 'TREND_FOLLOW',
          'timeframe': 'H1',
          'session': 'LONDON',
          'entry_price': 1.0850,
          'stop_loss': 1.0800,
          'take_profit': 1.1000,
          'lot_size': 0.1,
          'confidence': 0.85,
          'reason': 'Bullish trend confirmed',
        },
        'model_version': '1.0.0',
        'is_valid': true,
        'expires_at': now.add(const Duration(hours: 2)).toIso8601String(),
      };

      final signal = BackendSignal.fromJson(rawJson);
      
      expect(signal.pair, CurrencyPair.eurusd);
      expect(signal.action, SignalAction.buy);
      expect(signal.isExpired, isFalse);
      
      final expiredJson = Map<String, dynamic>.from(rawJson);
      expiredJson['expires_at'] = now.subtract(const Duration(minutes: 1)).toIso8601String();
      final expiredSignal = BackendSignal.fromJson(expiredJson);
      
      expect(expiredSignal.isExpired, isTrue);
    });
  });
}
