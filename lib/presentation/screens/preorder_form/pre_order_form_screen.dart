import 'package:flutter/material.dart';
import 'package:kidburg_banquet/data/repository/excel_repository.dart';
import 'package:kidburg_banquet/presentation/screens/preorder_form/pre_order_form_vm.dart';
import 'package:kidburg_banquet/presentation/theme/app_paddings.dart';
import 'package:kidburg_banquet/presentation/theme/app_theme.dart';

class PreOrderFormScreen extends StatelessWidget {
  PreOrderFormScreen({super.key});

  final PreOrderFormVM vm = PreOrderFormVM(
    excelRepository: ExcelRepository(),
  );

  @override
  Widget build(BuildContext context) {
    print(vm.excelRepository.readExcelFile());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Кидбург банкеты',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppPadding.low),
        child: ListView(
          children: const [
            _TitleTableForAdult(),
          ],
        ),
      ),
    );
  }
}

class _TitleTableForAdult extends StatelessWidget {
  const _TitleTableForAdult({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColor.tableForAdult,
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.low),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Стол для взрослых на начало',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.arrow_drop_down_sharp),
            )
          ],
        ),
      ),
    );
  }
}
