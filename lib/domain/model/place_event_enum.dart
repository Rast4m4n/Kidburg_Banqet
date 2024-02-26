enum PlaceEventEnum {
  university(name: 'Университет'),
  carlson(name: 'Карлсон'),
  cabinCompany(name: 'Каюта-компания'),
  magic(name: 'Магия'),
  western(name: 'Вестерн'),
  princess(name: 'Принцесса');

  final String name;

  const PlaceEventEnum({required this.name});
}
