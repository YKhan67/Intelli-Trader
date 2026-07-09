import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import 'core_services.dart';

final alertsProvider = StreamProvider<SystemAlert>((ref) {
  final ws = ref.watch(webSocketServiceProvider);
  return ws.alertStream;
});

final riskParamsProvider = FutureProvider<RiskParams>((ref) async {
  final api = ref.watch(backendServiceProvider);
  return api.getRisk();
});
