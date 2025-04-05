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
      languageEnum: $enumDecode(_$LanguageEnumEnumMap, json['languageEnum']),
    );

Map<String, dynamic> _$ManagerModelToJson(ManagerModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'phoneNumber': instance.phoneNumber,
      'establishmentEnum':
          _$EstablishmentsEnumEnumMap[instance.establishmentEnum]!,
      'languageEnum': _$LanguageEnumEnumMap[instance.languageEnum]!,
    };

const _$EstablishmentsEnumEnumMap = {
  EstablishmentsEnum.riviera: 'riviera',
  EstablishmentsEnum.cdm: 'cdm',
};

const _$LanguageEnumEnumMap = {
  LanguageEnum.english: 'english',
  LanguageEnum.russian: 'russian',
};
