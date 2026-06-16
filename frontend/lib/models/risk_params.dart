import 'package:freezed_annotation/freezed_annotation.dart';

part 'risk_params.freezed.dart';
part 'risk_params.g.dart';

@freezed
class RiskParams with _$RiskParams {
  const factory RiskParams({
    @JsonKey(name: 'lot_size') required double lotSize,
    @JsonKey(name: 'stop_loss_pips') required double stopLossPips,
    @JsonKey(name: 'take_profit_pips') required double takeProfitPips,
    @JsonKey(name: 'stop_loss_price') required double stopLossPrice,
    @JsonKey(name: 'take_profit_price') required double takeProfitPrice,
    @JsonKey(name: 'partial_close_price') required double? partialClosePrice,
    @JsonKey(name: 'breakeven_price') required double? breakevenPrice,
    @JsonKey(name: 'risk_percent') required double riskPercent,
    @JsonKey(name: 'rr_ratio') required double rrRatio,
    @JsonKey(name: 'daily_halt') required bool dailyHalt,
    @JsonKey(name: 'hard_daily_halt') required bool hardDailyHalt,
    @JsonKey(name: 'weekly_review') required bool weeklyReview,
    @JsonKey(name: 'correlated_exposure') required bool correlatedExposure,
    @JsonKey(name: 'risk_score') required double riskScore,
  }) = _RiskParams;

  factory RiskParams.fromJson(Map<String, dynamic> json) => _$RiskParamsFromJson(json);
}
