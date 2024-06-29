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
    required this.scrollVisibilityManager,
    required this.tableManager,
    required this.productCalculator,
    required this.scrollController,
  }) {
    scrollVisibilityManager.listenScrollController(scrollController);
  }

  final ScrollVisibilityManager scrollVisibilityManager;
  final TableManager tableManager;
  final ProductCalculator productCalculator;
  final ScrollController scrollController;

  List<TableModel> tables = [];
  List<DishModel> dishes = [];
  int _totalSumOfDishes = 0;

  int get totalSumOfProducts => _totalSumOfDishes;
  ValueNotifier<bool> get isVisible => scrollVisibilityManager.isVisible;
  FloatingActionButtonLocation get buttonLocation =>
      scrollVisibilityManager.buttonLocation;

  Future<List<TableModel>> readDataFromExcel() async {
    tables = await tableManager.readDataFromExcel();
    return tables;
  }

  void calculateSumOfDishes() {
    _totalSumOfDishes = productCalculator.calculateTotalSum(dishes);
    notifyListeners();
  }

  void updateTable() {
    tableManager.updateTables(tables, dishes);
  }

  void navigateToPreviewScreen(BuildContext context) {
    updateTable();
    final updatedTables = tableManager.removeEmptyData(tables);
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
        tables: updatedTables,
      ),
    );
  }
}

abstract class ScrollVisibilityManager {
  ValueNotifier<bool> get isVisible;
  FloatingActionButtonLocation get buttonLocation;
  void listenScrollController(ScrollController scrollController);
}

class ScrollVisibilityManagerImpl implements ScrollVisibilityManager {
  @override
  final ValueNotifier<bool> isVisible = ValueNotifier(true);

  @override
  FloatingActionButtonLocation get buttonLocation => isVisible.value
      ? FloatingActionButtonLocation.miniEndDocked
      : FloatingActionButtonLocation.endFloat;

  @override
  void listenScrollController(ScrollController scrollController) {
    scrollController.addListener(() {
      switch (scrollController.position.userScrollDirection) {
        case ScrollDirection.forward:
          _showNavBar();
          break;
        case ScrollDirection.reverse:
          _hideNavBar();
          break;
        case ScrollDirection.idle:
        default:
          break;
      }
    });
  }

  void _showNavBar() {
    if (!isVisible.value) isVisible.value = true;
  }

  void _hideNavBar() {
    if (isVisible.value) isVisible.value = false;
  }
}

abstract class TableManager {
  Future<List<TableModel>> readDataFromExcel();
  void updateTables(List<TableModel> tables, List<DishModel> dishes);
  List<TableModel> removeEmptyData(List<TableModel> tables);
}

class TableManagerImpl implements TableManager {
  final ExcelRepository excelRepository;

  TableManagerImpl(this.excelRepository);

  @override
  Future<List<TableModel>> readDataFromExcel() async {
    return await excelRepository.readDataExcel();
  }

  @override
  void updateTables(List<TableModel> tables, List<DishModel> dishes) {
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

  @override
  List<TableModel> removeEmptyData(List<TableModel> tables) {
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
}

class ProductCalculator {
  int calculateTotalSum(List<DishModel> dishes) {
    return dishes.fold(0, (sum, dish) {
      return sum + (int.tryParse(dish.price ?? '0') ?? 0) * (dish.count ?? 0);
    });
  }
}
