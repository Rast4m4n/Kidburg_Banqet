import 'package:kidburg_banquet/domain/model/category_model.dart';

class TableModel {
  TableModel({
    required this.name,
    required this.categories,
  });
  final String name;
  final List<CategoryModel> categories;
}
