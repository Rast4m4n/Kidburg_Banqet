import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kidburg_banquet/data/file_manager/file_manager.dart';
import 'package:open_filex/open_filex.dart';
import 'package:share_plus/share_plus.dart';

class ListBanquetVM with ChangeNotifier {
  final Directory directory = FileManager.directory;

  Future<void> openFile(FileSystemEntity file) async {
    await OpenFilex.open(file.path);
  }

  Future<void> shareFile(FileSystemEntity file, locale) async {
    // Текст отсылается только в телеграм, но не в востапп
    late final String text;
    if (locale.languageCode == 'ru') {
      text =
          'Это ваш бланк предзаказа по меню, проверьте, всё ли верно по времени подачи и позициям';
    } else {
      text =
          'This is your menu pre-order form, please check that everything is correct regarding serving time and items';
    }
    await Share.shareXFiles(
      [XFile(file.path)],
      text: text,
    );
  }

  Future<void> deleteFile(FileSystemEntity file) async {
    // директория /storage/emulated/0/Download/Banquets/"Год"/"Месяц"
    final directoryMonth = file.parent;
    // директория /storage/emulated/0/Download/Banquets/"Год"
    final directoryYear = file.parent.parent;
    await File(file.path).delete();
    if (directoryMonth.listSync().isEmpty) {
      await directoryMonth.delete();
    }
    if (directoryYear.listSync().isEmpty) {
      await directoryYear.delete();
    }

    notifyListeners();
  }

  List<FileSystemEntity> sortedDirectory() {
    final directories = directory.listSync()
      ..sort(
          (a, b) => b.path.split('/').last.compareTo(a.path.split('/').last));

    return directories;
  }

  List<FileSystemEntity> sortedDirectoryMonth(FileSystemEntity directoryYear) {
    final directoryMonth = Directory(directoryYear.path).listSync()
      ..sort((a, b) {
        return DateFormat("MMMM")
            .parse(b.path.split('/').last)
            .compareTo(DateFormat("MMMM").parse(a.path.split('/').last));
      });
    return directoryMonth;
  }

  List<FileSystemEntity> sortedFilesByDateInName(
      FileSystemEntity directoryMonth) {
    final files = Directory(directoryMonth.path).listSync();
    files.sort((a, b) {
      final aName = a.path.split('/').last;
      final bName = b.path.split('/').last;
      // Извлекаем число из названия файла с помощью регулярного выражения
      final aNumber =
          int.tryParse(RegExp(r'\d+').firstMatch(aName)?.group(0) ?? '0') ?? 0;
      final bNumber =
          int.tryParse(RegExp(r'\d+').firstMatch(bName)?.group(0) ?? '0') ?? 0;
      return aNumber.compareTo(bNumber);
    });
    return files;
  }
}
