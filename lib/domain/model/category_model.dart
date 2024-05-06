import 'package:kidburg_banquet/domain/model/product_model.dart';

class CategoryModel {
  CategoryModel({
    required this.name,
    required this.products,
  });

  final String name;
  final List<ProductModel> products;

  CategoryModel copywith({
    String? name,
    List<ProductModel>? products,
  }) {
    return CategoryModel(
      name: name ?? this.name,
      products: products ?? this.products,
    );
  }
}
