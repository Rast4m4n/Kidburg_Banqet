import 'dart:io';

import 'package:excel/excel.dart';
import 'package:kidburg_banquet/controller/excel_builder_controller.dart';
import 'package:kidburg_banquet/data/file_manager/file_manager.dart';
import 'package:kidburg_banquet/domain/model/banqet_model.dart';

class ExcelRepository {
  Future<void> writeNewExcelFile(BanqetModel banquet) async {
    final Excel excel = Excel.createExcel();
    Sheet sheet = excel.tables.values.first;

    final nameFile = FileManager.getFileName(banquet);
    String filePath = FileManager.filePath(nameFile);
    await FileManager.existsDirectory();

    final ExcelBuilderController excelBuilder =
        ExcelBuilderController(sheet: sheet);
    excelBuilder.writeNewExcelFile(banquet);

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
