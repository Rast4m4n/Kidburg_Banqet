import 'dart:async';

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

  late BanquetModel? banquetModel;

  final List<TableModel> _tables = [];
  List<TableModel> get tables => _tables;

  List<CategoryModel> _originalCategories = [];

  Future<List<TableModel>> getTableData() async {
    if (_tables.isEmpty) {
      return await _fetchDataFromGoogleSheet();
    } else {
      return _tables;
    }
  }

  Future<List<TableModel>> _fetchDataFromGoogleSheet() async {
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

  // Обновление количества конкретного блюда
  void updateDishCount({
    required int tableIndex,
    required int categoryIndex,
    required DishModel currentDish,
    required int newCount,
  }) {
    if (newCount < 0) return;
    final indexDish = _tables[tableIndex]
        .categories[categoryIndex]
        .dishes
        .indexOf(currentDish);
    _tables[tableIndex].categories[categoryIndex].dishes[indexDish] =
        currentDish.copyWith(count: newCount);
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
    if (picked == null) return;
    for (var table in _tables) {
      if (table == currentTable) {
        final indexTable = _tables.indexOf(table);
        _tables[indexTable] = table.copyWith(
          name: 'Подача на ${_timeFormat(picked)}',
          timeServing: picked,
        );
      }
    }
    notifyListeners();
  }

  void swipeToDeleteData(int tableIndex) {
    _tables.removeAt(tableIndex);
    notifyListeners();
  }

  List<TableModel> clearEmptyData(List<TableModel> tables) {
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
    final tables = clearEmptyData(_tables);
    Navigator.of(context).pushNamed(
      AppRoute.previewBanquetPage,
      arguments: banquetModel!.copyWith(tables: tables),
    );
  }
}
