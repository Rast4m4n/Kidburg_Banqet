// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:kidburg_banquet/domain/model/establishments_enum.dart';

part 'manager_model.g.dart';

@JsonSerializable(converters: [LocaleConverter()])
class ManagerModel {
  ManagerModel({
    required this.name,
    required this.phoneNumber,
    required this.establishmentEnum,
    required this.locale,
  });

  final String name;
  final String phoneNumber;

  /// Заведение с конкретными местами проведения мероприятие
  /// Файл establishments_enum, где есть перечисления заведений
  /// Файл place_event_enum, где перечисляются места проведения мероприятия
  final EstablishmentsEnum establishmentEnum;
  final Locale locale;

  ManagerModel copyWith({
    String? name,
    String? phoneNumber,
    EstablishmentsEnum? establishmentEnum,
    Locale? locale,
  }) {
    return ManagerModel(
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      establishmentEnum: establishmentEnum ?? this.establishmentEnum,
      locale: locale ?? this.locale,
    );
  }

  Map<String, dynamic> toMap() => _$ManagerModelToJson(this);

  factory ManagerModel.fromMap(Map<String, dynamic> map) =>
      _$ManagerModelFromJson(map);

  String toJson() => json.encode(toMap());

  factory ManagerModel.fromJson(String source) =>
      ManagerModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'ManagerModel(name: $name, phoneNumber: $phoneNumber, establishmentEnum: $establishmentEnum) language: ${locale.toLanguageTag()}';
}

class LocaleConverter extends JsonConverter<Locale, String> {
  const LocaleConverter();
  @override
  fromJson(stringJson) {
    return Locale.fromSubtags(
      languageCode: (json.decode(stringJson) as Map<String, dynamic>)["locale"],
    );
  }

  @override
  toJson(Locale locale) {
    return json.encode({"locale": locale.toLanguageTag()});
  }
}
