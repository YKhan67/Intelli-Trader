import 'package:freezed_annotation/freezed_annotation.dart';

part 'account_info.freezed.dart';
part 'account_info.g.dart';

@freezed
class AccountInfo with _$AccountInfo {
  const factory AccountInfo({
    required double balance,
    required double equity,
    required double margin,
    @JsonKey(name: 'free_margin') required double freeMargin,
    @JsonKey(name: 'margin_level') required double marginLevel,
    required String currency,
    @JsonKey(name: 'broker_name') required String brokerName,
    @JsonKey(name: 'account_number') required String accountNumber,
    required double leverage,
  }) = _AccountInfo;

  factory AccountInfo.fromJson(Map<String, dynamic> json) => _$AccountInfoFromJson(json);
}
