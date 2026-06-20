// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backend_signal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BackendSignalImpl _$$BackendSignalImplFromJson(Map<String, dynamic> json) =>
    _$BackendSignalImpl(
      signalId: json['signal_id'] as String,
      generatedAt: DateTime.parse(json['generated_at'] as String),
      pair: const CurrencyPairConverter().fromJson(json['pair']),
      action: const SignalActionConverter().fromJson(json['action']),
      strategy: const StrategyConverter().fromJson(json['strategy']),
      timeframe: const TimeframeConverter().fromJson(json['timeframe']),
      session: const SessionConverter().fromJson(json['session']),
      entryPrice: (json['entry_price'] as num?)?.toDouble(),
      stopLoss: (json['stop_loss'] as num?)?.toDouble(),
      takeProfit: (json['take_profit'] as num?)?.toDouble(),
      lotSize: (json['lot_size'] as num?)?.toDouble(),
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
      reason: json['reason'] as String? ?? '',
      timeframeScores: (json['timeframe_scores'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toDouble()),
          ) ??
          const {},
      regime: json['regime'] == null
          ? Regime.unknown
          : const RegimeConverter().fromJson(json['regime']),
      regimeConfidence: (json['regime_confidence'] as num?)?.toDouble() ?? 0.0,
      strategyConfidence:
          (json['strategy_confidence'] as num?)?.toDouble() ?? 0.0,
      h4Bias: json['h4_bias'] == null
          ? Direction.neutral
          : const DirectionConverter().fromJson(json['h4_bias']),
      h1Regime: json['h1_regime'] == null
          ? Regime.unknown
          : const RegimeConverter().fromJson(json['h1_regime']),
      sentimentScore: (json['sentiment_score'] as num?)?.toDouble() ?? 0.0,
      riskScore: (json['risk_score'] as num?)?.toDouble() ?? 0.0,
      barsInRegime: (json['bars_in_regime'] as num?)?.toInt() ?? 0,
      durationWarning: json['duration_warning'] as bool? ?? false,
      isValid: json['is_valid'] as bool? ?? true,
      expiresAt: DateTime.parse(json['expires_at'] as String),
    );

Map<String, dynamic> _$$BackendSignalImplToJson(_$BackendSignalImpl instance) =>
    <String, dynamic>{
      'signal_id': instance.signalId,
      'generated_at': instance.generatedAt.toIso8601String(),
      'pair': const CurrencyPairConverter().toJson(instance.pair),
      'action': const SignalActionConverter().toJson(instance.action),
      'strategy': const StrategyConverter().toJson(instance.strategy),
      'timeframe': const TimeframeConverter().toJson(instance.timeframe),
      'session': const SessionConverter().toJson(instance.session),
      'entry_price': instance.entryPrice,
      'stop_loss': instance.stopLoss,
      'take_profit': instance.takeProfit,
      'lot_size': instance.lotSize,
      'confidence': instance.confidence,
      'reason': instance.reason,
      'timeframe_scores': instance.timeframeScores,
      'regime': const RegimeConverter().toJson(instance.regime),
      'regime_confidence': instance.regimeConfidence,
      'strategy_confidence': instance.strategyConfidence,
      'h4_bias': const DirectionConverter().toJson(instance.h4Bias),
      'h1_regime': const RegimeConverter().toJson(instance.h1Regime),
      'sentiment_score': instance.sentimentScore,
      'risk_score': instance.riskScore,
      'bars_in_regime': instance.barsInRegime,
      'duration_warning': instance.durationWarning,
      'is_valid': instance.isValid,
      'expires_at': instance.expiresAt.toIso8601String(),
    };
