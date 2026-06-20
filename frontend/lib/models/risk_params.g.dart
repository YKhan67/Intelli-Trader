// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'risk_params.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RiskParamsImpl _$$RiskParamsImplFromJson(Map<String, dynamic> json) =>
    _$RiskParamsImpl(
      lotSize: (json['lot_size'] as num?)?.toDouble() ?? 0.0,
      stopLossPips: (json['stop_loss_pips'] as num?)?.toDouble() ?? 0.0,
      takeProfitPips: (json['take_profit_pips'] as num?)?.toDouble() ?? 0.0,
      stopLossPrice: (json['stop_loss_price'] as num?)?.toDouble() ?? 0.0,
      takeProfitPrice: (json['take_profit_price'] as num?)?.toDouble() ?? 0.0,
      partialClosePrice: (json['partial_close_price'] as num?)?.toDouble(),
      breakevenPrice: (json['breakeven_price'] as num?)?.toDouble(),
      riskPercent: (json['risk_percent'] as num?)?.toDouble() ?? 0.0,
      rrRatio: (json['rr_ratio'] as num?)?.toDouble() ?? 0.0,
      dailyHalt: json['daily_halt'] as bool? ?? false,
      hardDailyHalt: json['hard_daily_halt'] as bool? ?? false,
      weeklyReview: json['weekly_review'] as bool? ?? false,
      correlatedExposure: json['correlated_exposure'] as bool? ?? false,
      riskScore: (json['risk_score'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$RiskParamsImplToJson(_$RiskParamsImpl instance) =>
    <String, dynamic>{
      'lot_size': instance.lotSize,
      'stop_loss_pips': instance.stopLossPips,
      'take_profit_pips': instance.takeProfitPips,
      'stop_loss_price': instance.stopLossPrice,
      'take_profit_price': instance.takeProfitPrice,
      'partial_close_price': instance.partialClosePrice,
      'breakeven_price': instance.breakevenPrice,
      'risk_percent': instance.riskPercent,
      'rr_ratio': instance.rrRatio,
      'daily_halt': instance.dailyHalt,
      'hard_daily_halt': instance.hardDailyHalt,
      'weekly_review': instance.weeklyReview,
      'correlated_exposure': instance.correlatedExposure,
      'risk_score': instance.riskScore,
    };
