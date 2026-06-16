import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums.dart';

part 'system_alert.freezed.dart';
part 'system_alert.g.dart';

@freezed
class SystemAlert with _$SystemAlert {
  const factory SystemAlert({
    @JsonKey(name: 'alert_id') required String alertId,
    required DateTime timestamp,
    @JsonKey(name: 'alert_type') required String alertType,
    required AlertSeverity severity,
    required String message,
    required CurrencyPair? pair,
    @JsonKey(name: 'auto_resolved') required bool autoResolved,
  }) = _SystemAlert;

  factory SystemAlert.fromJson(Map<String, dynamic> json) => _$SystemAlertFromJson(json);
}
