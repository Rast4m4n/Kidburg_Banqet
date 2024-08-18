part of '../../data/repository/google_sheet_data_repository.dart';

List<CategoryModel> _mapDataToCategories(List<dynamic> data) {
  Map<String, List<DishModel>> categorizedDishes = {};

  for (var item in data) {
    String category = item['Категория'];
    DishModel dish = DishModel(
      id: const Uuid().v4(),
      nameDish: item['Название'],
      weight: item['Вес'],
      count: 0,
      price: item['Цена'],
    );

    categorizedDishes.putIfAbsent(category, () => []).add(dish);
  }

  List<CategoryModel> categories = categorizedDishes.entries.map((entry) {
    return CategoryModel(name: entry.key, dishes: entry.value);
  }).toList();
  return categories;
}
