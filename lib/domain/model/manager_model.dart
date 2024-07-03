// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:kidburg_banquet/domain/model/establishments_enum.dart';

class ManagerModel {
  ManagerModel({
    required this.name,
    required this.phoneNumber,
    required this.establishmentEnum,
  });

  final String name;
  final String phoneNumber;

  /// Заведение с конкретными местами проведения мероприятие
  /// Файл establishments_enum, где есть перечисления заведений
  /// Файл place_event_enum, где перечисляются места проведения мероприятия
  final EstablishmentsEnum establishmentEnum;

  ManagerModel copyWith({
    String? name,
    String? phoneNumber,
    final EstablishmentsEnum? establishmentEnum,
  }) {
    return ManagerModel(
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      establishmentEnum: establishmentEnum ?? this.establishmentEnum,
    );
  }
}
