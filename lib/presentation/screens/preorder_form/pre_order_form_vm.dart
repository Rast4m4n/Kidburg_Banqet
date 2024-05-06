// import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:kidburg_banquet/data/repository/excel_repository.dart';
import 'package:kidburg_banquet/domain/model/table_model.dart';

class PreOrderFormVM extends ChangeNotifier {
  PreOrderFormVM({
    required this.excelRepository,
  });

  final ExcelRepository excelRepository;

  Future<List<TableModel>> getProductModelFromExcel() async {
    return await excelRepository.readDataExcel();
  }
}
