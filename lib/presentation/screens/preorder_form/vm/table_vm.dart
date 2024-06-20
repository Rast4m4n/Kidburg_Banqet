import 'package:flutter/material.dart';
import 'package:kidburg_banquet/domain/model/table_model.dart';

class TableViewModel with ChangeNotifier {
  TableViewModel({
    required this.tableModel,
  });

  final TableModel tableModel;
  bool _isVisibleTable = true;

  bool get isVisibleTable => _isVisibleTable;

  void expandTable() {
    _isVisibleTable = !isVisibleTable;

    notifyListeners();
  }
}
