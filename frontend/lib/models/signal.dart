import 'enums.dart';

class BackendSignal {
  final String signalId;
  final DateTime generatedAt;
  final String pair;
  final TradeDecision tradeDecision;
  final MarketRegimeResult? regimeResult;
  final RiskParameters? riskParams;
  final bool isValid;
  final DateTime expiresAt;

  BackendSignal({
    required this.signalId,
    required this.generatedAt,
    required this.pair,
    required this.tradeDecision,
    this.regimeResult,
    this.riskParams,
    required this.isValid,
    required this.expiresAt,
  });

  factory BackendSignal.fromJson(Map<String, dynamic> json) {
    return BackendSignal(
      signalId: json['signal_id'],
      generatedAt: DateTime.parse(json['generated_at']),
      pair: json['pair'],
      tradeDecision: TradeDecision.fromJson(json['trade_decision']),
      regimeResult: json['regime_result'] != null ? MarketRegimeResult.fromJson(json['regime_result']) : null,
      riskParams: json['risk_params'] != null ? RiskParameters.fromJson(json['risk_params']) : null,
      isValid: json['is_valid'],
      expiresAt: DateTime.parse(json['expires_at']),
    );
  }
}

class TradeDecision {
  final DateTime timestamp;
  final String pair;
  final SignalAction action;
  final Strategy strategy;
  final Timeframe timeframe;
  final double entryPrice;
  final double stopLoss;
  final double takeProfit;
  final double lotSize;
  final double confidence;
  final String reason;

  TradeDecision({
    required this.timestamp,
    required this.pair,
    required this.action,
    required this.strategy,
    required this.timeframe,
    required this.entryPrice,
    required this.stopLoss,
    required this.takeProfit,
    required this.lotSize,
    required this.confidence,
    required this.reason,
  });

  factory TradeDecision.fromJson(Map<String, dynamic> json) {
    return TradeDecision(
      timestamp: DateTime.parse(json['timestamp']),
      pair: json['pair'],
      action: SignalAction.values.firstWhere((e) => e.name == json['action']),
      strategy: Strategy.values.firstWhere((e) => e.name == json['strategy']),
      timeframe: Timeframe.values.firstWhere((e) => e.name == json['timeframe']),
      entryPrice: (json['entry_price'] ?? 0).toDouble(),
      stopLoss: (json['stop_loss'] ?? 0).toDouble(),
      takeProfit: (json['take_profit'] ?? 0).toDouble(),
      lotSize: (json['lot_size'] ?? 0).toDouble(),
      confidence: (json['confidence'] ?? 0).toDouble(),
      reason: json['reason'] ?? '',
    );
  }
}

class MarketRegimeResult {
  final Regime regime;
  final double confidence;
  final int barsInRegime;

  MarketRegimeResult({
    required this.regime,
    required this.confidence,
    required this.barsInRegime,
  });

  factory MarketRegimeResult.fromJson(Map<String, dynamic> json) {
    return MarketRegimeResult(
      regime: Regime.values.firstWhere((e) => e.name == json['regime']),
      confidence: (json['confidence'] ?? 0).toDouble(),
      barsInRegime: json['bars_in_regime'] ?? 0,
    );
  }
}

class RiskParameters {
  final double lotSize;
  final double stopLossPrice;
  final double takeProfitPrice;
  final double? partialClosePrice;
  final double riskScore;

  RiskParameters({
    required this.lotSize,
    required this.stopLossPrice,
    required this.takeProfitPrice,
    this.partialClosePrice,
    required this.riskScore,
  });

  factory RiskParameters.fromJson(Map<String, dynamic> json) {
    return RiskParameters(
      lotSize: (json['lot_size'] ?? 0).toDouble(),
      stopLossPrice: (json['stop_loss_price'] ?? 0).toDouble(),
      takeProfitPrice: (json['take_profit_price'] ?? 0).toDouble(),
      partialClosePrice: json['partial_close_price']?.toDouble(),
      riskScore: (json['risk_score'] ?? 0).toDouble(),
    );
  }
}
