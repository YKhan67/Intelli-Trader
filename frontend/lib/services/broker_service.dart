import '../brokers/broker_interface.dart';
import '../brokers/broker_factory.dart';
import '../models/models.dart';

class BrokerService {
  BrokerInterface? get activeBroker => BrokerFactory.instance;

  Future<bool> initializeBroker(BrokerType type, Map<String, String> credentials) async {
    final broker = BrokerFactory.create(type);
    final success = await broker.connect(credentials);
    return success;
  }

  Future<AccountInfo?> getAccountSummary() async {
    if (activeBroker == null) return null;
    return await activeBroker!.getAccountInfo();
  }

  Future<List<OpenTrade>> getActiveTrades() async {
    if (activeBroker == null) return [];
    return await activeBroker!.getOpenTrades();
  }

  Future<String> executeTrade({
    required CurrencyPair pair,
    required Direction direction,
    required double lots,
    double sl = 0,
    double tp = 0,
  }) async {
    if (activeBroker == null) throw Exception("No active broker connection");
    
    return await activeBroker!.placeOrder(
      pair,
      direction,
      lots,
      sl,
      tp,
    );
  }

  Future<void> disconnect() async {
    await activeBroker?.disconnect();
    BrokerFactory.destroy();
  }
}
