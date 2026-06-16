import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:forex_ai_frontend/models/models.dart';

void main() {
  group('Data Models Parsing', () {
    test('BackendSignal fromJson', () {
      const jsonString = '''
      {
        "signal_id": "test-uuid-123",
        "generated_at": "2023-10-27T10:00:00Z",
        "pair": "eurusd",
        "action": "buy",
        "strategy": "trendFollow",
        "timeframe": "h1",
        "session": "london",
        "entry_price": 1.05432,
        "stop_loss": 1.05000,
        "take_profit": 1.06500,
        "lot_size": 0.1,
        "confidence": 0.85,
        "reason": "Strong bullish trend",
        "regime": "trendingUp",
        "regime_confidence": 0.9,
        "sentiment_score": 0.5,
        "risk_score": 0.2,
        "is_valid": true,
        "expires_at": "2023-10-27T12:00:00Z"
      }
      ''';
      
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      final signal = BackendSignal.fromJson(jsonMap);
      
      expect(signal.signalId, 'test-uuid-123');
      expect(signal.pair, CurrencyPair.eurusd);
      expect(signal.action, SignalAction.buy);
      expect(signal.isExpired, isTrue); // Since it's 2023
    });

    test('TradeRecord fromJson/toJson', () {
      const jsonString = '''
      {
        "trade_uuid": "trade-123",
        "broker_order_id": "broker-456",
        "pair": "gbpusd",
        "strategy": "meanReversion",
        "direction": "long",
        "timeframe": "m15",
        "session": "newYork",
        "entry_price": 1.21500,
        "entry_time": "2023-10-27T14:00:00Z",
        "lot_size": 0.05,
        "stop_loss": 1.21000,
        "take_profit": 1.22500,
        "status": "open",
        "confidence_at_entry": 0.75
      }
      ''';

      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      final trade = TradeRecord.fromJson(jsonMap);
      
      expect(trade.tradeUuid, 'trade-123');
      expect(trade.status, OrderStatus.open);
      
      final backToJson = trade.toJson();
      expect(backToJson['trade_uuid'], 'trade-123');
      expect(backToJson['status'], 'open');
    });
  });
}
