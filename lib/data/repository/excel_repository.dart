import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:kidburg_banquet/domain/model/banqet_model.dart';
import 'package:kidburg_banquet/domain/model/category_enum.dart';
import 'package:kidburg_banquet/domain/model/category_model.dart';
import 'package:kidburg_banquet/domain/model/dish_model.dart';
import 'package:kidburg_banquet/domain/model/table_model.dart';
import 'package:path_provider/path_provider.dart';

class ExcelRepository {
  Future<Excel> _convertToReadExcelFile() async {
    ByteData data = await rootBundle.load('assets/template_banquet.xlsx');
    var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    return Excel.decodeBytes(bytes);
  }

  /// Выводит данные с первого листа excel файла
  Future<List<List<Data?>>> _convertAndReadFirstListExcelFile() async {
    var excel = await _convertToReadExcelFile();
    return excel.tables[excel.tables.keys.first]!.rows;
  }

  Future<List<TableModel>> readDataExcel() async {
    final List<List<Data?>> excelData =
        await _convertAndReadFirstListExcelFile();

    String tableNameTmp = '';
    String categoryNameTmp = '';

    List<TableModel> tableModel = [];
    List<DishModel> dishModel = [];
    List<CategoryModel> categoryModel = [];

    for (var row in excelData) {
      CellValue? cellValue = row[0]?.value;

      if (cellValue is IntCellValue) {
        dishModel.add(
          DishModel(
            rowIndex: row[0]!.rowIndex,
            nameDish: row[1]?.value.toString(),
            weight: row[3]?.value.toString(),
            price: row[6]?.value.toString(),
          ),
        );
      }

      // Если ячейка равна значению категории,
      // то она записывается в categoryNameTmp.
      // Если productModel не пустой, то он
      // записывается в CategoryModel с текущим
      // categoryNameTmp, а потом меняет на новый
      for (var category in CategoryEnum.values) {
        if (cellValue.toString() == category.name) {
          if (dishModel.isNotEmpty) {
            categoryModel.add(
              CategoryModel(
                name: categoryNameTmp,
                dishes: dishModel,
              ),
            );
            dishModel = [];
          }
          categoryNameTmp = cellValue.toString();
          continue;
        }
      }

      // Если ячейка равна значению в условии,
      // то мы сначала записываем значение в tmp,
      // при переходе к следующему условию и когда
      // категории уже не пустые, мы добавляем в список
      // categoryModel последние полученные данные и
      // вписываем их в список tableModel, а потом
      // делаем категории и продукты пустые и совершаем
      // повторную итерацию
      if (cellValue.toString() == "СТОЛ ДЛЯ ВЗРОСЛЫХ" ||
          cellValue.toString() == "ДЕТСКИЙ СТОЛ") {
        if (categoryModel.isNotEmpty) {
          categoryModel.add(
            CategoryModel(name: categoryNameTmp, dishes: dishModel),
          );
          tableModel.add(
            TableModel(
              name: tableNameTmp,
              categories: categoryModel,
            ),
          );
          categoryModel = [];
          dishModel = [];
        }
        tableNameTmp = cellValue.toString();
        continue;
      }
    }

    // Для вывода детского стола и последней категории с блюдами
    if (categoryModel.isNotEmpty) {
      categoryModel.add(
        CategoryModel(name: categoryNameTmp, dishes: dishModel),
      );
      tableModel.add(
        TableModel(
          name: tableNameTmp,
          categories: categoryModel,
        ),
      );
    }
    return tableModel;
  }

  Future<void> writeDataToExcel(BanqetModel banquet) async {
    final Excel templateExcelFile = await _convertToReadExcelFile();
    Sheet sourceSheet = templateExcelFile.tables.values.first;

    final date =
        "${banquet.dateStart.day}.${banquet.dateStart.month}.${banquet.dateStart.year}";

    final nameFile = "Банкет $date ${banquet.nameClient} ${banquet.place}.xlsx";
    Directory directory = Directory('/storage/emulated/0/Download');
    String filePath = '${directory.path}/$nameFile';

    if (!await Directory(directory.path).exists()) {
      await Directory(directory.path).create(recursive: true);
    } else {
      print('Дериктория найдена: ${directory.path}');
    }

    // записываем новые данные в destinationSheet
    for (int row = 0; row < sourceSheet.maxRows; row++) {
      for (int col = 0; col < sourceSheet.maxColumns; col++) {
        final cell = sourceSheet.cell(
          CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row),
        );
        for (TableModel table in banquet.tables!) {
          //ошибка: даже если в приложении нет взрослого или детского стола
          //условие всё равно будет выполняться и будет заменятся значение
          //в ячейке, необходимо исправить!!!
          if (cell.value.toString() == "СТОЛ ДЛЯ ВЗРОСЛЫХ") {
            sourceSheet.cell(cell.cellIndex).value = TextCellValue(table.name);
            continue;
          } else if (cell.value.toString() == "ДЕТСКИЙ СТОЛ") {
            sourceSheet.cell(cell.cellIndex).value = TextCellValue(table.name);
            continue;
          }
          for (CategoryModel category in table.categories) {
            for (DishModel dish in category.dishes) {
              if (cell.rowIndex == dish.rowIndex) {
                if (col == 5) {
                  // print(dish.toString());
                  sourceSheet.cell(cell.cellIndex).value = dish.count != null
                      ? IntCellValue(dish.count!)
                      : const IntCellValue(0);
                }
              }
            }
          }
        }
      }
    }

    try {
      File(filePath)
        ..createSync(recursive: true)
        ..writeAsBytesSync(
          templateExcelFile.save()!,
        );
    } catch (e) {
      print('Ошибка сохранения файла: $e');
    }
  }
}
