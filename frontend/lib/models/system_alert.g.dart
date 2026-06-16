// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_alert.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SystemAlertImpl _$$SystemAlertImplFromJson(Map<String, dynamic> json) =>
    _$SystemAlertImpl(
      alertId: json['alert_id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      alertType: json['alert_type'] as String,
      severity: $enumDecode(_$AlertSeverityEnumMap, json['severity']),
      message: json['message'] as String,
      pair: $enumDecodeNullable(_$CurrencyPairEnumMap, json['pair']),
      autoResolved: json['auto_resolved'] as bool,
    );

Map<String, dynamic> _$$SystemAlertImplToJson(_$SystemAlertImpl instance) =>
    <String, dynamic>{
      'alert_id': instance.alertId,
      'timestamp': instance.timestamp.toIso8601String(),
      'alert_type': instance.alertType,
      'severity': _$AlertSeverityEnumMap[instance.severity]!,
      'message': instance.message,
      'pair': _$CurrencyPairEnumMap[instance.pair],
      'auto_resolved': instance.autoResolved,
    };

const _$AlertSeverityEnumMap = {
  AlertSeverity.low: 'low',
  AlertSeverity.medium: 'medium',
  AlertSeverity.high: 'high',
  AlertSeverity.critical: 'critical',
};

const _$CurrencyPairEnumMap = {
  CurrencyPair.unknown: 'unknown',
  CurrencyPair.eurusd: 'eurusd',
  CurrencyPair.gbpusd: 'gbpusd',
  CurrencyPair.usdjpy: 'usdjpy',
  CurrencyPair.usdchf: 'usdchf',
  CurrencyPair.audusd: 'audusd',
  CurrencyPair.nzdusd: 'nzdusd',
  CurrencyPair.usdcad: 'usdcad',
  CurrencyPair.xauusd: 'xauusd',
  CurrencyPair.btcusd: 'btcusd',
};
