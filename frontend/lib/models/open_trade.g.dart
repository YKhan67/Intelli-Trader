// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'open_trade.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OpenTradeImpl _$$OpenTradeImplFromJson(Map<String, dynamic> json) =>
    _$OpenTradeImpl(
      brokerTicketId: json['broker_ticket_id'] as String,
      pair: const CurrencyPairConverter().fromJson(json['pair'] as String),
      direction:
          const DirectionConverter().fromJson(json['direction'] as String),
      entryPrice: (json['entry_price'] as num).toDouble(),
      currentPrice: (json['current_price'] as num).toDouble(),
      lotSize: (json['lot_size'] as num).toDouble(),
      stopLoss: (json['stop_loss'] as num).toDouble(),
      takeProfit: (json['take_profit'] as num).toDouble(),
      openTime: DateTime.parse(json['open_time'] as String),
    );

Map<String, dynamic> _$$OpenTradeImplToJson(_$OpenTradeImpl instance) =>
    <String, dynamic>{
      'broker_ticket_id': instance.brokerTicketId,
      'pair': const CurrencyPairConverter().toJson(instance.pair),
      'direction': const DirectionConverter().toJson(instance.direction),
      'entry_price': instance.entryPrice,
      'current_price': instance.currentPrice,
      'lot_size': instance.lotSize,
      'stop_loss': instance.stopLoss,
      'take_profit': instance.takeProfit,
      'open_time': instance.openTime.toIso8601String(),
    };
