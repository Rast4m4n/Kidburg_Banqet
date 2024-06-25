// ignore_for_file: public_member_api_docs, sort_constructors_first
class DishModel {
  DishModel({
    required this.idRow,
    required this.nameProduct,
    required this.weight,
    required this.price,
    this.count,
  });
  final int idRow;
  final String? nameProduct;
  final String? weight;
  final int? count;
  final String? price;

  DishModel copyWith({
    int? idRow,
    String? nameProduct,
    String? weight,
    int? count,
    String? price,
  }) {
    return DishModel(
      idRow: idRow ?? this.idRow,
      nameProduct: nameProduct ?? this.nameProduct,
      weight: weight ?? this.weight,
      count: count ?? this.count,
      price: price ?? this.price,
    );
  }
}
