import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kidburg_banquet/presentation/screens/list_banquets/list_banquets_vm.dart';
import 'package:kidburg_banquet/presentation/widgets/custom_drawer.dart';
import 'package:provider/provider.dart';

class ListBanquetsScreen extends StatefulWidget {
  const ListBanquetsScreen({super.key});

  @override
  State<ListBanquetsScreen> createState() => _ListBanquetsScreenState();
}

class _ListBanquetsScreenState extends State<ListBanquetsScreen> {
  final vm = ListBanquetVM();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const CustomDrawer(),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Список банкетов',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
      body: ChangeNotifierProvider(
        create: (context) => vm,
        child: const _DirectoryYearWidget(),
      ),
    );
  }
}

class _DirectoryYearWidget extends StatelessWidget {
  const _DirectoryYearWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ListBanquetVM>(
      builder: (context, vm, child) {
        final directories = vm.sortedDirectory();
        return ListView.builder(
          addAutomaticKeepAlives: false,
          addRepaintBoundaries: false,
          itemCount: directories.length,
          itemBuilder: (context, index) {
            final directoryYear = directories[index];
            return Column(
              children: [
                ListTile(
                  title:
                      Center(child: Text(directoryYear.path.split('/').last)),
                  titleTextStyle: Theme.of(context).textTheme.headlineMedium,
                ),
                _DirectoryMonthWidget(directoryYear: directoryYear),
              ],
            );
          },
        );
      },
    );
  }
}

class _DirectoryMonthWidget extends StatelessWidget {
  const _DirectoryMonthWidget({
    super.key,
    required this.directoryYear,
  });

  final FileSystemEntity directoryYear;

  @override
  Widget build(BuildContext context) {
    return Consumer<ListBanquetVM>(
      builder: (BuildContext context, vm, Widget? child) {
        if (directoryYear.existsSync()) {
          final directoriesMonth = vm.sortedDirectoryMonth(directoryYear);
          return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            addAutomaticKeepAlives: false,
            addRepaintBoundaries: false,
            shrinkWrap: true,
            itemCount: directoriesMonth.length,
            itemBuilder: (context, index) {
              final directoryMonth = directoriesMonth[index];
              return Column(
                children: [
                  ListTile(
                    title: Center(
                        child: Text(directoryMonth.path.split('/').last)),
                    titleTextStyle: Theme.of(context).textTheme.bodyLarge,
                  ),
                  _FileWidget(directoryMonth: directoryMonth),
                ],
              );
            },
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}

class _FileWidget extends StatelessWidget {
  const _FileWidget({
    super.key,
    required this.directoryMonth,
  });

  final FileSystemEntity directoryMonth;

  @override
  Widget build(BuildContext context) {
    return Consumer<ListBanquetVM>(
      builder: (context, vm, child) {
        final files = vm.sortedFilesByDateInName(directoryMonth);
        return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          addAutomaticKeepAlives: false,
          addRepaintBoundaries: false,
          shrinkWrap: true,
          itemCount: files.length,
          itemBuilder: (context, index) {
            final file = files[index];
            return Card(
              child: ListTile(
                contentPadding: const EdgeInsets.all(8),
                title: Text(file.path.split('/').last),
                trailing: PopupMenuButton(
                  icon: const Icon(Icons.more_vert),
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        child: const Text('Открыть'),
                        onTap: () async => vm.openFile(file),
                      ),
                      const PopupMenuItem(
                        child: Text('Отправить'),
                      ),
                      PopupMenuItem(
                        child: const Text('Удалить'),
                        onTap: () async => _dialogConfirmDeletFile(
                          context,
                          file,
                          vm,
                        ),
                      ),
                    ];
                  },
                ),
                onTap: () async {
                  vm.openFile(file);
                },
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _dialogConfirmDeletFile(
      BuildContext context, FileSystemEntity file, ListBanquetVM vm) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Удалить файл'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Отмена'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Удалить'),
              onPressed: () async {
                await vm.deleteFile(file);
                if (context.mounted) Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
