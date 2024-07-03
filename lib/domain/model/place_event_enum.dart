/// Комнаты заведения в Кидбург ЦДМ
enum PlaceEventCDMEnum {
  university('Университет'),
  carlson('Карлсон'),
  cabinCompany('Каюта-компания'),
  magic('Магия'),
  western('Вестерн'),
  princess('Принцесса'),
  cafe('Кафе');

  final String name;

  const PlaceEventCDMEnum(this.name);
}

/// Комнаты заведения в Кидбург Ривьера
enum PlaceEventRivieraEnum {
  castlePrincess('Дворец принцессы'),
  disco('Диско'),
  cosmos('Космос'),
  jurassicPeriod('Юрский период'),
  miracelIsland('Чудо-остров'),
  cafe('Кафе');

  final String name;

  const PlaceEventRivieraEnum(this.name);
}
