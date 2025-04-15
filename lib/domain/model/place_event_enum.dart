import 'package:intl/intl.dart';

/// Комнаты заведения в Кидбург ЦДМ
enum PlaceEventCDMEnum {
  university,
  carlson,
  cabinCompany,
  magic,
  western,
  princess,
  cafe;

  String get localizedName {
    return Intl.message(
      _getDefaultName(),
      name: name,
    );
  }

  String _getDefaultName() {
    switch (this) {
      case PlaceEventCDMEnum.university:
        return 'University';
      case PlaceEventCDMEnum.carlson:
        return 'Carlson';
      case PlaceEventCDMEnum.cabinCompany:
        return 'Cabin Company';
      case PlaceEventCDMEnum.magic:
        return 'Magic';
      case PlaceEventCDMEnum.western:
        return 'Western';
      case PlaceEventCDMEnum.princess:
        return 'Princess';
      case PlaceEventCDMEnum.cafe:
        return 'Cafe';
    }
  }
}

/// Комнаты заведения в Кидбург Ривьера
enum PlaceEventRivieraEnum {
  castlePrincess,
  disco,
  cosmos,
  jurassicPeriod,
  miracelIsland,
  cafe;

  String get localizedName {
    return Intl.message(
      _getDefaultName(),
      name: name,
    );
  }

  String _getDefaultName() {
    switch (this) {
      case PlaceEventRivieraEnum.castlePrincess:
        return 'Castle princess';
      case PlaceEventRivieraEnum.disco:
        return 'Disco';
      case PlaceEventRivieraEnum.cosmos:
        return 'Cosmos';
      case PlaceEventRivieraEnum.jurassicPeriod:
        return 'Jurassic Period';
      case PlaceEventRivieraEnum.miracelIsland:
        return 'Miracle Island';
      case PlaceEventRivieraEnum.cafe:
        return 'Cafe';
    }
  }
}
