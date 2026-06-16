/// README: Application-wide constants and configuration defaults.
class AppConstants {
  static const String appName = 'ForexAI';
  static const String appVersion = '1.0.0';
  
  static const String defaultBackendUrl = 'http://localhost:8000';
  static const String defaultWsUrl = 'ws://localhost:8000/ws';
  
  static const Duration requestTimeout = Duration(seconds: 30);
  static const Duration signalRefreshInterval = Duration(seconds: 5);
  static const Duration metricsRefreshInterval = Duration(minutes: 5);
  static const Duration newsRefreshInterval = Duration(minutes: 10);
  static const Duration calendarRefreshInterval = Duration(hours: 1);
}
