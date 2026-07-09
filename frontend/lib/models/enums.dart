import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import '../theme/colors.dart';

enum CurrencyPair {
  unknown,
  eurusd,
  gbpusd,
  usdjpy,
  usdchf,
  audusd,
  nzdusd,
  usdcad,
  xauusd,
  btcusd,
  btceur;

  String get displayName => name.toUpperCase();

  static CurrencyPair fromString(String value) {
    final normalized = value.toLowerCase().replaceAll('/', '').replaceAll('_', '');
    return CurrencyPair.values.firstWhere(
      (e) => e.name == normalized,
      orElse: () => CurrencyPair.unknown,
    );
  }
}

enum Timeframe {
  m1,
  m5,
  m15,
  m30,
  h1,
  h4,
  d1;

  String get displayName => name.toUpperCase();

  int get minuteValue {
    switch (this) {
      case Timeframe.m1: return 1;
      case Timeframe.m5: return 5;
      case Timeframe.m15: return 15;
      case Timeframe.m30: return 30;
      case Timeframe.h1: return 60;
      case Timeframe.h4: return 240;
      case Timeframe.d1: return 1440;
    }
  }
}

enum Regime {
  trendingUp,
  trendingDown,
  ranging,
  breakout,
  reversal,
  volatile,
  unknown;

  String get displayName {
    switch (this) {
      case Regime.trendingUp: return 'Trending Up';
      case Regime.trendingDown: return 'Trending Down';
      case Regime.ranging: return 'Ranging';
      case Regime.breakout: return 'Breakout';
      case Regime.reversal: return 'Reversal';
      case Regime.volatile: return 'Volatile';
      case Regime.unknown: return 'Unknown';
    }
  }

  Color get color {
    switch (this) {
      case Regime.trendingUp: return AppColors.buy;
      case Regime.trendingDown: return AppColors.sell;
      case Regime.ranging: return Colors.orange;
      case Regime.breakout: return Colors.purple;
      case Regime.reversal: return Colors.blue;
      case Regime.volatile: return Colors.amber;
      case Regime.unknown: return AppColors.hold;
    }
  }
}

enum Strategy {
  trendFollow,
  meanReversion,
  breakout,
  reversal,
  scalp,
  skip;

  String get displayName {
    switch (this) {
      case Strategy.trendFollow: return 'Trend Follow';
      case Strategy.meanReversion: return 'Mean Reversion';
      case Strategy.breakout: return 'Breakout';
      case Strategy.reversal: return 'Reversal';
      case Strategy.scalp: return 'Scalp';
      case Strategy.skip: return 'Skip';
    }
  }
}

enum Session {
  asian,
  london,
  londonOpen,
  newYork,
  newYorkOpen,
  overlap,
  deadZone;

  String get displayName {
    switch (this) {
      case Session.asian: return 'Asian';
      case Session.london: return 'London';
      case Session.londonOpen: return 'London Open';
      case Session.newYork: return 'New York';
      case Session.newYorkOpen: return 'New York Open';
      case Session.overlap: return 'Overlap';
      case Session.deadZone: return 'Dead Zone';
    }
  }

  bool get isTradeable => this != Session.deadZone;
}

enum Direction {
  @JsonValue('LONG')
  long,
  @JsonValue('SHORT')
  short,
  @JsonValue('NEUTRAL')
  neutral;

  static Direction fromString(String value) {
    switch (value.toUpperCase()) {
      case 'LONG':
      case 'BUY':
        return Direction.long;
      case 'SHORT':
        return Direction.short;
      default:
        return Direction.neutral;
    }
  }
}

enum SignalAction {
  @JsonValue('BUY')
  buy,
  @JsonValue('SELL')
  sell,
  @JsonValue('HOLD')
  hold,
  @JsonValue('CLOSE')
  close;

  Color get color {
    switch (this) {
      case SignalAction.buy: return AppColors.buy;
      case SignalAction.sell: return AppColors.sell;
      case SignalAction.hold: return AppColors.hold;
      case SignalAction.close: return Colors.orange;
    }
  }
}

enum TradeType { paper, live, seeded }

enum OrderStatus { pending, open, partial, closed, cancelled }

enum ImpactLevel {
  @JsonValue('HIGH')
  high,
  @JsonValue('MEDIUM')
  medium,
  @JsonValue('LOW')
  low;

  Color get color {
    switch (this) {
      case ImpactLevel.high: return AppColors.sell;
      case ImpactLevel.medium: return Colors.orange;
      case ImpactLevel.low: return Colors.blue;
    }
  }
}

enum AlertSeverity {
  low,
  medium,
  high,
  critical;

  Color get color {
    switch (this) {
      case AlertSeverity.low: return Colors.blue;
      case AlertSeverity.medium: return Colors.orange;
      case AlertSeverity.high: return Colors.red;
      case AlertSeverity.critical: return Colors.deepPurple;
    }
  }
}

enum TradingMode { normal, aggressive, conservative }

enum BrokerType { mt4, mt5, oanda }

enum ExitReason {
  takeProfit,
  stopLoss,
  partialClose,
  manualClose,
  circuitBreaker,
  regimeChange;

  String get displayName {
    switch (this) {
      case ExitReason.takeProfit: return 'Take Profit';
      case ExitReason.stopLoss: return 'Stop Loss';
      case ExitReason.partialClose: return 'Partial Close';
      case ExitReason.manualClose: return 'Manual Close';
      case ExitReason.circuitBreaker: return 'Circuit Breaker';
      case ExitReason.regimeChange: return 'Regime Change';
    }
  }
}
