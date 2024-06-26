import 'package:flutter/material.dart';
import 'package:kidburg_banquet/data/repository/excel_repository.dart';
import 'package:kidburg_banquet/domain/model/category_model.dart';
import 'package:kidburg_banquet/domain/model/dish_model.dart';
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
  late final PreOrderViewModel vm;

  @override
  void initState() {
    super.initState();
    vm = PreOrderViewModel(
      excelRepository: ExcelRepository(),
      scrollController: ScrollController(),
    );
    vm.scrollController.addListener(vm.listenScrollController);
    vm.isVisible = ValueNotifier<bool>(true);
  }

  @override
  void dispose() {
    super.dispose();
    vm.scrollController.removeListener(vm.listenScrollController);
    vm.scrollController.dispose();
    vm.isVisible.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => vm,
      child: ValueListenableBuilder<bool>(
        valueListenable: vm.isVisible,
        builder: (BuildContext context, bool isVisible, Widget? child) {
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              mini: isVisible,
              onPressed: () {},
              child: const Icon(Icons.save),
            ),
            floatingActionButtonLocation: vm.buttonLocation,
            appBar: AppBar(
              title: Text(
                'Кидбург банкеты',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            body: child!,
            bottomNavigationBar: _BottomNavigationBar(isVisible: isVisible),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(AppPadding.low),
          child: FutureBuilder(
            future: vm.readDataFromExcel(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final tableData = snapshot.data!;
                return _TableListWidget(
                  tableData: tableData,
                  controller: vm.scrollController,
                );
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

class _BottomNavigationBar extends StatelessWidget {
  const _BottomNavigationBar({
    super.key,
    required this.isVisible,
  });

  final bool isVisible;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: isVisible ? 60 : 0,
      child: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Row(
          children: [
            Consumer<PreOrderViewModel>(
              builder: (context, vm, child) {
                return Text("Сумма: ${vm.totalSumOfProducts}");
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _TableListWidget extends StatelessWidget {
  const _TableListWidget({
    super.key,
    required this.tableData,
    required this.controller,
  });

  final List<TableModel> tableData;
  final ScrollController controller;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: controller,
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

class _TableWidget extends StatefulWidget {
  const _TableWidget({
    super.key,
  });

  @override
  State<_TableWidget> createState() => _TableWidgetState();
}

class _TableWidgetState extends State<_TableWidget>
    with TickerProviderStateMixin {
  late final animationController = AnimationController(
    duration: const Duration(milliseconds: 200),
    vsync: this,
  );

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TableViewModel>(
      builder: (BuildContext context, TableViewModel vm, Widget? child) {
        if (vm.isVisibleTable) {
          animationController.forward();
        } else {
          animationController.reverse();
        }
        return Column(
          children: [
            child!,
            AnimatedBuilder(
              animation: animationController,
              builder: (context, child) {
                return SizeTransition(
                  sizeFactor: CurvedAnimation(
                    parent: animationController,
                    curve: Curves.linear,
                  ),
                  child: child,
                );
              },
              child: _CategoryListWidget(
                categories: vm.tableModel.categories,
              ),
            ),
          ],
        );
      },
      child: const Column(
        children: [
          _TitleTableWidget(),
          SizedBox(height: AppPadding.low),
        ],
      ),
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
          final products = category.dishes;
          return Column(
            children: [
              _CategoryNameWidget(name: category.name),
              _DishListWidget(products: products),
            ],
          );
        },
      ).toList(),
    );
  }
}

class _DishListWidget extends StatelessWidget {
  const _DishListWidget({
    super.key,
    required this.products,
  });

  final List<DishModel> products;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: products.map(
        (product) {
          return ChangeNotifierProvider(
            create: (context) => DishViewModel(
              dish: DishModel(
                idRow: product.idRow,
                nameDish: product.nameDish,
                weight: product.weight,
                price: product.price,
              ),
              preOrderViewModel: context.read<PreOrderViewModel>(),
            ),
            child: const RowDish(),
          );
        },
      ).toList(),
    );
  }
}

class RowDish extends StatelessWidget {
  const RowDish({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DishViewModel>();
    final totalPrice = vm.totalPrice != 0 ? "${vm.totalPrice}" : null;
    return Column(
      children: [
        const SizedBox(height: AppPadding.low),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 2,
                child: _InfoDishBoxWidget(
                  name: vm.dish.nameDish!,
                ),
              ),
              const SizedBox(width: AppPadding.low),
              Expanded(
                flex: 1,
                child: CustomTextField(
                  textAlign: TextAlign.center,
                  floatingLabelAlignment: FloatingLabelAlignment.center,
                  onChanged: (value) {
                    vm.updateCount(
                      (int.tryParse(value) ?? 0).toString(),
                    );
                  },
                  label: 'Кол-во',
                ),
              ),
              const SizedBox(width: AppPadding.low),
              Expanded(
                flex: 2,
                child: PriceBoxWidget(totalPrice: totalPrice),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppPadding.low),
      ],
    );
  }
}

class PriceBoxWidget extends StatelessWidget {
  const PriceBoxWidget({
    super.key,
    required this.totalPrice,
  });

  final String? totalPrice;

  @override
  Widget build(BuildContext context) {
    final InputDecorationTheme textFieldTheme =
        Theme.of(context).inputDecorationTheme;
    return TextField(
      maxLines: null,
      minLines: null,
      expands: true,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        floatingLabelAlignment: FloatingLabelAlignment.center,
        labelText: 'Сумма',
        enabledBorder: textFieldTheme.border,
        focusedBorder: InputBorder.none,
        filled: true,
        fillColor: AppColor.textFieldColor,
        border: InputBorder.none,
      ),
      readOnly: true,
      controller: TextEditingController(
        text: totalPrice,
      ),
    );
  }
}

class _InfoDishBoxWidget extends StatelessWidget {
  const _InfoDishBoxWidget({
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
