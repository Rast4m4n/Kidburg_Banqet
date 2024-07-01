// ignore_for_file: public_member_api_docs, sort_constructors_first
class DishModel {
  DishModel({
    required this.rowIndex,
    required this.nameDish,
    required this.weight,
    required this.price,
    this.count,
  });
  final int rowIndex;
  final String? nameDish;
  final String? weight;
  final int? count;
  final String? price;

  DishModel copyWith({
    int? rowIndex,
    String? nameDish,
    String? weight,
    int? count,
    String? price,
  }) {
    return DishModel(
      rowIndex: rowIndex ?? this.rowIndex,
      nameDish: nameDish ?? this.nameDish,
      weight: weight ?? this.weight,
      count: count ?? this.count,
      price: price ?? this.price,
    );
  }

  @override
  String toString() {
    return 'DishModel(rowIndex: $rowIndex, nameDish: $nameDish, weight: $weight, count: $count, price: $price)';
  }

  List<dynamic> modelToList() {
    return [
      nameDish,
      weight,
      count,
      price,
    ];
  }
}
