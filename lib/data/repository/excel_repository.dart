import 'package:excel/excel.dart';
import 'package:flutter/services.dart';

class ExcelRepository {
  Future<Excel> convertToReadExcelFile() async {
    ByteData data = await rootBundle.load('assets/template_banquet.xlsx');
    var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    return Excel.decodeBytes(bytes);
  }

  Future<void> readExcelFile() async {
    var excel = await convertToReadExcelFile();
    for (var table in excel.tables.keys) {
      print(table); //sheet Name
      print(excel.tables[table]!.maxColumns);
      print(excel.tables[table]!.maxRows);
      for (var row in excel.tables[table]!.rows) {
        print('$row');
      }
    }
  }
}
