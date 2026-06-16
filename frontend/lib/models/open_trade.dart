import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums.dart';
import 'converters.dart';

part 'open_trade.freezed.dart';
part 'open_trade.g.dart';

@freezed
class OpenTrade with _$OpenTrade {
  const factory OpenTrade({
    @JsonKey(name: 'broker_ticket_id') required String brokerTicketId,
    @CurrencyPairConverter() required CurrencyPair pair,
    @DirectionConverter() required Direction direction,
    @JsonKey(name: 'entry_price') required double entryPrice,
    @JsonKey(name: 'current_price') required double currentPrice,
    @JsonKey(name: 'lot_size') required double lotSize,
    @JsonKey(name: 'stop_loss') required double stopLoss,
    @JsonKey(name: 'take_profit') required double takeProfit,
    @JsonKey(name: 'open_time') required DateTime openTime,
  }) = _OpenTrade;

  const OpenTrade._();

  factory OpenTrade.fromJson(Map<String, dynamic> json) => _$OpenTradeFromJson(json);

  double get currentPips {
    // This is a simplified pip calculation, in reality would use pipSize from CurrencyPair
    final diff = direction == Direction.long ? (currentPrice - entryPrice) : (entryPrice - currentPrice);
    return diff * 10000; // EURUSD scale
  }

  double get currentPnl {
    // lotSize * pips * 10 (standard lot value)
    return lotSize * currentPips * 10;
  }

  double get distanceToSL => (currentPrice - stopLoss).abs();
  double get distanceToTP => (currentPrice - takeProfit).abs();
}
