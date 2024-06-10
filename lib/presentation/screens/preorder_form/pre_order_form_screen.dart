import 'package:flutter/material.dart';
import 'package:kidburg_banquet/data/repository/excel_repository.dart';
import 'package:kidburg_banquet/domain/model/category_model.dart';
import 'package:kidburg_banquet/domain/model/product_model.dart';
import 'package:kidburg_banquet/domain/model/table_model.dart';
import 'package:kidburg_banquet/presentation/screens/preorder_form/vm/dish_vm.dart';
import 'package:kidburg_banquet/presentation/screens/preorder_form/vm/pre_order_vm.dart';
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
  final vm = PreOrderViewModel(excelRepository: ExcelRepository());

  @override
  void initState() {
    super.initState();
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
    return ListView.builder(
      itemCount: tableData.length,
      itemBuilder: (context, index) {
        final categories = tableData[index].categories;
        return Column(
          children: [
            _TitleTableWidget(name: tableData[index].name),
            const SizedBox(height: AppPadding.low),
            _CategoryListWidget(categories: categories),
          ],
        );
      },
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
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final products = categories[index].products;
        return Column(
          children: [
            _CategoryNameWidget(name: categories[index].name),
            _ProductListWidget(products: products),
          ],
        );
      },
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
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: products.length,
      itemBuilder: (context, index) {
        return ChangeNotifierProvider(
          create: (context) => DishViewModel(
            name: products[index].nameProduct!,
            price: int.parse(products[index].price!),
          ),
          child: const RowProduct(),
        );
      },
    );
  }
}

class RowProduct extends StatelessWidget {
  const RowProduct({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dishVM = context.watch<DishViewModel>();
    return Column(
      children: [
        const SizedBox(height: AppPadding.low),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 2,
                child: _PriceBoxWidget(
                  name: dishVM.name,
                ),
              ),
              const SizedBox(width: AppPadding.low),
              Expanded(
                flex: 1,
                child: CustomTextField(
                  onChanged: (value) => dishVM.updateCount(
                    (int.tryParse(value) ?? 0).toString(),
                  ),
                  label: 'Кол-во',
                ),
              ),
              const SizedBox(width: AppPadding.low),
              Expanded(
                flex: 2,
                child: _PriceBoxWidget(
                  name: "Сумма: ${dishVM.totalPrice}",
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

class _PriceBoxWidget extends StatelessWidget {
  const _PriceBoxWidget({
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
