import 'dart:io';

import 'package:kidburg_banquet/domain/model/banqet_model.dart';
import 'package:kidburg_banquet/presentation/utils/date_time_formatter.dart';

abstract final class FileManager {
  static final Directory directory = Directory('/storage/emulated/0/Download');

  static String getFileName(BanqetModel banquet) {
    final date = DateTimeFormatter.convertToDDMMYYY(banquet.dateStart);
    return "Банкет $date ${banquet.nameClient} ${banquet.place}.xlsx";
  }

  static String filePath(String nameFile) {
    return '${directory.path}/$nameFile';
  }

  static Future<void> existsDirectory() async {
    if (!await Directory(directory.path).exists()) {
      await Directory(directory.path).create(recursive: true);
    }
  }
}
