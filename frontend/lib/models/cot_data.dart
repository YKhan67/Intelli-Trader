import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums.dart';
import 'converters.dart';

part 'cot_data.freezed.dart';
part 'cot_data.g.dart';

@freezed
class COTData with _$COTData {
  const factory COTData({
    required int net,
    @DirectionConverter() required Direction bias,
    required double strength,
  }) = _COTData;

  factory COTData.fromJson(Map<String, dynamic> json) => _$COTDataFromJson(json);
}
