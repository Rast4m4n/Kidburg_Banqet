import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:kidburg_banquet/data/repository/google_sheet_data_repository.dart';
import 'package:kidburg_banquet/domain/model/category_model.dart';
import 'package:kidburg_banquet/domain/model/dish_model.dart';
import 'package:kidburg_banquet/domain/model/table_model.dart';
import 'package:uuid/uuid.dart';

class PreOrderFormVm with ChangeNotifier {
  PreOrderFormVm({
    required this.googleSheetRepository,
    required this.scrollVisibilityManager,
    required this.scrollController,
  }) {
    scrollVisibilityManager.listenScrollController(scrollController);
  }

  final ScrollVisibilityManager scrollVisibilityManager;
  final ScrollController scrollController;

  ValueNotifier<bool> get isVisible => scrollVisibilityManager.isVisible;
  FloatingActionButtonLocation get buttonLocation =>
      scrollVisibilityManager.buttonLocation;

  final GoogleSheetDataRepository googleSheetRepository;

  final List<TableModel> _tables = [];
  List<TableModel> get tables => _tables;

  List<CategoryModel> _originalCategories = [];

  Future<List<TableModel>> fetchDataFromGoogleSheet() async {
    _originalCategories =
        await googleSheetRepository.fetchCategoriesAndDishes();
    if (_tables.isEmpty) {
      _tables.add(
        TableModel(
          name: 'Подача на',
          categories: _cloneCategories(_originalCategories),
        ),
      );
    }
    return _tables;
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
  void addNewServing() {
    List<CategoryModel> newCategories = _cloneCategories(_originalCategories);
    final newServing = TableModel(name: 'Подача на', categories: newCategories);
    _tables.add(newServing);
    notifyListeners();
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

  void navigateToPreviewScreen(context) {}
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
