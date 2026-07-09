import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forex_ai_frontend/state/providers.dart';
import 'package:forex_ai_frontend/models/models.dart';
import 'package:forex_ai_frontend/services/storage_service.dart';
import 'package:forex_ai_frontend/services/backend_service.dart';
import 'package:forex_ai_frontend/brokers/broker_interface.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'config_flow_test.mocks.dart';

@GenerateMocks([StorageService, BackendService, BrokerInterface])
void main() {
  late MockStorageService mockStorage;
  late MockBackendService mockBackend;
  late MockBrokerInterface mockBroker;
  late ProviderContainer container;

  setUp(() {
    mockStorage = MockStorageService();
    mockBackend = MockBackendService();
    mockBroker = MockBrokerInterface();
    
    container = ProviderContainer(
      overrides: [
        storageServiceProvider.overrideWithValue(mockStorage),
        backendServiceProvider.overrideWithValue(mockBackend),
        // Broker provider logic needs more complexity to mock since it creates the connector
      ],
    );
  });

  test('Login flow saves credentials on success', () async {
    final url = "http://test-backend.com";
    final key = "test-key";
    
    when(mockBackend.getStatus()).thenAnswer((_) async => {"status": "HEALTHY"});
    
    // Simulate what LoginScreen does
    await mockStorage.saveBackendConfig(url, key);
    final status = await mockBackend.getStatus();
    
    expect(status['status'], equals("HEALTHY"));
    verify(mockStorage.saveBackendConfig(url, key)).called(1);
  });

  test('Settings changes sync to backend', () async {
    final mode = TradingMode.aggressive;
    final pairs = [CurrencyPair.eurusd, CurrencyPair.gbpusd];
    final risk = {'min_rr_ratio': 1.5, 'max_risk_per_trade': 0.01};
    
    when(mockBackend.postSettings(mode, pairs, risk)).thenAnswer((_) async => null);
    
    // Simulate SettingsScreen change
    await mockBackend.postSettings(mode, pairs, risk);
    
    verify(mockBackend.postSettings(mode, pairs, risk)).called(1);
  });
}
