import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:kidburg_banquet/data/repository/excel_repository.dart';
import 'package:kidburg_banquet/domain/model/banqet_model.dart';
import 'package:kidburg_banquet/domain/model/category_model.dart';
import 'package:kidburg_banquet/domain/model/dish_model.dart';
import 'package:kidburg_banquet/domain/model/table_model.dart';
import 'package:kidburg_banquet/presentation/navigation/app_route.dart';

class PreOrderViewModel with ChangeNotifier {
  PreOrderViewModel({
    required this.excelRepository,
    required this.scrollController,
  });

  List<TableModel> tables = [];
  final ExcelRepository excelRepository;

  final List<DishModel> dishes = [];
  int _totalSumOfDishes = 0;
  int get totalSumOfProducts => _totalSumOfDishes;

  final ScrollController scrollController;
  ValueNotifier<bool> isVisible = ValueNotifier(true);
  FloatingActionButtonLocation get buttonLocation => isVisible.value
      ? FloatingActionButtonLocation.miniEndDocked
      : FloatingActionButtonLocation.endFloat;

  void listenScrollController() {
    switch (scrollController.position.userScrollDirection) {
      case ScrollDirection.idle:
        break;
      case ScrollDirection.forward:
        _showNavBar();
      case ScrollDirection.reverse:
        _hideNavBar();
    }
  }

  void _showNavBar() {
    if (!isVisible.value) isVisible.value = true;
  }

  void _hideNavBar() {
    if (isVisible.value) isVisible.value = false;
  }

  Future<List<TableModel>> readDataFromExcel() async {
    tables = await excelRepository.readDataExcel();
    return tables;
  }

  void calculateSumOfProducts() {
    _totalSumOfDishes = dishes.fold(
      0,
      (previousDish, currentDish) =>
          previousDish + (int.parse(currentDish.price!) * currentDish.count!),
    );
    notifyListeners();
  }

  void updateTable() {
    for (var table in tables) {
      for (var category in table.categories) {
        for (var dish in category.dishes) {
          if (dishes.any((newDish) => newDish.idRow == dish.idRow)) {
            final updateDish = dishes.singleWhere(
              (element) => element.idRow == dish.idRow,
            );
            final indexTable = tables.indexOf(table);
            final indexCategory = table.categories.indexOf(category);
            final indexDish = category.dishes.indexOf(dish);
            tables[indexTable].categories[indexCategory].dishes[indexDish] =
                updateDish;
          }
        }
      }
    }
  }

  List<TableModel> deleteEmptyData(List<TableModel> tables) {
    bool hasCount(DishModel dish) {
      return dish.count != null && dish.count! > 0;
    }

    List<TableModel> copiedTables = List.from(
      tables.map(
        (table) => TableModel(
          name: table.name,
          categories: List.from(
            table.categories.map(
              (category) => CategoryModel(
                name: category.name,
                dishes: List.from(category.dishes),
              ),
            ),
          ),
        ),
      ),
    );

    copiedTables.removeWhere((table) {
      table.categories.removeWhere((category) {
        category.dishes.removeWhere((dish) => !hasCount(dish));
        return category.dishes.isEmpty;
      });
      return table.categories.isEmpty;
    });
    return copiedTables;
  }

  void routeToPreviewScreen(BuildContext context) {
    updateTable();
    final updateTables = deleteEmptyData(tables);
    final args = ModalRoute.of(context)!.settings.arguments as BanqetModel;
    Navigator.pushNamed(
      context,
      AppRoute.previewBanquetPage,
      arguments: BanqetModel(
        nameClient: args.nameClient,
        place: args.place,
        dateStart: args.dateStart,
        firstTimeServing: args.firstTimeServing,
        amountOfChildren: args.amountOfChildren,
        amountOfAdult: args.amountOfAdult,
        tables: updateTables,
      ),
    );
  }
}
