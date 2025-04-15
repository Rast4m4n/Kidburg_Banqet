import 'package:flutter/material.dart';
import 'package:kidburg_banquet/api/google_sheet_api.dart';
import 'package:kidburg_banquet/data/repository/google_sheet_data_repository.dart';
import 'package:kidburg_banquet/domain/model/banqet_model.dart';
import 'package:kidburg_banquet/domain/model/category_model.dart';
import 'package:kidburg_banquet/domain/model/dish_model.dart';
import 'package:kidburg_banquet/domain/model/table_model.dart';
import 'package:kidburg_banquet/generated/l10n.dart';
import 'package:kidburg_banquet/presentation/screens/preorder_form/pre_order_form_vm.dart';
import 'package:kidburg_banquet/presentation/theme/app_paddings.dart';
import 'package:kidburg_banquet/presentation/theme/app_theme.dart';
import 'package:kidburg_banquet/presentation/widgets/custom_drawer.dart';
import 'package:kidburg_banquet/presentation/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

class PreOrderFormScreen extends StatefulWidget {
  const PreOrderFormScreen({super.key});

  @override
  State<PreOrderFormScreen> createState() => _PreOrderFormScreenState();
}

class _PreOrderFormScreenState extends State<PreOrderFormScreen> {
  late final PreOrderFormVm vm;

  @override
  void initState() {
    super.initState();
    vm = PreOrderFormVm(
      googleSheetRepository: GoogleSheetDataRepository(
        iApi: GoogleSheetApi(),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as BanquetModel;
    vm.banquetModel = args;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PreOrderFormVm>(
      create: (context) => vm,
      child: Scaffold(
        floatingActionButton: const _FloatingButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
        endDrawer: const CustomDrawer(),
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                S.of(context).placeAnOrder,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
        body: FutureBuilder<List<TableModel>>(
          future: vm.getTableData(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Ошибка: ${snapshot.error}'),
              );
            } else if (snapshot.hasData) {
              final tables = snapshot.data!;
              return SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppPadding.low),
                  child: _ServingsDishes(tables: tables),
                ),
              );
            } else {
              return const Center(child: Text('No data found'));
            }
          },
        ),
      ),
    );
  }
}

class _FloatingButton extends StatelessWidget {
  const _FloatingButton();

  @override
  Widget build(BuildContext context) {
    return Consumer<PreOrderFormVm>(
      builder: (context, vm, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text("${S.of(context).totalSum}: ${vm.getTotalSum()}",
                style: Theme.of(context).textTheme.bodyLarge),
            FloatingActionButton(
              backgroundColor: AppColor.cardPreviewColor,
              onPressed: () => vm.navigateToPreviewScreen(context),
              mini: true,
              child: const Icon(Icons.save),
            ),
          ],
        );
      },
    );
  }
}

class _ServingsDishes extends StatelessWidget {
  const _ServingsDishes({
    required this.tables,
  });

  final List<TableModel> tables;

  @override
  Widget build(BuildContext context) {
    return Consumer<PreOrderFormVm>(
      builder: (context, vm, child) {
        return Column(
          children: [
            ...tables.map((table) {
              return Dismissible(
                key: ValueKey(table.hashCode),
                background: Container(
                  color: Colors.red[200],
                  child: Center(
                    child: Text(
                      S.of(context).foodServiceRemoved,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ),
                onDismissed: (direction) =>
                    vm.swipeToDeleteData(tables.indexOf(table)),
                child: ExpansionTile(
                  initiallyExpanded: false,
                  collapsedBackgroundColor: AppColor.previewBackgroundColor,
                  textColor: AppColor.titleCardPreviewColor,
                  maintainState: true,
                  leading: InkWell(
                    child: const Icon(
                      Icons.access_time,
                      color: Colors.black,
                    ),
                    onTap: () => vm.changeTime(context, table),
                  ),
                  title: Text(
                    table.name,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  children: [
                    _ListDishes(
                      categories: table.categories,
                      tableIndex: tables.indexOf(table),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: AppPadding.low),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                style: Theme.of(context).elevatedButtonTheme.style,
                onPressed: () => vm.addNewServing(context),
                child: Text(
                  S.of(context).addServingDishes,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColor.infoCardPreviewColor,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ListDishes extends StatelessWidget {
  const _ListDishes({
    required this.categories,
    required this.tableIndex,
  });

  final int tableIndex;
  final List<CategoryModel> categories;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: categories.map((category) {
        return ExpansionTile(
          maintainState: true,
          title: Text(category.name),
          children: category.dishes.map((dish) {
            return DishWidget(
              dish: dish,
              tableIndex: tableIndex,
              categoryIndex: categories.indexOf(category),
            );
          }).toList(),
        );
      }).toList(),
    );
  }
}

class DishWidget extends StatelessWidget {
  const DishWidget({
    required this.dish,
    required this.tableIndex,
    required this.categoryIndex,
    super.key,
  });
  final DishModel dish;
  final int tableIndex;
  final int categoryIndex;
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PreOrderFormVm>(context);
    return ListTile(
      title: Text(dish.nameDish ?? ''),
      subtitle: Text(
        '${dish.weight ?? ''}  ${dish.price ?? ''}${S.of(context).markCurrency}',
      ),
      trailing: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 70),
        child: CustomTextField(
          label: S.of(context).quantity,
          onChanged: (value) {
            int? count = int.tryParse(value);
            vm.updateDishCount(
              tableIndex: tableIndex,
              categoryIndex: categoryIndex,
              currentDish: dish,
              newCount: count ?? 0,
            );
          },
        ),
      ),
    );
  }
}
