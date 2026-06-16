// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trade_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TradeRecordImpl _$$TradeRecordImplFromJson(Map<String, dynamic> json) =>
    _$TradeRecordImpl(
      tradeUuid: json['trade_uuid'] as String,
      brokerOrderId: json['broker_order_id'] as String?,
      pair: const CurrencyPairConverter().fromJson(json['pair'] as String),
      strategy: const StrategyConverter().fromJson(json['strategy'] as String),
      direction:
          const DirectionConverter().fromJson(json['direction'] as String),
      timeframe:
          const TimeframeConverter().fromJson(json['timeframe'] as String),
      session: const SessionConverter().fromJson(json['session'] as String),
      entryPrice: (json['entry_price'] as num).toDouble(),
      entryTime: DateTime.parse(json['entry_time'] as String),
      lotSize: (json['lot_size'] as num).toDouble(),
      stopLoss: (json['stop_loss'] as num).toDouble(),
      takeProfit: (json['take_profit'] as num).toDouble(),
      exitPrice: (json['exit_price'] as num?)?.toDouble(),
      exitTime: json['exit_time'] == null
          ? null
          : DateTime.parse(json['exit_time'] as String),
      exitReason: _$JsonConverterFromJson<String, ExitReason>(
          json['exit_reason'], const ExitReasonConverter().fromJson),
      pipsResult: (json['pips_result'] as num?)?.toDouble(),
      profitLoss: (json['profit_loss'] as num?)?.toDouble(),
      netProfitLoss: (json['net_profit_loss'] as num?)?.toDouble(),
      confidenceAtEntry: (json['confidence_at_entry'] as num).toDouble(),
      status: const OrderStatusConverter().fromJson(json['status'] as String),
    );

Map<String, dynamic> _$$TradeRecordImplToJson(_$TradeRecordImpl instance) =>
    <String, dynamic>{
      'trade_uuid': instance.tradeUuid,
      'broker_order_id': instance.brokerOrderId,
      'pair': const CurrencyPairConverter().toJson(instance.pair),
      'strategy': const StrategyConverter().toJson(instance.strategy),
      'direction': const DirectionConverter().toJson(instance.direction),
      'timeframe': const TimeframeConverter().toJson(instance.timeframe),
      'session': const SessionConverter().toJson(instance.session),
      'entry_price': instance.entryPrice,
      'entry_time': instance.entryTime.toIso8601String(),
      'lot_size': instance.lotSize,
      'stop_loss': instance.stopLoss,
      'take_profit': instance.takeProfit,
      'exit_price': instance.exitPrice,
      'exit_time': instance.exitTime?.toIso8601String(),
      'exit_reason': _$JsonConverterToJson<String, ExitReason>(
          instance.exitReason, const ExitReasonConverter().toJson),
      'pips_result': instance.pipsResult,
      'profit_loss': instance.profitLoss,
      'net_profit_loss': instance.netProfitLoss,
      'confidence_at_entry': instance.confidenceAtEntry,
      'status': const OrderStatusConverter().toJson(instance.status),
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
