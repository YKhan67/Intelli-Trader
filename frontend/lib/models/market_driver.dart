import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums.dart';
import 'converters.dart';

part 'market_driver.freezed.dart';
part 'market_driver.g.dart';

@freezed
class MarketDriver with _$MarketDriver {
  const factory MarketDriver({
    required String summary,
    @JsonKey(name: 'top_currency') required String topCurrency,
    @ImpactLevelConverter() @JsonKey(name: 'impact_level') @Default(ImpactLevel.low) ImpactLevel impactLevel,
  }) = _MarketDriver;

  factory MarketDriver.fromJson(Map<String, dynamic> json) => _$MarketDriverFromJson(json);
}
