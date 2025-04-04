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
    final directories = vm.sortedDirectory();
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
      body: Provider(
        create: (context) => vm,
        child: ListView.builder(
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
        ),
      ),
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
    final vm = context.read<ListBanquetVM>();
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
              title: Center(child: Text(directoryMonth.path.split('/').last)),
              titleTextStyle: Theme.of(context).textTheme.bodyLarge,
            ),
            _FileWidget(directoryMonth: directoryMonth),
          ],
        );
      },
    );
  }
}

class _FileWidget extends StatefulWidget {
  const _FileWidget({
    super.key,
    required this.directoryMonth,
  });

  final FileSystemEntity directoryMonth;

  @override
  State<_FileWidget> createState() => _FileWidgetState();
}

class _FileWidgetState extends State<_FileWidget> {
  @override
  Widget build(BuildContext context) {
    final vm = context.read<ListBanquetVM>();
    final files = vm.sortedFilesByDateInName(widget.directoryMonth);
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
                    child: const Text('Редактировать'),
                    onTap: () async {
                      vm.editFile(file, context);
                    },
                  ),
                  const PopupMenuItem(
                    child: Text('Отправить'),
                  ),
                  PopupMenuItem(
                    child: const Text('Удалить'),
                    onTap: () async {
                      vm.deleteFile(file);
                      setState(() {});
                    },
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
  }
}
