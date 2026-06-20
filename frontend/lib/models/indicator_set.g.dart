// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'indicator_set.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$IndicatorSetImpl _$$IndicatorSetImplFromJson(Map<String, dynamic> json) =>
    _$IndicatorSetImpl(
      pair: json['pair'] == null
          ? CurrencyPair.unknown
          : const CurrencyPairConverter().fromJson(json['pair']),
      timeframe: json['timeframe'] == null
          ? Timeframe.h1
          : const TimeframeConverter().fromJson(json['timeframe']),
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
      ema50: (json['ema_50'] as num?)?.toDouble(),
      ema200: (json['ema_200'] as num?)?.toDouble(),
      rsi: (json['rsi'] as num?)?.toDouble(),
      macdLine: (json['macd_line'] as num?)?.toDouble(),
      macdSignal: (json['macd_signal'] as num?)?.toDouble(),
      macdHistogram: (json['macd_histogram'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$IndicatorSetImplToJson(_$IndicatorSetImpl instance) =>
    <String, dynamic>{
      'pair': const CurrencyPairConverter().toJson(instance.pair),
      'timeframe': const TimeframeConverter().toJson(instance.timeframe),
      'timestamp': instance.timestamp?.toIso8601String(),
      'ema_50': instance.ema50,
      'ema_200': instance.ema200,
      'rsi': instance.rsi,
      'macd_line': instance.macdLine,
      'macd_signal': instance.macdSignal,
      'macd_histogram': instance.macdHistogram,
    };
