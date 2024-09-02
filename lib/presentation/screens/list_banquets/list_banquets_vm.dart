import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kidburg_banquet/data/file_manager/file_manager.dart';
import 'package:kidburg_banquet/data/repository/excel_repository.dart';
import 'package:kidburg_banquet/presentation/navigation/app_route.dart';
import 'package:open_filex/open_filex.dart';

class ListBanquetVM {
  final Directory directory = FileManager.directory;

  Future<void> openFile(FileSystemEntity file) async {
    await OpenFilex.open(file.path);
  }

  Future<void> deleteFile(FileSystemEntity file) async {
    await File(file.path).delete();
  }

  Future<void> editFile(FileSystemEntity file, BuildContext context) async {
    final excelRepo = ExcelRepository();
    final banquet = await excelRepo.editExcelFile(file.path);
    print(banquet.toString());
    if (context.mounted) {
      Navigator.of(context).pushNamed(AppRoute.mainPage, arguments: banquet);
    }
  }

  List<FileSystemEntity> sortedDirectory() {
    final directories = directory.listSync()
      ..sort(
          (a, b) => b.path.split('/').last.compareTo(a.path.split('/').last));
    return directories;
  }

  List<FileSystemEntity> sortedDirectoryMonth(FileSystemEntity directoryYear) {
    final directoriesMonth = Directory(directoryYear.path).listSync()
      ..sort((a, b) {
        return DateFormat("MMMM")
            .parse(b.path.split('/').last)
            .compareTo(DateFormat("MMMM").parse(a.path.split('/').last));
      });

    return directoriesMonth;
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
