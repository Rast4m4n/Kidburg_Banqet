import 'package:flutter/material.dart';
import 'package:kidburg_banquet/data/repository/excel_repository.dart';
import 'package:kidburg_banquet/domain/model/table_model.dart';
import 'package:kidburg_banquet/presentation/screens/preorder_form/pre_order_form_vm.dart';
import 'package:kidburg_banquet/presentation/theme/app_paddings.dart';
import 'package:kidburg_banquet/presentation/theme/app_theme.dart';
import 'package:kidburg_banquet/presentation/widgets/custom_text_field.dart';

class PreOrderFormScreen extends StatefulWidget {
  const PreOrderFormScreen({super.key});

  @override
  State<PreOrderFormScreen> createState() => _PreOrderFormScreenState();
}

class _PreOrderFormScreenState extends State<PreOrderFormScreen> {
  final PreOrderFormVM vm = PreOrderFormVM(
    excelRepository: ExcelRepository(),
  );

  List<Widget> generateRowProduct(List<TableModel> tableWithFood) {
    final List<Widget> widgets = [];

    for (var table in tableWithFood) {
      widgets.add(_TitleTableForAdult(name: table.name));
      widgets.add(const SizedBox(height: AppPadding.low));
      for (var category in table.categories) {
        widgets.add(_CategoryOfProduct(name: category.name));
        widgets.add(const SizedBox(height: AppPadding.low));
        for (var product in category.products) {
          widgets.add(RowProduct(name: product.nameProduct!));
          widgets.add(const SizedBox(height: AppPadding.low));
        }
      }
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
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
          children: [
            FutureBuilder(
              future: vm.getProductModelFromExcel(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final tableWithFood = snapshot.data!;
                  return Column(children: generateRowProduct(tableWithFood));
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class RowProduct extends StatelessWidget {
  const RowProduct({
    super.key,
    required this.name,
  });
  final String name;
  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 2,
            child: _BoxInformationProduct(
              name: name,
            ),
          ),
          const SizedBox(width: AppPadding.low),
          Expanded(
            flex: 1,
            child: CustomTextField(
              controller: TextEditingController(),
              label: 'Кол-во',
            ),
          ),
          const SizedBox(width: AppPadding.low),
          const Expanded(
            flex: 2,
            child: _BoxInformationProduct(
              name: 'Сумма',
            ),
          ),
        ],
      ),
    );
  }
}

class _BoxInformationProduct extends StatelessWidget {
  const _BoxInformationProduct({
    super.key,
    required this.name,
  });
  final String name;
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColor.textFieldColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.low),
        child: Text(name),
      ),
    );
  }
}

class _TitleTableForAdult extends StatelessWidget {
  const _TitleTableForAdult({
    super.key,
    required this.name,
  });
  final String name;
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
              name,
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

class _CategoryOfProduct extends StatelessWidget {
  const _CategoryOfProduct({
    super.key,
    required this.name,
  });

  final String name;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.blueGrey,
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.low),
        child: Row(
          children: [
            Text(
              name,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
