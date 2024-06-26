class BanqetModel {
  const BanqetModel({
    required this.nameClient,
    required this.place,
    required this.dateStart,
    required this.timeStart,
    required this.amountOfChildren,
    required this.amountOfAdult,
  });

  final String nameClient;
  final String place;
  final String dateStart;
  final String timeStart;
  final int amountOfChildren;
  final int amountOfAdult;
}
