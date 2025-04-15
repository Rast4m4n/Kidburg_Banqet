import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:kidburg_banquet/controller/excel_builder_controller.dart';
import 'package:kidburg_banquet/data/file_manager/file_manager.dart';
import 'package:kidburg_banquet/domain/model/banqet_model.dart';

class ExcelRepository {
  Future<void> writeNewExcelFile(
      BanquetModel banquet, BuildContext context) async {
    final Excel excel = Excel.createExcel();
    Sheet sheet = excel.tables.values.first;

    final nameFile = FileManager.getFileName(banquet);
    String filePath = FileManager.filePath(nameFile, banquet);
    await FileManager.existsDirectory();

    late final ExcelBuilderController excelBuilder;
    if (context.mounted) {
      excelBuilder = ExcelBuilderController(sheet: sheet);
      excelBuilder.writeNewExcelFile(banquet, context);
    }
    _saveBanquetExcelFile(filePath, excel);
  }

  void _saveBanquetExcelFile(String filePath, Excel excelFile) {
    try {
      final file = File(filePath);
      if (!file.existsSync()) {
        file.createSync(recursive: true);
      }
      var fileBytes = excelFile.save();

      file.writeAsBytesSync(fileBytes!);
    } catch (e) {
      throw "Ошибка сохранения файла: $e";
    }
  }
}
