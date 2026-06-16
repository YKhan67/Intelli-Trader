import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums.dart';
import 'converters.dart';

part 'ohlcv_bar.freezed.dart';
part 'ohlcv_bar.g.dart';

@freezed
class OHLCVBar with _$OHLCVBar {
  const factory OHLCVBar({
    @CurrencyPairConverter() required CurrencyPair pair,
    @TimeframeConverter() required Timeframe timeframe,
    DateTime? timestamp,
    required double open,
    required double high,
    required double low,
    required double close,
    required double volume,
    @JsonKey(name: 'spread_pips') required double spreadPips,
  }) = _OHLCVBar;

  const OHLCVBar._();

  factory OHLCVBar.fromJson(Map<String, dynamic> json) => _$OHLCVBarFromJson(json);

  double get bodySize => (close - open).abs();
  bool get isBullish => close > open;
}
