import 'package:json_annotation/json_annotation.dart';
import 'enums.dart';

class CurrencyPairConverter implements JsonConverter<CurrencyPair, dynamic> {
  const CurrencyPairConverter();
  @override
  CurrencyPair fromJson(dynamic json) {
    if (json == null) return CurrencyPair.unknown;
    final String val = json.toString().toLowerCase();
    return CurrencyPair.values.firstWhere((e) => e.name == val || e.displayName.toLowerCase() == val, orElse: () => CurrencyPair.eurusd);
  }
  @override
  String toJson(CurrencyPair object) => object.name.toUpperCase();
}

class DirectionConverter implements JsonConverter<Direction, dynamic> {
  const DirectionConverter();
  @override
  Direction fromJson(dynamic json) {
    if (json == null) return Direction.neutral;
    final String val = json.toString().toUpperCase();
    if (val.contains("LONG") || val.contains("BUY")) return Direction.long;
    if (val.contains("SHORT") || val.contains("SELL")) return Direction.short;
    return Direction.neutral;
  }
  @override
  String toJson(Direction object) => object.name.toUpperCase();
}

class TimeframeConverter implements JsonConverter<Timeframe, dynamic> {
  const TimeframeConverter();
  @override
  Timeframe fromJson(dynamic json) {
    if (json == null) return Timeframe.h1;
    final String val = json.toString().toLowerCase();
    return Timeframe.values.firstWhere((e) => e.name == val, orElse: () => Timeframe.h1);
  }
  @override
  String toJson(Timeframe object) => object.name.toUpperCase();
}

class SignalActionConverter implements JsonConverter<SignalAction, dynamic> {
  const SignalActionConverter();
  @override
  SignalAction fromJson(dynamic json) {
    if (json == null) return SignalAction.hold;
    final String val = json.toString().toLowerCase();
    return SignalAction.values.firstWhere((e) => e.name == val, orElse: () => SignalAction.hold);
  }
  @override
  String toJson(SignalAction object) => object.name.toUpperCase();
}

class StrategyConverter implements JsonConverter<Strategy, dynamic> {
  const StrategyConverter();
  @override
  Strategy fromJson(dynamic json) {
    if (json == null) return Strategy.skip;
    final String val = json.toString().toLowerCase().replaceAll('_', '');
    return Strategy.values.firstWhere((e) => e.name.toLowerCase() == val, orElse: () => Strategy.skip);
  }
  @override
  String toJson(Strategy object) => object.name.toUpperCase();
}

class RegimeConverter implements JsonConverter<Regime, dynamic> {
  const RegimeConverter();
  @override
  Regime fromJson(dynamic json) {
    if (json == null) return Regime.unknown;
    final String val = json.toString().toLowerCase().replaceAll('_', '');
    return Regime.values.firstWhere((e) => e.name.toLowerCase() == val, orElse: () => Regime.unknown);
  }
  @override
  String toJson(Regime object) => object.name.toUpperCase();
}

class SessionConverter implements JsonConverter<Session, dynamic> {
  const SessionConverter();
  @override
  Session fromJson(dynamic json) {
    if (json == null) return Session.deadZone;
    final String val = json.toString().toLowerCase().replaceAll('_', '');
    return Session.values.firstWhere((e) => e.name.toLowerCase() == val, orElse: () => Session.london);
  }
  @override
  String toJson(Session object) => object.name.toUpperCase();
}

class ImpactLevelConverter implements JsonConverter<ImpactLevel, dynamic> {
  const ImpactLevelConverter();
  @override
  ImpactLevel fromJson(dynamic json) {
    if (json == null) return ImpactLevel.low;
    final String val = json.toString().toLowerCase();
    return ImpactLevel.values.firstWhere((e) => e.name == val, orElse: () => ImpactLevel.medium);
  }
  @override
  String toJson(ImpactLevel object) => object.name.toUpperCase();
}

class ExitReasonConverter implements JsonConverter<ExitReason, dynamic> {
  const ExitReasonConverter();
  @override
  ExitReason fromJson(dynamic json) {
    if (json == null) return ExitReason.manualClose;
    final String val = json.toString().toLowerCase().replaceAll('_', '');
    return ExitReason.values.firstWhere((e) => e.name.toLowerCase() == val, orElse: () => ExitReason.manualClose);
  }
  @override
  String toJson(ExitReason object) => object.name.toUpperCase();
}

class OrderStatusConverter implements JsonConverter<OrderStatus, dynamic> {
  const OrderStatusConverter();
  @override
  OrderStatus fromJson(dynamic json) {
    if (json == null) return OrderStatus.closed;
    final String val = json.toString().toLowerCase();
    return OrderStatus.values.firstWhere((e) => e.name.toLowerCase() == val, orElse: () => OrderStatus.closed);
  }
  @override
  String toJson(OrderStatus object) => object.name.toUpperCase();
}

class TradeTypeConverter implements JsonConverter<TradeType, dynamic> {
  const TradeTypeConverter();
  @override
  TradeType fromJson(dynamic json) {
    if (json == null) return TradeType.paper;
    final String val = json.toString().toLowerCase();
    return TradeType.values.firstWhere((e) => e.name.toLowerCase() == val, orElse: () => TradeType.paper);
  }
  @override
  String toJson(TradeType object) => object.name.toUpperCase();
}
