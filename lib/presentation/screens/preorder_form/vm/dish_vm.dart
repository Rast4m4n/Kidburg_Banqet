import 'package:flutter/material.dart';
import 'package:kidburg_banquet/domain/model/product_model.dart';
import 'package:kidburg_banquet/presentation/screens/preorder_form/vm/pre_order_vm.dart';

class DishViewModel with ChangeNotifier {
  DishViewModel({
    required this.product,
    required this.preOrderViewModel,
  });

  ProductModel product;
  late final PreOrderViewModel preOrderViewModel;

  int get totalPrice => _tempProductCount * int.parse(product.price!);
  int get _tempProductCount => product.count ?? 0;

  void _calculateDish() {
    bool productExists = preOrderViewModel.products
        .any((existingProduct) => existingProduct.idRow == product.idRow);

    if (productExists) {
      _updateExistingDish();
    } else {
      preOrderViewModel.products.add(product);
    }
  }

  void _updateExistingDish() {
    preOrderViewModel.products.removeWhere(
        (existingProduct) => existingProduct.idRow == product.idRow);

    if (product.count != null && product.count! > 0) {
      preOrderViewModel.products.add(product);
    }
  }

  void updateCount(String count) {
    product = product.copyWith(count: int.parse(count));
    _calculateDish();
    preOrderViewModel.calculateSumOfProducts();
    notifyListeners();
  }
}
