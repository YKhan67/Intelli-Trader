// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'regime_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RegimeResultImpl _$$RegimeResultImplFromJson(Map<String, dynamic> json) =>
    _$RegimeResultImpl(
      timestamp: DateTime.parse(json['timestamp'] as String),
      pair: const CurrencyPairConverter().fromJson(json['pair'] as String),
      timeframe:
          const TimeframeConverter().fromJson(json['timeframe'] as String),
      regime: const RegimeConverter().fromJson(json['regime'] as String),
      confidence: (json['confidence'] as num).toDouble(),
      h4Bias: const DirectionConverter().fromJson(json['h4_bias'] as String),
      h1Regime: const RegimeConverter().fromJson(json['h1_regime'] as String),
      barsInRegime: (json['bars_in_regime'] as num).toInt(),
      regimeChanged: json['regime_changed'] as bool,
      durationWarning: json['duration_warning'] as bool,
    );

Map<String, dynamic> _$$RegimeResultImplToJson(_$RegimeResultImpl instance) =>
    <String, dynamic>{
      'timestamp': instance.timestamp.toIso8601String(),
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
