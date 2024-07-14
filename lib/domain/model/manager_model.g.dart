// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manager_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ManagerModel _$ManagerModelFromJson(Map<String, dynamic> json) => ManagerModel(
      name: json['name'] as String,
      phoneNumber: json['phoneNumber'] as String,
      establishmentEnum:
          $enumDecode(_$EstablishmentsEnumEnumMap, json['establishmentEnum']),
    );

Map<String, dynamic> _$ManagerModelToJson(ManagerModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'phoneNumber': instance.phoneNumber,
      'establishmentEnum':
          _$EstablishmentsEnumEnumMap[instance.establishmentEnum]!,
    };

const _$EstablishmentsEnumEnumMap = {
  EstablishmentsEnum.riviera: 'riviera',
  EstablishmentsEnum.cdm: 'cdm',
};
