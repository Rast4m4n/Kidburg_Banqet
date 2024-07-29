import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:kidburg_banquet/data/repository/google_sheet_data_repository.dart';
import 'package:kidburg_banquet/domain/model/category_model.dart';
import 'package:kidburg_banquet/domain/model/dish_model.dart';

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
  List<CategoryModel> _categories = [];
  List<CategoryModel> get categories => _categories;

  Future<List<CategoryModel>> fetchDataFromGoogleSheet() async {
    _categories = await googleSheetRepository.fetchCategoriesAndDishes();
    return googleSheetRepository.fetchCategoriesAndDishes();
  }

  void updateDishCount(DishModel currentDish, int newCount) {
    if (newCount < 0) return;
    for (var category in _categories) {
      for (var dish in category.dishes) {
        if (currentDish.nameDish == dish.nameDish) {
          final indexCategory = _categories.indexOf(category);
          final indexDish = category.dishes.indexOf(dish);
          _categories[indexCategory].dishes[indexDish] =
              dish.copyWith(count: newCount);
          print(_categories[indexCategory].dishes[indexDish].toString());
        }
      }
    }
    notifyListeners();
  }

  int getTotalPrice() {
    int totalPrice = 0;
    for (var category in _categories) {
      for (var dish in category.dishes) {
        totalPrice += (dish.price ?? 0) * dish.count;
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
