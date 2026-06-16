// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ohlcv_bar.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OHLCVBarImpl _$$OHLCVBarImplFromJson(Map<String, dynamic> json) =>
    _$OHLCVBarImpl(
      pair: const CurrencyPairConverter().fromJson(json['pair'] as String),
      timeframe:
          const TimeframeConverter().fromJson(json['timeframe'] as String),
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
      open: (json['open'] as num).toDouble(),
      high: (json['high'] as num).toDouble(),
      low: (json['low'] as num).toDouble(),
      close: (json['close'] as num).toDouble(),
      volume: (json['volume'] as num).toDouble(),
      spreadPips: (json['spread_pips'] as num).toDouble(),
    );

Map<String, dynamic> _$$OHLCVBarImplToJson(_$OHLCVBarImpl instance) =>
    <String, dynamic>{
      'pair': const CurrencyPairConverter().toJson(instance.pair),
      'timeframe': const TimeframeConverter().toJson(instance.timeframe),
      'timestamp': instance.timestamp?.toIso8601String(),
      'open': instance.open,
      'high': instance.high,
      'low': instance.low,
      'close': instance.close,
      'volume': instance.volume,
      'spread_pips': instance.spreadPips,
    };
