// ignore_for_file: public_member_api_docs, sort_constructors_first
class DishModel {
  DishModel({
    required this.idRow,
    required this.nameDish,
    required this.weight,
    required this.price,
    this.count,
  });
  final int idRow;
  final String? nameDish;
  final String? weight;
  final int? count;
  final String? price;

  DishModel copyWith({
    int? idRow,
    String? nameDish,
    String? weight,
    int? count,
    String? price,
  }) {
    return DishModel(
      idRow: idRow ?? this.idRow,
      nameDish: nameDish ?? this.nameDish,
      weight: weight ?? this.weight,
      count: count ?? this.count,
      price: price ?? this.price,
    );
  }
}
