import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/enums.dart';

class StorageService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Backend Config
  Future<void> saveBackendConfig(String url, String apiKey) async {
    await _secureStorage.write(key: 'backend_url', value: url);
    await _secureStorage.write(key: 'backend_api_key', value: apiKey);
  }

  Future<Map<String, String?>> getBackendConfig() async {
    final url = await _secureStorage.read(key: 'backend_url');
    final apiKey = await _secureStorage.read(key: 'backend_api_key');
    return {'url': url, 'apiKey': apiKey};
  }

  // Broker Config
  Future<void> saveBrokerConfig(BrokerType type, Map<String, String> credentials) async {
    await _secureStorage.write(key: 'broker_type', value: type.name);
    await _secureStorage.write(key: 'broker_credentials', value: jsonEncode(credentials));
  }

  Future<Map<String, dynamic>> getBrokerConfig() async {
    final typeStr = await _secureStorage.read(key: 'broker_type');
    final credsStr = await _secureStorage.read(key: 'broker_credentials');
    
    return {
      'type': typeStr != null ? BrokerType.values.byName(typeStr) : null,
      'credentials': credsStr != null ? jsonDecode(credsStr) : <String, String>{},
    };
  }

  // Trading Mode
  Future<void> saveTradingMode(TradingMode mode) async {
    await _prefs.setString('trading_mode', mode.name);
  }

  TradingMode getTradingMode() {
    final modeStr = _prefs.getString('trading_mode');
    return modeStr != null ? TradingMode.values.byName(modeStr) : TradingMode.normal;
  }

  // Active Pairs
  Future<void> saveActivePairs(List<CurrencyPair> pairs) async {
    await _prefs.setStringList('active_pairs', pairs.map((e) => e.name).toList());
  }

  List<CurrencyPair> getActivePairs() {
    final list = _prefs.getStringList('active_pairs');
    if (list == null) return [CurrencyPair.eurusd];
    return list
        .map((e) => CurrencyPair.values.byName(e))
        .where((e) => e != CurrencyPair.unknown)
        .toList();
  }

  // Engine State
  Future<void> saveEngineState(bool running) async {
    await _prefs.setBool('engine_running', running);
  }

  bool getEngineState() {
    return _prefs.getBool('engine_running') ?? false;
  }

  Future<void> clearAll() async {
    await _secureStorage.deleteAll();
    await _prefs.clear();
  }
  
  Future<void> clearApiKey() async {
    await _secureStorage.delete(key: 'backend_api_key');
  }
}
