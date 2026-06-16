import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums.dart';
import 'converters.dart';

part 'trade_record.freezed.dart';
part 'trade_record.g.dart';

@freezed
class TradeRecord with _$TradeRecord {
  const factory TradeRecord({
    @JsonKey(name: 'trade_uuid') required String tradeUuid,
    @JsonKey(name: 'broker_order_id') required String? brokerOrderId,
    @CurrencyPairConverter() required CurrencyPair pair,
    @StrategyConverter() required Strategy strategy,
    @DirectionConverter() required Direction direction,
    @TimeframeConverter() required Timeframe timeframe,
    @SessionConverter() required Session session,
    @JsonKey(name: 'entry_price') required double entryPrice,
    @JsonKey(name: 'entry_time') required DateTime entryTime,
    @JsonKey(name: 'lot_size') required double lotSize,
    @JsonKey(name: 'stop_loss') required double stopLoss,
    @JsonKey(name: 'take_profit') required double takeProfit,
    @JsonKey(name: 'exit_price') double? exitPrice,
    @JsonKey(name: 'exit_time') DateTime? exitTime,
    @ExitReasonConverter() @JsonKey(name: 'exit_reason') ExitReason? exitReason,
    @JsonKey(name: 'pips_result') double? pipsResult,
    @JsonKey(name: 'profit_loss') double? profitLoss,
    @JsonKey(name: 'net_profit_loss') double? netProfitLoss,
    @JsonKey(name: 'confidence_at_entry') required double confidenceAtEntry,
    @OrderStatusConverter() required OrderStatus status,
  }) = _TradeRecord;

  const TradeRecord._();

  factory TradeRecord.fromJson(Map<String, dynamic> json) => _$TradeRecordFromJson(json);

  bool get isProfit => (netProfitLoss ?? 0) > 0;
  
  int get durationMinutes {
    if (exitTime == null) return 0;
    return exitTime!.difference(entryTime).inMinutes;
  }
}
