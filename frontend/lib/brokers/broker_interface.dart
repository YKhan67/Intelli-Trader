import '../models/models.dart';

/// Abstract interface that all broker connectors must implement.
abstract class BrokerInterface {
  /// True if the connector is successfully authenticated and connected.
  bool get isConnected;

  /// The human-readable name of the broker (e.g., "OANDA", "MetaTrader 5").
  String get brokerName;

  /// Authenticates and connects to the broker using the provided [credentials].
  Future<bool> connect(Map<String, String> credentials);

  /// Disconnects from the broker and cleans up resources.
  Future<void> disconnect();

  /// Fetches the current account summary including balance, equity, and margin.
  Future<AccountInfo> getAccountInfo();

  /// Fetches the list of all currently open trades/positions.
  Future<List<OpenTrade>> getOpenTrades();

  /// Fetches economic calendar events from the broker.
  Future<List<CalendarEvent>> getCalendar();

  /// Fetches the current live spread for the specified [pair].
  Future<double> getLiveSpread(CurrencyPair pair);

  /// Places a new market order.
  /// 
  /// Returns the broker's ticket ID on success.
  /// Throws [AppException] on failure.
  Future<String> placeOrder(
    CurrencyPair pair,
    Direction direction,
    double lotSize,
    double stopLoss,
    double takeProfit,
  );

  /// Closes a specific trade by its [ticketId].
  Future<bool> closeOrder(String ticketId);

  /// Closes all open trades across all symbols.
  Future<bool> closeAllOrders();

  /// Closes only trades that are currently in profit.
  Future<bool> closeOrdersInProfit();

  /// Closes only trades that are currently in loss.
  Future<bool> closeOrdersAtLoss();

  /// Stream of real-time trade updates (open, close, price changes).
  Stream<OpenTrade> tradeUpdates();
}
