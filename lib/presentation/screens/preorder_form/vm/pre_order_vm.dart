import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:kidburg_banquet/data/repository/excel_repository.dart';
import 'package:kidburg_banquet/domain/model/product_model.dart';
import 'package:kidburg_banquet/domain/model/table_model.dart';

class PreOrderViewModel with ChangeNotifier {
  PreOrderViewModel({
    required this.excelRepository,
    required this.scrollController,
  });

  final ExcelRepository excelRepository;
  final List<ProductModel> products = [];
  int _totalSumOfProducts = 0;
  int get totalSumOfProducts => _totalSumOfProducts;

  final ScrollController scrollController;
  ValueNotifier<bool> isVisible = ValueNotifier(true);
  FloatingActionButtonLocation get buttonLocation => isVisible.value
      ? FloatingActionButtonLocation.miniEndDocked
      : FloatingActionButtonLocation.endFloat;

  void listenScrollController() {
    switch (scrollController.position.userScrollDirection) {
      case ScrollDirection.idle:
        break;
      case ScrollDirection.forward:
        _showNavBar();
      case ScrollDirection.reverse:
        _hideNavBar();
    }
  }

  void _showNavBar() {
    if (!isVisible.value) isVisible.value = true;
  }

  void _hideNavBar() {
    if (isVisible.value) isVisible.value = false;
  }

  Future<List<TableModel>> readDataFromExcel() async {
    return await excelRepository.readDataExcel();
  }

  void calculateSumOfProducts() {
    _totalSumOfProducts = products.fold(
      0,
      (previousProduct, currentProduct) =>
          previousProduct +
          (int.parse(currentProduct.price!) * currentProduct.count!),
    );
    notifyListeners();
  }
}
