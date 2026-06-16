import 'package:flutter_test/flutter_test.dart';
import 'package:forex_ai_frontend/services/backend_service.dart';
import 'package:forex_ai_frontend/services/storage_service.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'backend_service_test.mocks.dart';

@GenerateMocks([StorageService])
void main() {
  group('BackendService Integration', () {
    late MockStorageService storage;
    late BackendService backend;

    setUp(() async {
      storage = MockStorageService();
      when(storage.getBackendConfig()).thenAnswer((_) async => {
        'url': 'http://127.0.0.1:8005',
        'apiKey': 'dev_key'
      });
      backend = BackendService(storage);
    });

    test('getStatus returns healthy response', () async {
      final status = await backend.getStatus();
      expect(status, isA<Map<String, dynamic>>());
      expect(status['health'], anyOf(['HEALTHY', 'DEGRADED']));
      print('Backend Health: ${status['health']}');
    });
  });
}
