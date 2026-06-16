import '../models/enums.dart';
import 'broker_interface.dart';
import 'mt4_broker.dart';
import 'mt5_broker.dart';
import 'oanda_broker.dart';

/// Factory class that creates the correct broker connector based on BrokerType enum.
class BrokerFactory {
  static BrokerInterface? _instance;

  /// Gets the currently active broker instance.
  static BrokerInterface? get instance => _instance;

  /// Creates and sets the active broker instance.
  static BrokerInterface create(BrokerType type) {
    switch (type) {
      case BrokerType.mt5:
        _instance = MT5BrokerConnector();
        break;
      case BrokerType.mt4:
        _instance = MT4BrokerConnector();
        break;
      case BrokerType.oanda:
        _instance = OandaBrokerConnector();
        break;
    }
    return _instance!;
  }

  /// Clears the active instance.
  static void destroy() {
    _instance?.disconnect();
    _instance = null;
  }
}
