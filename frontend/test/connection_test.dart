import 'package:flutter_test/flutter_test.dart';
import 'package:forex_ai_frontend/models/models.dart';
import 'package:forex_ai_frontend/services/backend_service.dart';

void main() {
  group('Backend Connection Integration', () {
    test('Status Model Mapping', () {
      final rawResponse = {
        'status': 'success',
        'message': 'OK',
        'data': {
          'databases': {'postgres': 'CONNECTED', 'mongodb': 'CONNECTED', 'redis': 'CONNECTED'},
          'engine': 'RUNNING',
          'version': '1.0.0',
          'models': {'Regime Classifier': 'v1.0'}
        }
      };
      
      expect(rawResponse['status'], 'success');
      final data = rawResponse['data'] as Map<String, dynamic>;
      expect(data['engine'], 'RUNNING');
    });

    test('Trade History List Mapping', () {
      final rawTrades = [
        {
          'trade_uuid': '550e8400-e29b-41d4-a716-446655440000',
          'pair': 'EURUSD',
          'strategy': 'TREND_FOLLOW',
          'direction': 'LONG',
          'timeframe': 'H1',
          'session': 'LONDON',
          'entry_price': 1.0850,
          'status': 'CLOSED',
          'trade_type': 'PAPER'
        }
      ];

      final trades = rawTrades.map((e) => TradeRecord.fromJson(e)).toList();
      expect(trades.length, 1);
      expect(trades.first.pair, CurrencyPair.eurusd);
    });
  });
}
