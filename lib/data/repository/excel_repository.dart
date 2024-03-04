import 'package:excel/excel.dart';
import 'package:flutter/services.dart';
import 'package:kidburg_banquet/domain/model/product_model.dart';

class ExcelRepository {
  Future<Excel> convertToReadExcelFile() async {
    ByteData data = await rootBundle.load('assets/template_banquet.xlsx');
    var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    return Excel.decodeBytes(bytes);
  }

  Future<List<ProductModel>> readTemplateExcelFile() async {
    var excel = await convertToReadExcelFile();
    final List<ProductModel> productModel = [];
    //Читаю листы
    for (var table in excel.tables.keys) {
      //Читаю строки листов
      for (var row in excel.tables[table]!.rows) {
        // добавляем значения строки, если в строке 0 столбца есть число
        // На 0 столбце в файле идут id каждой позиции
        if (row[0]?.value is IntCellValue) {
          productModel.add(
            ProductModel(
              nameProduct: row[1]?.value.toString(),
              weight: row[3]?.value.toString(),
              price: row[6]?.value.toString(),
            ),
          );
        }
      }
    }
    return productModel;
  }
}
