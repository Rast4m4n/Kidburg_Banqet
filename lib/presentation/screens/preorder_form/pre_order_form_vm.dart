import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kidburg_banquet/data/repository/google_sheet_data_repository.dart';
import 'package:kidburg_banquet/domain/model/banqet_model.dart';
import 'package:kidburg_banquet/domain/model/category_model.dart';
import 'package:kidburg_banquet/domain/model/dish_model.dart';
import 'package:kidburg_banquet/domain/model/table_model.dart';
import 'package:kidburg_banquet/generated/l10n.dart';
import 'package:kidburg_banquet/presentation/navigation/app_route.dart';
import 'package:uuid/uuid.dart';

class PreOrderFormVm with ChangeNotifier {
  PreOrderFormVm({
    required GoogleSheetDataRepository googleSheetRepository,
  }) : _googleSheetRepository = googleSheetRepository;

  final GoogleSheetDataRepository _googleSheetRepository;

  (BanquetModel? banquetModel, bool initialized) _banquetModel = (null, false);
  (BanquetModel? banquetModel, bool initialized) get banquetModel =>
      _banquetModel;

  final List<TableModel> _tables = [];
  List<TableModel> get tables => _tables;

  List<CategoryModel> _originalCategories = [];

  set setBanquetModel(BanquetModel? banquetModel) {
    _banquetModel = (banquetModel, true);
    notifyListeners();
  }

  Future<List<TableModel>> getTableData(BuildContext context) async {
    print('getTableData');
    if (_tables.isEmpty) {
      return await _fetchDataFromGoogleSheet(context);
    } else {
      return _tables;
    }
  }

  Future<List<TableModel>> _fetchDataFromGoogleSheet(
      BuildContext context) async {
    final servingDishesOn = S.of(context).servingDishesOn;

    _originalCategories =
        await _googleSheetRepository.fetchCategoriesAndDishes(context);

    String formatterTime =
        _timeFormat(_banquetModel.$1?.timeStart ?? TimeOfDay.now());

    _tables.add(
      TableModel(
        id: const Uuid().v4(),
        name: '$servingDishesOn $formatterTime',
        categories: _cloneCategories(_originalCategories),
        timeServing: _banquetModel.$1?.timeStart ?? TimeOfDay.now(),
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

  /// Клонирование списка категорий и блюд
  /// и создание новых уникальных идентификаторов
  /// для блюд
  List<CategoryModel> _cloneCategories(List<CategoryModel> categories) {
    return categories.map((category) {
      final clonedDishes = category.dishes
          .map((dish) => dish.copyWith(id: const Uuid().v4()))
          .toList();
      return category.copyWith(dishes: clonedDishes);
    }).toList();
  }

  /// Добавление новой подачи блюд для стола
  Future<void> addNewServing(BuildContext context) async {
    final servingDishesOn = S.of(context).servingDishesOn;
    List<CategoryModel> newCategories = _cloneCategories(_originalCategories);
    final timePicked = await showTimePicker(
      context: context,
      initialTime: _banquetModel.$1?.timeStart ?? TimeOfDay.now(),
    );
    if (timePicked == null) return;

    final newServing = TableModel(
      id: const Uuid().v4(),
      name: '$servingDishesOn ${_timeFormat(timePicked)}',
      categories: newCategories,
      timeServing: timePicked,
    );
    _tables.add(newServing);
    notifyListeners();
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

  int getTotalSum() {
    int totalPrice = 0;
    for (var table in _tables) {
      for (var category in table.categories) {
        for (var dish in category.dishes) {
          totalPrice += dish.totalPrice;
        }
      }
    }
    return totalPrice;
  }

  Future<void> changeTime(BuildContext context, TableModel currentTable) async {
    final servingDishesOn = S.of(context).servingDishesOn;
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _banquetModel.$1?.timeStart ?? TimeOfDay.now(),
    );
    if (picked == null) return;
    for (var table in _tables) {
      if (table.id == currentTable.id) {
        final indexTable = _tables.indexOf(table);
        _tables[indexTable] = table.copyWith(
          name: '$servingDishesOn ${_timeFormat(picked)}',
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

  /// Очистка пустых данных из списка столов
  /// и создание нового списка столов
  List<TableModel> clearEmptyData(List<TableModel> tables) {
    // Копирую элементы существующих столов
    // чтобы сохранять изменения в списке
    List<TableModel> copiedTables = tables
        .map(
          (table) => table.copyWith(
            categories: table.categories
                .map(
                  (category) => category.copyWith(
                    dishes: [...category.dishes],
                  ),
                )
                .toList(),
          ),
        )
        .toList();

    copiedTables.removeWhere((table) {
      table.categories.removeWhere(
        (category) {
          category.dishes.removeWhere((dish) => !dish.hasCount);
          return category.dishes.isEmpty;
        },
      );
      return table.categories.isEmpty;
    });
    return copiedTables;
  }

  void navigateToPreviewScreen(context) {
    final tables = clearEmptyData(_tables);
    Navigator.of(context).pushNamed(
      AppRoute.previewBanquetPage,
      arguments: _banquetModel.$1
          ?.copyWith(tables: tables, sumOfBanquet: getTotalSum()),
    );
  }
}
