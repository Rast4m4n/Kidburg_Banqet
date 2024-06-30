import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/services.dart';
import 'package:kidburg_banquet/domain/model/banqet_model.dart';
import 'package:kidburg_banquet/domain/model/category_enum.dart';
import 'package:kidburg_banquet/domain/model/category_model.dart';
import 'package:kidburg_banquet/domain/model/dish_model.dart';
import 'package:kidburg_banquet/domain/model/table_model.dart';
import 'package:kidburg_banquet/presentation/utils/date_time_formatter.dart';

class ExcelRepository {
  Future<Excel> _convertToReadExcelFile() async {
    try {
      ByteData data = await rootBundle.load('assets/template_banquet.xlsx');
      var bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      return Excel.decodeBytes(bytes);
    } catch (e) {
      throw "Ошибка загрузки или декодирования файла: $e";
    }
  }

  /// Выводит данные с первого листа excel файла
  Future<List<List<Data?>>> _convertAndReadFirstListExcelFile() async {
    try {
      var excel = await _convertToReadExcelFile();
      var firstTableKey = excel.tables.keys.first;
      if (excel.tables[firstTableKey] != null) {
        return excel.tables[firstTableKey]!.rows;
      } else {
        throw "Ошибка: Таблица не найдена.";
      }
    } catch (e) {
      throw "Ошибка чтения данных из файла: $e";
    }
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
    }

    final secondServingTable =
        DateTimeFormatter.calculateNextServingTime(banquet.firstTimeServing);
    // записываем новые данные в sourceSheet
    for (int row = 0; row < sourceSheet.maxRows; row++) {
      for (int col = 0; col < sourceSheet.maxColumns; col++) {
        final cell = sourceSheet.cell(
          CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row),
        );

        final isNameCustomer = col == 2 && row == 2;
        final isDateStartEvent = col == 7 && row == 2;
        final isTimeStartEvent = col == 7 && row == 3;
        final isPlaceEvent = col == 7 && row == 4;
        final isAmountOfChildrer = col == 8 && row == 6;
        final isAmountOfAdult = col == 8 && row == 7;

        if (isNameCustomer) {
          cell.value = TextCellValue(banquet.nameClient);
        }

        if (isDateStartEvent) {
          cell.value =
              TextCellValue(DateTimeFormatter.formatDMM(banquet.dateStart));
        }

        if (isTimeStartEvent) {
          cell.value = TextCellValue(
            DateTimeFormatter.convertToUTC24StringFormat(
                banquet.firstTimeServing),
          );
        }

        if (isPlaceEvent) {
          cell.value = TextCellValue(banquet.place);
        }

        if (isAmountOfChildrer) {
          cell.value = IntCellValue(banquet.amountOfChildren);
        }

        if (isAmountOfAdult) {
          cell.value = IntCellValue(banquet.amountOfAdult);
        }

        for (TableModel table in banquet.tables!) {
          //Запись вида стола и времени подачи
          final equalityNameTable = table.name == cell.value.toString();
          if (equalityNameTable &&
              cell.value.toString() == "СТОЛ ДЛЯ ВЗРОСЛЫХ") {
            cell.value = TextCellValue(
                '${table.name} НА ${DateTimeFormatter.convertToUTC24StringFormat(banquet.firstTimeServing)}');
            sourceSheet.setRowHeight(cell.rowIndex, 50);
            continue;
          } else if (equalityNameTable &&
              cell.value.toString() == "ДЕТСКИЙ СТОЛ") {
            cell.value = TextCellValue(
              '${table.name} НА ${DateTimeFormatter.convertToUTC24StringFormat(secondServingTable)}',
            );
            sourceSheet.setRowHeight(cell.rowIndex, 50);
            continue;
          }

          //Запись значений dish.count в ячейки количества блюд
          for (CategoryModel category in table.categories) {
            for (DishModel dish in category.dishes) {
              if (cell.rowIndex == dish.rowIndex) {
                if (col == 5) {
                  sourceSheet.cell(cell.cellIndex).value = dish.count != null
                      ? IntCellValue(dish.count!)
                      : const IntCellValue(0);
                  sourceSheet.setRowHeight(cell.rowIndex, 40);
                }
                if (col == 8) {
                  try {
                    cell.setFormula(
                        'SUM(G${cell.rowIndex + 1}*F${cell.rowIndex + 1})');
                  } catch (e) {
                    print('Ошибка установки формулы: $e');
                  }
                }
              }
            }
          }
        }
      }
    }

    try {
      final file = File(filePath);
      if (!file.existsSync()) {
        file.createSync(recursive: true);
      }
      var fileBytes = templateExcelFile.save(fileName: nameFile);
      file.writeAsBytesSync(fileBytes!);
    } catch (e) {
      throw "Ошибка сохранения файла: $e";
    }
  }
}
