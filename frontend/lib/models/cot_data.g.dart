// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cot_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$COTDataImpl _$$COTDataImplFromJson(Map<String, dynamic> json) =>
    _$COTDataImpl(
      net: (json['net'] as num).toInt(),
      bias: const DirectionConverter().fromJson(json['bias']),
      strength: (json['strength'] as num).toDouble(),
    );

Map<String, dynamic> _$$COTDataImplToJson(_$COTDataImpl instance) =>
    <String, dynamic>{
      'net': instance.net,
      'bias': const DirectionConverter().toJson(instance.bias),
      'strength': instance.strength,
    };
