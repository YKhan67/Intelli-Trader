// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AccountInfoImpl _$$AccountInfoImplFromJson(Map<String, dynamic> json) =>
    _$AccountInfoImpl(
      balance: (json['balance'] as num).toDouble(),
      equity: (json['equity'] as num).toDouble(),
      margin: (json['margin'] as num).toDouble(),
      freeMargin: (json['free_margin'] as num).toDouble(),
      marginLevel: (json['margin_level'] as num).toDouble(),
      currency: json['currency'] as String,
      brokerName: json['broker_name'] as String,
      accountNumber: json['account_number'] as String,
      leverage: (json['leverage'] as num).toDouble(),
    );

Map<String, dynamic> _$$AccountInfoImplToJson(_$AccountInfoImpl instance) =>
    <String, dynamic>{
      'balance': instance.balance,
      'equity': instance.equity,
      'margin': instance.margin,
      'free_margin': instance.freeMargin,
      'margin_level': instance.marginLevel,
      'currency': instance.currency,
      'broker_name': instance.brokerName,
      'account_number': instance.accountNumber,
      'leverage': instance.leverage,
    };
