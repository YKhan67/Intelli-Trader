import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums.dart';
import 'converters.dart';

part 'smc_zone.freezed.dart';
part 'smc_zone.g.dart';

@freezed
class SMCZone with _$SMCZone {
  const factory SMCZone({
    required String id,
    @CurrencyPairConverter() required CurrencyPair pair,
    @TimeframeConverter() required Timeframe timeframe,
    @JsonKey(name: 'zone_type') required String zoneType,
    @JsonKey(name: 'price_high') required double priceHigh,
    @JsonKey(name: 'price_low') required double priceLow,
    @JsonKey(name: 'formed_at') DateTime? formedAt,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'is_mitigated') @Default(false) bool isMitigated,
    @Default(0.0) double strength,
  }) = _SMCZone;

  factory SMCZone.fromJson(Map<String, dynamic> json) => _$SMCZoneFromJson(json);
}
