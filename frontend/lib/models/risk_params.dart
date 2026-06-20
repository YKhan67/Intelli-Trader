import 'package:freezed_annotation/freezed_annotation.dart';

part 'risk_params.freezed.dart';
part 'risk_params.g.dart';

@freezed
class RiskParams with _$RiskParams {
  const factory RiskParams({
    @JsonKey(name: 'lot_size') @Default(0.0) double lotSize,
    @JsonKey(name: 'stop_loss_pips') @Default(0.0) double stopLossPips,
    @JsonKey(name: 'take_profit_pips') @Default(0.0) double takeProfitPips,
    @JsonKey(name: 'stop_loss_price') @Default(0.0) double stopLossPrice,
    @JsonKey(name: 'take_profit_price') @Default(0.0) double takeProfitPrice,
    @JsonKey(name: 'partial_close_price') double? partialClosePrice,
    @JsonKey(name: 'breakeven_price') double? breakevenPrice,
    @JsonKey(name: 'risk_percent') @Default(0.0) double riskPercent,
    @JsonKey(name: 'rr_ratio') @Default(0.0) double rrRatio,
    @JsonKey(name: 'daily_halt') @Default(false) bool dailyHalt,
    @JsonKey(name: 'hard_daily_halt') @Default(false) bool hardDailyHalt,
    @JsonKey(name: 'weekly_review') @Default(false) bool weeklyReview,
    @JsonKey(name: 'correlated_exposure') @Default(false) bool correlatedExposure,
    @JsonKey(name: 'risk_score') @Default(0.0) double riskScore,
  }) = _RiskParams;

  factory RiskParams.fromJson(Map<String, dynamic> json) => _$RiskParamsFromJson(json);
}
