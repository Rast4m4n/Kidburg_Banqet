import 'dart:convert';

import 'package:kidburg_banquet/domain/model/category_model.dart';
import 'package:kidburg_banquet/domain/model/dish_model.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class GoogleSheetDataRepository {
  Future<List<CategoryModel>> fetchCategoriesAndDishes() async {
    final response = await http.get(
      Uri.parse(
        'https://script.google.com/macros/s/AKfycbwRfXear5quPtotp9Ty81As8tzN2hHmQfq5lpCOLfrFRHp1DLpia2sDw35UmsO1It7M6w/exec',
      ),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
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

        if (categorizedDishes.containsKey(category)) {
          categorizedDishes[category]!.add(dish);
        } else {
          categorizedDishes[category] = [dish];
        }
      }

      List<CategoryModel> categories = categorizedDishes.entries.map((entry) {
        return CategoryModel(name: entry.key, dishes: entry.value);
      }).toList();

      return categories;
    } else {
      throw Exception('Failed to load dishes');
    }
  }
}
