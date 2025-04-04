import 'dart:io';

import 'package:intl/intl.dart';
import 'package:kidburg_banquet/domain/model/banqet_model.dart';

abstract final class FileManager {
  static Directory directory =
      Directory('/storage/emulated/0/Download/Банкеты');

  static Directory _createDirectoryByDate(BanqetModel banquet) {
    final monthOfBanquet = DateFormat('MMMM').format(banquet.dateStart);
    directory = Directory(
        '/storage/emulated/0/Download/Банкеты/${banquet.dateStart.year}/$monthOfBanquet');
    return directory;
  }

  static String getFileName(BanqetModel banquet) {
    final date = DateFormat('d MMMM').format(banquet.dateStart);
    return "Банкет $date ${banquet.nameClient} ${banquet.place}.xlsx";
  }

  static String filePath(String nameFile, BanqetModel banquet) {
    return "${_createDirectoryByDate(banquet).path}/$nameFile";
  }

  static Future<void> existsDirectory() async {
    if (!await Directory(directory.path).exists()) {
      await Directory(directory.path).create(recursive: true);
    }
  }
}
