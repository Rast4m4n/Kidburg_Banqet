import 'package:flutter/material.dart';
import 'package:kidburg_banquet/data/repository/excel_repository.dart';
import 'package:kidburg_banquet/domain/model/banqet_model.dart';
import 'package:kidburg_banquet/domain/model/dish_model.dart';
import 'package:kidburg_banquet/domain/model/table_model.dart';
import 'package:path_provider/path_provider.dart';

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

  Future<void> saveBanquetExcelFile() async {
    final repo = ExcelRepository();
    await repo.writeDataToExcel(banqetModel);
  }

  // void showShackBarInfoDirectory(BuildContext context) async {
  //   final directory = await getDownloadsDirectory();
  //   String filePath = '${directory!.path}/example.xlsx';
  //   final snackBar = SnackBar(
  //     content: Text('Данные сохранены по директории: $filePath'),
  //   );
  //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
  // }
}
