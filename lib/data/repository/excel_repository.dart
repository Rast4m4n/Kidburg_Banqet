import 'package:excel/excel.dart';
import 'package:flutter/services.dart';
import 'package:kidburg_banquet/domain/model/category_enum.dart';
import 'package:kidburg_banquet/domain/model/category_model.dart';
import 'package:kidburg_banquet/domain/model/product_model.dart';
import 'package:kidburg_banquet/domain/model/table_model.dart';

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
    List<ProductModel> productModel = [];
    List<CategoryModel> categoryModel = [];

    for (var row in excelData) {
      CellValue? cellValue = row[0]?.value;

      if (cellValue is IntCellValue) {
        productModel.add(
          ProductModel(
            idRow: row[0]!.rowIndex,
            nameProduct: row[1]?.value.toString(),
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
          if (productModel.isNotEmpty) {
            categoryModel.add(
              CategoryModel(
                name: categoryNameTmp,
                products: productModel,
              ),
            );
            productModel = [];
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
            CategoryModel(name: categoryNameTmp, products: productModel),
          );
          tableModel.add(
            TableModel(
              name: tableNameTmp,
              categories: categoryModel,
            ),
          );
          categoryModel = [];
          productModel = [];
        }
        tableNameTmp = cellValue.toString();
        continue;
      }
    }

    // Для вывода детского стола и последней категории с блюдами
    if (categoryModel.isNotEmpty) {
      categoryModel.add(
        CategoryModel(name: categoryNameTmp, products: productModel),
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
}
