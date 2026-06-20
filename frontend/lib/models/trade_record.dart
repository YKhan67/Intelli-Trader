import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums.dart';
import 'converters.dart';

part 'trade_record.freezed.dart';
part 'trade_record.g.dart';

@freezed
class TradeRecord with _$TradeRecord {
  const factory TradeRecord({
    @JsonKey(name: 'trade_uuid') @Default('') String tradeUuid,
    @JsonKey(name: 'broker_order_id') String? brokerOrderId,
    @CurrencyPairConverter() @Default(CurrencyPair.unknown) CurrencyPair pair,
    @StrategyConverter() @Default(Strategy.skip) Strategy strategy,
    @DirectionConverter() @Default(Direction.neutral) Direction direction,
    @TimeframeConverter() @Default(Timeframe.h1) Timeframe timeframe,
    @SessionConverter() @Default(Session.deadZone) Session session,
    @RegimeConverter() @JsonKey(name: 'regime_at_entry') @Default(Regime.unknown) Regime regimeAtEntry,
    @JsonKey(name: 'sentiment_at_entry') @Default(0.0) double sentimentAtEntry,
    @JsonKey(name: 'confidence_at_entry') @Default(0.0) double confidenceAtEntry,
    @JsonKey(name: 'entry_price') double? entryPrice,
    @JsonKey(name: 'entry_time') DateTime? entryTime,
    @JsonKey(name: 'lot_size') double? lotSize,
    @JsonKey(name: 'stop_loss') double? stopLoss,
    @JsonKey(name: 'take_profit') double? takeProfit,
    @JsonKey(name: 'exit_price') double? exitPrice,
    @JsonKey(name: 'exit_time') DateTime? exitTime,
    @ExitReasonConverter() @JsonKey(name: 'exit_reason') @Default(ExitReason.manualClose) ExitReason? exitReason,
    @Default(0.0) double commission,
    @Default(0.0) double swap,
    @JsonKey(name: 'pips_result') @Default(0.0) double? pipsResult,
    @JsonKey(name: 'profit_loss') @Default(0.0) double? profitLoss,
    @JsonKey(name: 'net_profit_loss') @Default(0.0) double? netProfitLoss,
    @OrderStatusConverter() @Default(OrderStatus.closed) OrderStatus status,
    @TradeTypeConverter() @JsonKey(name: 'trade_type') @Default(TradeType.paper) TradeType tradeType,
  }) = _TradeRecord;

  const TradeRecord._();

  factory TradeRecord.fromJson(Map<String, dynamic> json) => _$TradeRecordFromJson(json);

  bool get isProfit => (netProfitLoss ?? 0) > 0;
  
  Duration get duration {
    if (exitTime == null || entryTime == null) return Duration.zero;
    return exitTime!.difference(entryTime!);
  }

  String get durationString {
    final d = duration;
    if (d.inDays > 0) return '${d.inDays}d ${d.inHours % 24}h';
    if (d.inHours > 0) return '${d.inHours}h ${d.inMinutes % 60}m';
    return '${d.inMinutes}m';
  }
}
