import 'package:flutter/material.dart';
import 'package:kidburg_banquet/core/di/i_di_scope.dart';
import 'package:kidburg_banquet/data/file_manager/file_manager.dart';
import 'package:kidburg_banquet/data/repository/excel_repository.dart';
import 'package:kidburg_banquet/domain/model/banqet_model.dart';
import 'package:kidburg_banquet/domain/model/dish_model.dart';
import 'package:kidburg_banquet/domain/model/statistic_model.dart';
import 'package:kidburg_banquet/domain/model/table_model.dart';
import 'package:kidburg_banquet/generated/l10n.dart';
import 'package:provider/provider.dart';

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
    await repo.writeNewExcelFile(banqetModel, context);
    if (context.mounted) await saveStatisticBanquet(context);
    if (context.mounted) _showSnackBar(context);
    isSavedBanquet = true;
    notifyListeners();
  }

  Future<void> saveStatisticBanquet(BuildContext context) async {
    final guests = banqetModel.amountOfAdult! + banqetModel.amountOfChildren!;
    final keyDateStorage =
        "${banqetModel.dateStart.year}_year_${banqetModel.dateStart.month}_month";
    context.read<IDiScope>().storage.saveStatisticBanquets(
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
      content: Text(
        '${S.of(context).theFileIsSavedInTheDirectory}: $pathSavedFile',
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
