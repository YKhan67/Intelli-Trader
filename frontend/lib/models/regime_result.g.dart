// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'regime_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RegimeResultImpl _$$RegimeResultImplFromJson(Map<String, dynamic> json) =>
    _$RegimeResultImpl(
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
      pair: json['pair'] == null
          ? CurrencyPair.unknown
          : const CurrencyPairConverter().fromJson(json['pair']),
      timeframe: json['timeframe'] == null
          ? Timeframe.h1
          : const TimeframeConverter().fromJson(json['timeframe']),
      regime: json['regime'] == null
          ? Regime.unknown
          : const RegimeConverter().fromJson(json['regime']),
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
      h4Bias: json['h4_bias'] == null
          ? Direction.neutral
          : const DirectionConverter().fromJson(json['h4_bias']),
      h1Regime: json['h1_regime'] == null
          ? Regime.unknown
          : const RegimeConverter().fromJson(json['h1_regime']),
      barsInRegime: (json['bars_in_regime'] as num?)?.toInt() ?? 0,
      regimeChanged: json['regime_changed'] as bool? ?? false,
      durationWarning: json['duration_warning'] as bool? ?? false,
    );

Map<String, dynamic> _$$RegimeResultImplToJson(_$RegimeResultImpl instance) =>
    <String, dynamic>{
      'timestamp': instance.timestamp?.toIso8601String(),
      'pair': const CurrencyPairConverter().toJson(instance.pair),
      'timeframe': const TimeframeConverter().toJson(instance.timeframe),
      'regime': const RegimeConverter().toJson(instance.regime),
      'confidence': instance.confidence,
      'h4_bias': const DirectionConverter().toJson(instance.h4Bias),
      'h1_regime': const RegimeConverter().toJson(instance.h1Regime),
      'bars_in_regime': instance.barsInRegime,
      'regime_changed': instance.regimeChanged,
      'duration_warning': instance.durationWarning,
    };
