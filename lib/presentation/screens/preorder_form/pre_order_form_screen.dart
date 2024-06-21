import 'package:flutter/material.dart';
import 'package:kidburg_banquet/data/repository/excel_repository.dart';
import 'package:kidburg_banquet/domain/model/category_model.dart';
import 'package:kidburg_banquet/domain/model/product_model.dart';
import 'package:kidburg_banquet/domain/model/table_model.dart';
import 'package:kidburg_banquet/presentation/screens/preorder_form/vm/dish_vm.dart';
import 'package:kidburg_banquet/presentation/screens/preorder_form/vm/pre_order_vm.dart';
import 'package:kidburg_banquet/presentation/screens/preorder_form/vm/table_vm.dart';
import 'package:kidburg_banquet/presentation/theme/app_paddings.dart';
import 'package:kidburg_banquet/presentation/theme/app_theme.dart';
import 'package:kidburg_banquet/presentation/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

class PreOrderFormScreen extends StatefulWidget {
  const PreOrderFormScreen({super.key});

  @override
  State<PreOrderFormScreen> createState() => _PreOrderFormScreenState();
}

class _PreOrderFormScreenState extends State<PreOrderFormScreen> {
  final vm = PreOrderViewModel(
    excelRepository: ExcelRepository(),
  );

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
        child: ChangeNotifierProvider(
          create: (context) => vm,
          child: FutureBuilder(
            future: vm.readDataFromExcel(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final tableData = snapshot.data!;
                return _TableListWidget(tableData: tableData);
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class _TableListWidget extends StatelessWidget {
  const _TableListWidget({
    super.key,
    required this.tableData,
  });

  final List<TableModel> tableData;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: tableData.map(
          (table) {
            return Column(
              children: [
                ChangeNotifierProvider(
                  create: (context) => TableViewModel(tableModel: table),
                  child: const _TableWidget(),
                ),
              ],
            );
          },
        ).toList(),
      ),
    );
  }
}

class _TableWidget extends StatelessWidget {
  const _TableWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TableViewModel>();
    return Column(
      children: [
        const _TitleTableWidget(),
        const SizedBox(height: AppPadding.low),
        Visibility(
          maintainState: true,
          visible: vm.isVisibleTable,
          child: _CategoryListWidget(categories: vm.tableModel.categories),
        ),
      ],
    );
  }
}

class _CategoryListWidget extends StatelessWidget {
  const _CategoryListWidget({
    super.key,
    required this.categories,
  });

  final List<CategoryModel> categories;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: categories.map(
        (category) {
          final products = category.products;
          return Column(
            children: [
              _CategoryNameWidget(name: category.name),
              _ProductListWidget(products: products),
            ],
          );
        },
      ).toList(),
    );
  }
}

class _ProductListWidget extends StatelessWidget {
  const _ProductListWidget({
    super.key,
    required this.products,
  });

  final List<ProductModel> products;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: products.map(
        (product) {
          return ChangeNotifierProvider(
            create: (context) => DishViewModel(
              product: ProductModel(
                idRow: product.idRow,
                nameProduct: product.nameProduct,
                weight: product.weight,
                price: product.price,
              ),
            ),
            child: const RowProduct(),
          );
        },
      ).toList(),
    );
  }
}

class RowProduct extends StatelessWidget {
  const RowProduct({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DishViewModel>();
    return Column(
      children: [
        const SizedBox(height: AppPadding.low),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 2,
                child: _InfoProductBoxWidget(
                  name: vm.product.nameProduct!,
                ),
              ),
              const SizedBox(width: AppPadding.low),
              Expanded(
                flex: 1,
                child: CustomTextField(
                  onChanged: (value) => vm.updateCount(
                    (int.tryParse(value) ?? 0).toString(),
                  ),
                  label: 'Кол-во',
                ),
              ),
              const SizedBox(width: AppPadding.low),
              Expanded(
                flex: 2,
                child: _InfoProductBoxWidget(
                  name: "Сумма: ${vm.totalPrice}",
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppPadding.low),
      ],
    );
  }
}

class _InfoProductBoxWidget extends StatelessWidget {
  const _InfoProductBoxWidget({
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

class _TitleTableWidget extends StatelessWidget {
  const _TitleTableWidget({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TableViewModel>();
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
              vm.tableModel.name,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            IconButton(
              onPressed: vm.expandTable,
              icon: vm.isVisibleTable
                  ? const Icon(Icons.arrow_drop_down_sharp)
                  : const Icon(Icons.arrow_drop_up_sharp),
            )
          ],
        ),
      ),
    );
  }
}

class _CategoryNameWidget extends StatelessWidget {
  const _CategoryNameWidget({
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
