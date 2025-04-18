import 'dart:io';

import 'package:intl/intl.dart';
import 'package:kidburg_banquet/domain/model/banqet_model.dart';

abstract final class FileManager {
  static Directory directory =
      Directory('/storage/emulated/0/Download/Banquets');

  static Directory _createDirectoryByDate(BanquetModel banquet) {
    final monthOfBanquet = DateFormat('MMMM').format(banquet.dateStart);
    final directory = Directory(
        '/storage/emulated/0/Download/Banquets/${banquet.dateStart.year}/$monthOfBanquet');
    return directory;
  }

  static String getFileName(BanquetModel banquet) {
    final date = DateFormat('d MMMM').format(banquet.dateStart);
    return "$date ${banquet.nameClient} ${banquet.place}.xlsx";
  }

  static String filePath(String nameFile, BanquetModel banquet) {
    return "${_createDirectoryByDate(banquet).path}/$nameFile";
  }

  static Future<void> existsDirectory() async {
    if (!await Directory(directory.path).exists()) {
      await Directory(directory.path).create(recursive: true);
    }
  }
}
