import 'package:kidburg_banquet/domain/model/product_model.dart';

class BanqetModel {
  const BanqetModel({
    required this.nameClient,
    required this.place,
    required this.date,
    required this.time,
    required this.amountOfChildren,
    required this.amountOfAdult,
    required this.products,
  });

  final String nameClient;
  final String place;
  final String date;
  final String time;
  final int amountOfChildren;
  final int amountOfAdult;
  final List<ProductModel> products;
}
