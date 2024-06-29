import 'package:flutter/material.dart';
import 'package:kidburg_banquet/domain/model/dish_model.dart';
import 'package:kidburg_banquet/presentation/screens/preorder_form/vm/pre_order_vm.dart';

class DishViewModel with ChangeNotifier {
  DishViewModel({
    required this.dish,
    required this.preOrderViewModel,
  });

  DishModel dish;
  late final PreOrderViewModel preOrderViewModel;

  int get totalPrice => (dish.count ?? 0) * int.parse(dish.price!);

  void _calculateDish() {
    bool dishExists = preOrderViewModel.dishes
        .any((existingDish) => existingDish.idRow == dish.idRow);

    if (dishExists) {
      _updateExistingDish();
    } else {
      preOrderViewModel.dishes.add(dish);
    }
  }

  void _updateExistingDish() {
    preOrderViewModel.dishes
        .removeWhere((existingDish) => existingDish.idRow == dish.idRow);

    if (dish.count != null && dish.count! > 0) {
      preOrderViewModel.dishes.add(dish);
    }
  }

  void updateCount(String count) {
    dish = dish.copyWith(count: int.parse(count));
    _calculateDish();
    preOrderViewModel.calculateSumOfDishes();
    notifyListeners();
  }
}
