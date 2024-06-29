import 'package:flutter/material.dart';
import 'package:kidburg_banquet/domain/model/banqet_model.dart';
import 'package:kidburg_banquet/domain/model/table_model.dart';
import 'package:kidburg_banquet/presentation/screens/preview_banqet.dart/preview_banquet_vm.dart';
import 'package:kidburg_banquet/presentation/theme/app_paddings.dart';
import 'package:kidburg_banquet/presentation/theme/app_theme.dart';
import 'package:provider/provider.dart';

class PreviewBanqetScreen extends StatefulWidget {
  const PreviewBanqetScreen({super.key});

  @override
  State<PreviewBanqetScreen> createState() => _PreviewBanqetScreenState();
}

class _PreviewBanqetScreenState extends State<PreviewBanqetScreen> {
  late final PreviewBanquerViewModel vm;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as BanqetModel;
    vm = PreviewBanquerViewModel(banqetModel: args);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => vm,
      child: Scaffold(
        appBar: AppBar(
          forceMaterialTransparency: true,
        ),
        backgroundColor: AppColor.previewBackgroundColor,
        body: Padding(
          padding: const EdgeInsets.all(AppPadding.big),
          child: ListView(
            shrinkWrap: true,
            children: [
              Center(
                child: Text(
                  'Кидбург банкеты',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              ),
              const SizedBox(height: AppPadding.extra),
              const _EventCardWidget(),
              const SizedBox(height: AppPadding.extra),
              const _ListCardsServingWidget(),
              ElevatedButton(
                style: Theme.of(context).elevatedButtonTheme.style,
                onPressed: () {
                  vm.saveBanquetExcelFile();
                  // vm.showShackBarInfoDirectory(context);
                },
                child: const Text('Сохранить'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EventCardWidget extends StatelessWidget {
  const _EventCardWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<PreviewBanquerViewModel>(
      builder: (context, vm, child) {
        return DecoratedBox(
          decoration: const BoxDecoration(
            color: AppColor.cardPreviewColor,
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppPadding.extra,
              vertical: 32,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'МЕРОПРИЯТИЕ',
                      style:
                          Theme.of(context).textTheme.headlineLarge?.copyWith(
                                color: AppColor.titleCardPreviewColor,
                                fontSize: 24,
                              ),
                    ),
                  ],
                ),
                const SizedBox(height: AppPadding.low),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Имя: ${vm.banqetModel.nameClient}',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppColor.titleCardPreviewColor,
                            fontSize: 16,
                          ),
                    ),
                    Text(
                      'Дата: ${vm.banqetModel.dateStart.day}.${vm.banqetModel.dateStart.month}.${vm.banqetModel.dateStart.year}',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppColor.titleCardPreviewColor,
                            fontSize: 16,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: AppPadding.low),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Домик: ${vm.banqetModel.place}',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppColor.infoCardPreviewColor,
                            fontSize: 14,
                          ),
                    ),
                    Text(
                      'Время: ${vm.banqetModel.firstTimeServing.format(context)}',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppColor.infoCardPreviewColor,
                            fontSize: 14,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: AppPadding.low),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Детей: ${vm.banqetModel.amountOfChildren}',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppColor.infoCardPreviewColor,
                            fontSize: 14,
                          ),
                    ),
                    Text(
                      'Взрослых: ${vm.banqetModel.amountOfAdult}',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppColor.infoCardPreviewColor,
                            fontSize: 14,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ListCardsServingWidget extends StatelessWidget {
  const _ListCardsServingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PreviewBanquerViewModel>(
      builder: (context, vm, child) {
        final tables = vm.banqetModel.tables;
        return Column(
          children: tables!.map(
            (table) {
              return Column(
                children: [
                  _ServingDishesCardWidget(table: table),
                  const SizedBox(height: AppPadding.extra),
                ],
              );
            },
          ).toList(),
        );
      },
    );
  }
}

class _ServingDishesCardWidget extends StatelessWidget {
  const _ServingDishesCardWidget({
    super.key,
    required this.table,
  });
  final TableModel table;
  @override
  Widget build(BuildContext context) {
    return Consumer<PreviewBanquerViewModel>(
      builder: (context, vm, child) {
        final dishes = vm.spreadList(table);
        return DecoratedBox(
          decoration: const BoxDecoration(
            color: AppColor.cardPreviewColor,
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppPadding.extra,
                  vertical: 32,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          table.name,
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge
                              ?.copyWith(
                                color: AppColor.titleCardPreviewColor,
                                fontSize: 24,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppPadding.low),
                    ...dishes.map(
                      (dish) {
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ConstrainedBox(
                                  constraints:
                                      const BoxConstraints(maxWidth: 150),
                                  child: Text(
                                    dish.nameDish!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                          color: AppColor.infoCardPreviewColor,
                                          fontSize: 14,
                                        ),
                                  ),
                                ),
                                Text(
                                  '${dish.count}шт',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        color: AppColor.infoCardPreviewColor,
                                        fontSize: 14,
                                      ),
                                ),
                              ],
                            ),
                            const Divider(),
                          ],
                        );
                      },
                    ).toList(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
