import 'package:flutter/material.dart';
import 'package:kidburg_banquet/data/file_manager/file_manager.dart';
import 'package:kidburg_banquet/data/repository/excel_repository.dart';
import 'package:kidburg_banquet/domain/model/banqet_model.dart';
import 'package:kidburg_banquet/domain/model/dish_model.dart';
import 'package:kidburg_banquet/domain/model/table_model.dart';

class PreviewBanquerViewModel with ChangeNotifier {
  PreviewBanquerViewModel({
    required this.banqetModel,
  });
  final BanqetModel banqetModel;
  bool isExpandedCard = false;

  List<DishModel> spreadList(TableModel table) {
    List<DishModel> dishes = [];
    for (var category in table.categories) {
      dishes.addAll(category.dishes);
    }
    return dishes;
  }

  Future<void> saveBanquetExcelFile(BuildContext context) async {
    final repo = ExcelRepository();
    await repo.writeDataToExcel(banqetModel);
    if (context.mounted) _showSnackBar(context);
  }

  void _showSnackBar(BuildContext context) {
    final pathSavedFile = FileManager.filePath(
      FileManager.getFileName(banqetModel),
    );
    final snackBar = SnackBar(
      content: Text('Файл сохранён по директории: $pathSavedFile'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
