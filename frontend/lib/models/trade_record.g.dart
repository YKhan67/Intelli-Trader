// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trade_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TradeRecordImpl _$$TradeRecordImplFromJson(Map<String, dynamic> json) =>
    _$TradeRecordImpl(
      tradeUuid: json['trade_uuid'] as String? ?? '',
      brokerOrderId: json['broker_order_id'] as String?,
      pair: json['pair'] == null
          ? CurrencyPair.unknown
          : const CurrencyPairConverter().fromJson(json['pair']),
      strategy: json['strategy'] == null
          ? Strategy.skip
          : const StrategyConverter().fromJson(json['strategy']),
      direction: json['direction'] == null
          ? Direction.neutral
          : const DirectionConverter().fromJson(json['direction']),
      timeframe: json['timeframe'] == null
          ? Timeframe.h1
          : const TimeframeConverter().fromJson(json['timeframe']),
      session: json['session'] == null
          ? Session.deadZone
          : const SessionConverter().fromJson(json['session']),
      regimeAtEntry: json['regime_at_entry'] == null
          ? Regime.unknown
          : const RegimeConverter().fromJson(json['regime_at_entry']),
      sentimentAtEntry: (json['sentiment_at_entry'] as num?)?.toDouble() ?? 0.0,
      confidenceAtEntry:
          (json['confidence_at_entry'] as num?)?.toDouble() ?? 0.0,
      entryPrice: (json['entry_price'] as num?)?.toDouble(),
      entryTime: json['entry_time'] == null
          ? null
          : DateTime.parse(json['entry_time'] as String),
      lotSize: (json['lot_size'] as num?)?.toDouble(),
      stopLoss: (json['stop_loss'] as num?)?.toDouble(),
      takeProfit: (json['take_profit'] as num?)?.toDouble(),
      exitPrice: (json['exit_price'] as num?)?.toDouble(),
      exitTime: json['exit_time'] == null
          ? null
          : DateTime.parse(json['exit_time'] as String),
      exitReason: json['exit_reason'] == null
          ? ExitReason.manualClose
          : const ExitReasonConverter().fromJson(json['exit_reason']),
      commission: (json['commission'] as num?)?.toDouble() ?? 0.0,
      swap: (json['swap'] as num?)?.toDouble() ?? 0.0,
      pipsResult: (json['pips_result'] as num?)?.toDouble() ?? 0.0,
      profitLoss: (json['profit_loss'] as num?)?.toDouble() ?? 0.0,
      netProfitLoss: (json['net_profit_loss'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] == null
          ? OrderStatus.closed
          : const OrderStatusConverter().fromJson(json['status']),
      tradeType: json['trade_type'] == null
          ? TradeType.paper
          : const TradeTypeConverter().fromJson(json['trade_type']),
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
      'regime_at_entry': const RegimeConverter().toJson(instance.regimeAtEntry),
      'sentiment_at_entry': instance.sentimentAtEntry,
      'confidence_at_entry': instance.confidenceAtEntry,
      'entry_price': instance.entryPrice,
      'entry_time': instance.entryTime?.toIso8601String(),
      'lot_size': instance.lotSize,
      'stop_loss': instance.stopLoss,
      'take_profit': instance.takeProfit,
      'exit_price': instance.exitPrice,
      'exit_time': instance.exitTime?.toIso8601String(),
      'exit_reason': _$JsonConverterToJson<dynamic, ExitReason>(
          instance.exitReason, const ExitReasonConverter().toJson),
      'commission': instance.commission,
      'swap': instance.swap,
      'pips_result': instance.pipsResult,
      'profit_loss': instance.profitLoss,
      'net_profit_loss': instance.netProfitLoss,
      'status': const OrderStatusConverter().toJson(instance.status),
      'trade_type': const TradeTypeConverter().toJson(instance.tradeType),
    };

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
