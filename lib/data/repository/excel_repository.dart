import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kidburg_banquet/controller/excel_builder_controller.dart';
import 'package:kidburg_banquet/data/file_manager/file_manager.dart';
import 'package:kidburg_banquet/domain/model/banqet_model.dart';
import 'package:kidburg_banquet/domain/model/establishments_enum.dart';
import 'package:kidburg_banquet/domain/model/manager_model.dart';

class ExcelRepository {
  Future<void> writeNewExcelFile(BanquetModel banquet) async {
    final Excel excel = Excel.createExcel();
    Sheet sheet = excel.tables.values.first;

    final nameFile = FileManager.getFileName(banquet);
    String filePath = FileManager.filePath(nameFile, banquet);
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

  Future<BanquetModel> editExcelFile(String filePath) async {
    final bytes = File(filePath).readAsBytesSync();
    final excel = Excel.decodeBytes(bytes);
    final sheet = excel.tables.values.first;
    DateTime parsedTime = DateFormat("HH:mm")
        .parse(sheet.cell(CellIndex.indexByString('F3')).value.toString());
    DateTime parsedDate = DateFormat("MMMMd")
        .parse(sheet.cell(CellIndex.indexByString('F2')).value.toString());
    DateTime date = DateTime(
      DateTime.now().year,
      parsedDate.month,
      parsedDate.day,
    );
    final banquet = BanquetModel(
      nameClient: sheet.cell(CellIndex.indexByString('B2')).value.toString(),
      place: sheet.cell(CellIndex.indexByString('F4')).value.toString(),
      dateStart: date,
      timeStart: TimeOfDay(hour: parsedTime.hour, minute: parsedTime.minute),
      amountOfChildren:
          int.parse(sheet.cell(CellIndex.indexByString('F6')).value.toString()),
      amountOfAdult:
          int.parse(sheet.cell(CellIndex.indexByString('F7')).value.toString()),
      managerModel: ManagerModel(
        name: sheet.cell(CellIndex.indexByString('B4')).value.toString(),
        phoneNumber: sheet.cell(CellIndex.indexByString('B5')).value.toString(),
        establishmentEnum: EstablishmentsEnum.cdm,
      ),
    );
    return banquet;
  }
}
