import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'core_services.dart';
import '../models/models.dart';

part 'alert_provider.g.dart';

@riverpod
Stream<SystemAlert> alertStream(AlertStreamRef ref) {
  final ws = ref.watch(webSocketServiceProvider);
  return ws.alertStream;
}

@Riverpod(keepAlive: true)
class UnreadAlerts extends _$UnreadAlerts {
  @override
  List<SystemAlert> build() {
    // Listen to the stream and update unread list
    ref.listen(alertStreamProvider, (prev, next) {
      if (next.hasValue) {
        state = [next.value!, ...state];
      }
    });
    return [];
  }

  void markAsRead(String alertId) {
    // Assuming SystemAlert has an id, if not we'd use hashcode or similar
    state = state.where((a) => a.hashCode.toString() != alertId).toList();
  }
}
