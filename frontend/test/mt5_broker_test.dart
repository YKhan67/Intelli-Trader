import 'package:flutter_test/flutter_test.dart';
import 'package:forex_ai_frontend/brokers/mt5_broker.dart';

void main() {
  group('MT5BrokerConnector bridge URL normalization', () {
    test('rewrites localhost to 127.0.0.1 for WebSocket connections', () {
      expect(
        MT5BrokerConnector.normalizeBridgeUrl('ws://localhost:8765'),
        'ws://127.0.0.1:8765',
      );
    });

    test('converts HTTP backend URLs to WS bridge URLs', () {
      expect(
        MT5BrokerConnector.normalizeBridgeUrl('http://localhost:8000'),
        'ws://127.0.0.1:8000',
      );
    });
  });
}
