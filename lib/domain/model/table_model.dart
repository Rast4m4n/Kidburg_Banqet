import 'package:kidburg_banquet/domain/model/category_model.dart';

class TableModel {
  TableModel({
    required this.name,
    required this.categories,
  });
  final String name;
  final List<CategoryModel> categories;

  TableModel copyWith({
    String? name,
    List<CategoryModel>? categories,
  }) {
    return TableModel(
      name: name ?? this.name,
      categories: categories ?? this.categories,
    );
  }
}
