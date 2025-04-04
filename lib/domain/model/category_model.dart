import 'package:kidburg_banquet/domain/model/dish_model.dart';

class CategoryModel {
  CategoryModel({
    required this.name,
    required this.dishes,
  });

  final String name;
  final List<DishModel> dishes;

  CategoryModel copywith({
    String? name,
    List<DishModel>? dishes,
  }) {
    return CategoryModel(
      name: name ?? this.name,
      dishes: dishes ?? this.dishes,
    );
  }
}
