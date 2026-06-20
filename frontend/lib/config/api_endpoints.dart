/// README: Mapping of all backend REST and WebSocket endpoints.
class ApiEndpoints {
  static const String status = '/system/status';
  static const String signal = '/market/signal';
  static const String allSignals = '/market/signals/all';
  static const String market = '/market';
  static const String news = '/market/news';
  static const String allNews = '/market/news/all';
  static const String sentimentOverview = '/market/sentiment/all';
  static const String calendar = '/market/calendar/events';
  static const String openTrades = '/trades/open';
  static const String tradeHistory = '/trades/history';
  static const String performance = '/trades/performance';
  static const String risk = '/risk';
  static const String settings = '/system/settings';
  static const String retrain = '/system/model/retrain';
  
  // WebSocket paths
  static const String liveWebSocket = '/live';
  static const String alertsWebSocket = '/alerts';
}
