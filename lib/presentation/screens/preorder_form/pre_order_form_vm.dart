import 'package:flutter/material.dart';
import 'package:kidburg_banquet/data/repository/excel_repository.dart';

class PreOrderFormVM extends ChangeNotifier {
  PreOrderFormVM({
    required this.excelRepository,
  });

  final ExcelRepository excelRepository;
}
