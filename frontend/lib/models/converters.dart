import 'package:json_annotation/json_annotation.dart';
import 'enums.dart';

class CurrencyPairConverter implements JsonConverter<CurrencyPair, String> {
  const CurrencyPairConverter();

  @override
  CurrencyPair fromJson(String json) => CurrencyPair.fromString(json);

  @override
  String toJson(CurrencyPair object) => object.name.toUpperCase();
}

class DirectionConverter implements JsonConverter<Direction, String> {
  const DirectionConverter();

  @override
  Direction fromJson(String json) => Direction.fromString(json);

  @override
  String toJson(Direction object) => object.name.toUpperCase();
}

class TimeframeConverter implements JsonConverter<Timeframe, String> {
  const TimeframeConverter();

  @override
  Timeframe fromJson(String json) {
    final normalized = json.toLowerCase();
    return Timeframe.values.firstWhere(
      (e) => e.name == normalized,
      orElse: () => Timeframe.h1,
    );
  }

  @override
  String toJson(Timeframe object) => object.name.toUpperCase();
}

class SignalActionConverter implements JsonConverter<SignalAction, String> {
  const SignalActionConverter();

  @override
  SignalAction fromJson(String json) {
    final normalized = json.toLowerCase();
    return SignalAction.values.firstWhere(
      (e) => e.name == normalized,
      orElse: () => SignalAction.hold,
    );
  }

  @override
  String toJson(SignalAction object) => object.name.toUpperCase();
}

class StrategyConverter implements JsonConverter<Strategy, String> {
  const StrategyConverter();

  @override
  Strategy fromJson(String json) {
    final normalized = json.toLowerCase();
    return Strategy.values.firstWhere(
      (e) => e.name == normalized,
      orElse: () => Strategy.skip,
    );
  }

  @override
  String toJson(Strategy object) => object.name.toUpperCase();
}

class RegimeConverter implements JsonConverter<Regime, String> {
  const RegimeConverter();

  @override
  Regime fromJson(String json) {
    final normalized = json.toLowerCase();
    return Regime.values.firstWhere(
      (e) => e.name == normalized,
      orElse: () => Regime.unknown,
    );
  }

  @override
  String toJson(Regime object) => object.name.toUpperCase();
}

class SessionConverter implements JsonConverter<Session, String> {
  const SessionConverter();

  @override
  Session fromJson(String json) {
    final normalized = json.toLowerCase();
    return Session.values.firstWhere(
      (e) => e.name == normalized,
      orElse: () => Session.deadZone,
    );
  }

  @override
  String toJson(Session object) => object.name.toUpperCase();
}

class ImpactLevelConverter implements JsonConverter<ImpactLevel, String> {
  const ImpactLevelConverter();

  @override
  ImpactLevel fromJson(String json) {
    final normalized = json.toLowerCase();
    return ImpactLevel.values.firstWhere(
      (e) => e.name == normalized,
      orElse: () => ImpactLevel.low,
    );
  }

  @override
  String toJson(ImpactLevel object) => object.name.toUpperCase();
}

class ExitReasonConverter implements JsonConverter<ExitReason, String> {
  const ExitReasonConverter();

  @override
  ExitReason fromJson(String json) {
    final normalized = json.toLowerCase();
    return ExitReason.values.firstWhere(
      (e) => e.name.toLowerCase() == normalized,
      orElse: () => ExitReason.manualClose,
    );
  }

  @override
  String toJson(ExitReason object) => object.name.toUpperCase();
}

class OrderStatusConverter implements JsonConverter<OrderStatus, String> {
  const OrderStatusConverter();

  @override
  OrderStatus fromJson(String json) {
    final normalized = json.toLowerCase();
    return OrderStatus.values.firstWhere(
      (e) => e.name.toLowerCase() == normalized,
      orElse: () => OrderStatus.closed,
    );
  }

  @override
  String toJson(OrderStatus object) => object.name.toUpperCase();
}
