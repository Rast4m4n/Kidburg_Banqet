import 'package:flutter/material.dart';
import 'package:kidburg_banquet/domain/model/product_model.dart';

class DishViewModel with ChangeNotifier {
  DishViewModel({required this.product});

  ProductModel product;

  void updateCount(String count) {
    product = product.copyWith(count: int.parse(count));
    notifyListeners();
  }

  int get totalPrice => (product.count ?? 0) * int.parse(product.price!);
}
