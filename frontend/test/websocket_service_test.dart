import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:forex_ai_frontend/services/websocket_service.dart';
import 'package:forex_ai_frontend/models/models.dart';

void main() {
  group('WebSocketService Integration', () {
    late WebSocketService ws;

    setUp(() {
      ws = WebSocketService();
    });

    tearDown(() {
      ws.dispose();
    });

    test('receives initial signal from backend', () async {
      ws.connect('http://127.0.0.1:8005', 'EURUSD');
      
      final completer = Completer<BackendSignal>();
      final sub = ws.signalStream.listen((signal) {
        if (!completer.isCompleted) completer.complete(signal);
      });

      try {
        final signal = await completer.future.timeout(const Duration(seconds: 20));
        expect(signal, isA<BackendSignal>());
        expect(signal.pair, CurrencyPair.eurusd);
        print('Received Signal: ${signal.action} @ ${signal.entryPrice}');
      } finally {
        await sub.cancel();
      }
    });
  });
}
