import 'package:flutter/material.dart';
import 'package:kidburg_banquet/data/repository/google_sheet_data_repository.dart';
import 'package:kidburg_banquet/domain/model/category_model.dart';
import 'package:kidburg_banquet/domain/model/dish_model.dart';
import 'package:kidburg_banquet/domain/model/table_model.dart';
import 'package:kidburg_banquet/presentation/screens/preorder_form/pre_order_form_vm.dart';
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
  late final PreOrderFormVm vm;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    vm = PreOrderFormVm(
      googleSheetRepository: GoogleSheetDataRepository(),
      scrollController: _scrollController,
      scrollVisibilityManager: ScrollVisibilityManagerImpl(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    vm.scrollController.dispose();
    vm.isVisible.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PreOrderFormVm>(
      create: (context) => vm,
      child: ValueListenableBuilder<bool>(
        valueListenable: vm.isVisible,
        builder: (context, isVisible, child) {
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              backgroundColor: AppColor.cardPreviewColor,
              mini: isVisible,
              onPressed: () => vm.navigateToPreviewScreen(context),
              child: const Icon(Icons.save),
            ),
            floatingActionButtonLocation: vm.buttonLocation,
            appBar: AppBar(
              title: Text(
                'Оформление банкета',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            body: child!,
            bottomNavigationBar: _BottomNavigationBar(isVisible: isVisible),
          );
        },
        child: FutureBuilder<List<TableModel>>(
          future: vm.fetchDataFromGoogleSheet(),
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
                controller: _scrollController,
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

class _ServingsDishes extends StatelessWidget {
  const _ServingsDishes({
    super.key,
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
              return ExpansionTile(
                initiallyExpanded: false,
                collapsedBackgroundColor: AppColor.previewBackgroundColor,
                textColor: AppColor.titleCardPreviewColor,
                maintainState: true,
                title: Text(
                  table.name,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
                children: [
                  _ListDishes(categories: table.categories),
                ],
              );
            }).toList(),
            const SizedBox(height: AppPadding.low),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                style: Theme.of(context).elevatedButtonTheme.style,
                onPressed: () => vm.addNewServing(),
                child: const Text(
                  'Добавить подачу',
                  style: TextStyle(
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
        color: AppColor.cardPreviewColor,
        shape: const CircularNotchedRectangle(),
        child: Row(
          children: [
            Consumer<PreOrderFormVm>(
              builder: (context, vm, child) {
                return Text("Сумма: ${vm.getTotalPrice()}");
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ListDishes extends StatelessWidget {
  const _ListDishes({
    super.key,
    required this.categories,
  });

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
    super.key,
  });
  final DishModel dish;
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PreOrderFormVm>(context);
    return ListTile(
      title: Text(dish.nameDish ?? ''),
      subtitle: Text('${dish.weight ?? ''}  ${dish.price ?? ''}₽'),
      trailing: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 70),
        child: CustomTextField(
          label: 'Кол-во',
          onChanged: (value) {
            int? count = int.tryParse(value);
            vm.updateDishCount(dish, count ?? 0);
          },
        ),
      ),
    );
  }
}
