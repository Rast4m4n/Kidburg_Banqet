import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kidburg_banquet/data/repository/google_sheet_data_repository.dart';
import 'package:kidburg_banquet/domain/model/banqet_model.dart';
import 'package:kidburg_banquet/domain/model/category_model.dart';
import 'package:kidburg_banquet/domain/model/dish_model.dart';
import 'package:kidburg_banquet/domain/model/table_model.dart';
import 'package:kidburg_banquet/presentation/navigation/app_route.dart';
import 'package:uuid/uuid.dart';

class PreOrderFormVm with ChangeNotifier {
  PreOrderFormVm({
    required this.googleSheetRepository,
  });

  final GoogleSheetDataRepository googleSheetRepository;

  late BanqetModel? banquetModel;

  final List<TableModel> _tables = [];
  List<TableModel> get tables => _tables;

  List<CategoryModel> _originalCategories = [];

  Future<List<TableModel>> fetchDataFromGoogleSheet() async {
    if (_tables.isEmpty) {
      _originalCategories =
          await googleSheetRepository.fetchCategoriesAndDishes();
      String formatterTime = _timeFormat(banquetModel!.timeStart);
      _tables.add(
        TableModel(
          name: 'Подача на $formatterTime',
          categories: _cloneCategories(_originalCategories),
          timeServing: banquetModel!.timeStart,
        ),
      );
    }
    return _tables;
  }

  String _timeFormat(TimeOfDay timeofDay) {
    return DateFormat('HH:mm').format(
      DateTime.now().copyWith(
        hour: timeofDay.hour,
        minute: timeofDay.minute,
      ),
    );
  }

  // Клонирование списка категорий и блюд
  // и создание новых уникальных идентификаторов
  // для блюд
  List<CategoryModel> _cloneCategories(List<CategoryModel> categories) {
    return categories.map((category) {
      List<DishModel> clonedDishes = category.dishes.map((dish) {
        return dish.copyWith(id: const Uuid().v4());
      }).toList();
      return category.copywith(dishes: clonedDishes);
    }).toList();
  }

  // Добавление новой подачи блюд для стола
  Future<void> addNewServing(BuildContext context) async {
    List<CategoryModel> newCategories = _cloneCategories(_originalCategories);
    final timePicked = await showTimePicker(
      context: context,
      initialTime: banquetModel!.timeStart,
    );
    if (timePicked == null) return;
    final newServing = TableModel(
      name: 'Подача на ${_timeFormat(timePicked)}',
      categories: newCategories,
      timeServing: timePicked,
    );
    _tables.add(newServing);
  }

  // Обновление количества блюд конкретного блюда
  void updateDishCount(DishModel currentDish, int newCount) {
    if (newCount < 0) return;
    for (var table in _tables) {
      for (var category in table.categories) {
        for (var dish in category.dishes) {
          if (currentDish.id == dish.id) {
            final indexTable = _tables.indexOf(table);
            final indexCategory = table.categories.indexOf(category);
            final indexDish = category.dishes.indexOf(dish);
            _tables[indexTable].categories[indexCategory].dishes[indexDish] =
                dish.copyWith(count: newCount);
          }
        }
      }
    }
    notifyListeners();
  }

  int getTotalPrice() {
    int totalPrice = 0;
    for (var table in _tables) {
      for (var category in table.categories) {
        for (var dish in category.dishes) {
          totalPrice += (dish.price ?? 0) * dish.count;
        }
      }
    }
    return totalPrice;
  }

  Future<void> changeTime(BuildContext context, TableModel currentTable) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: banquetModel!.timeStart,
    );
    for (var table in _tables) {
      if (table.timeServing == currentTable.timeServing) {
        final indexTable = _tables.indexOf(table);
        _tables[indexTable] = table.copyWith(
          name: 'Подача на ${_timeFormat(picked!)}',
          timeServing: picked,
        );
      }
    }
    notifyListeners();
  }

  List<TableModel> deleteEmptyData(List<TableModel> tables) {
    bool hasCount(DishModel dish) {
      return dish.count > 0;
    }

    // Копирую элементы существующих столов
    // чтобы сохранять изменения в списке
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

  void navigateToPreviewScreen(context) {
    final tables = deleteEmptyData(_tables);
    Navigator.of(context).pushNamed(
      AppRoute.previewBanquetPage,
      arguments: banquetModel!.copyWith(tables: tables),
    );
  }
}
