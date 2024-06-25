import 'package:kidburg_banquet/domain/model/product_model.dart';

class CategoryModel {
  CategoryModel({
    required this.name,
    required this.products,
  });

  final String name;
  final List<DishModel> products;

  CategoryModel copywith({
    String? name,
    List<DishModel>? products,
  }) {
    return CategoryModel(
      name: name ?? this.name,
      products: products ?? this.products,
    );
  }
}
