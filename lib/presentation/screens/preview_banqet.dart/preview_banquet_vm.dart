import 'package:flutter/material.dart';
import 'package:kidburg_banquet/data/file_manager/file_manager.dart';
import 'package:kidburg_banquet/data/repository/excel_repository.dart';
import 'package:kidburg_banquet/data/repository/shared_preferences_repository.dart';
import 'package:kidburg_banquet/domain/model/banqet_model.dart';
import 'package:kidburg_banquet/domain/model/dish_model.dart';
import 'package:kidburg_banquet/domain/model/statistic_model.dart';
import 'package:kidburg_banquet/domain/model/table_model.dart';

class PreviewBanquerViewModel with ChangeNotifier {
  PreviewBanquerViewModel({
    required this.banqetModel,
  });
  final BanquetModel banqetModel;
  bool isSavedBanquet = false;

  List<DishModel> spreadList(TableModel table) {
    List<DishModel> dishes = [];
    for (var category in table.categories) {
      dishes.addAll(category.dishes);
    }
    return dishes;
  }

  Future<void> saveBanquetExcelFile(BuildContext context) async {
    final repo = ExcelRepository();
    await repo.writeNewExcelFile(banqetModel);
    await saveStatisticBanquet();
    if (context.mounted) _showSnackBar(context);
    isSavedBanquet = true;
    notifyListeners();
  }

  Future<void> saveStatisticBanquet() async {
    final guests = banqetModel.amountOfAdult! + banqetModel.amountOfChildren!;
    final keyDateStorage =
        "${banqetModel.dateStart.year}_year_${banqetModel.dateStart.month}_month";
    SharedPreferencesRepository.instance.saveStatisticBanquets(
      StatisticModel(
        sum: banqetModel.sumOfBanquet!,
        guests: guests,
        numberOfOrder: 1,
      ),
      keyDateStorage,
    );
  }

  void _showSnackBar(BuildContext context) {
    final pathSavedFile = FileManager.filePath(
      FileManager.getFileName(banqetModel),
      banqetModel,
    );
    final snackBar = SnackBar(
      content: Text('Файл сохранён по директории: $pathSavedFile'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
