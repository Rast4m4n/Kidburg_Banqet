import 'package:flutter/material.dart';

class DishViewModel with ChangeNotifier {
  DishViewModel({
    required this.name,
    required this.price,
    this.count = 0,
  });

  final String name;
  final int price;
  int count;

  void updateCount(String count) {
    this.count = int.parse(count);
    notifyListeners();
  }

  int get totalPrice => count * price;
}
