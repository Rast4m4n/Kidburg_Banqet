import 'package:flutter/material.dart';
import 'package:kidburg_banquet/data/repository/excel_repository.dart';
import 'package:kidburg_banquet/domain/model/product_model.dart';

class PreOrderFormVM extends ChangeNotifier {
  PreOrderFormVM({
    required this.excelRepository,
  });

  final ExcelRepository excelRepository;

  Future<List<ProductModel>> getProductModelFromExcel() async {
    return await excelRepository.readTemplateExcelFile();
  }
}
