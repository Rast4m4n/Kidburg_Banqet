import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kidburg_banquet/domain/model/banqet_model.dart';
import 'package:kidburg_banquet/domain/model/table_model.dart';
import 'package:kidburg_banquet/presentation/screens/preview_banqet.dart/preview_banquet_vm.dart';
import 'package:kidburg_banquet/presentation/theme/app_paddings.dart';
import 'package:kidburg_banquet/presentation/theme/app_theme.dart';
import 'package:kidburg_banquet/presentation/widgets/custom_drawer.dart';
import 'package:provider/provider.dart';

class PreviewBanqetScreen extends StatefulWidget {
  const PreviewBanqetScreen({super.key});

  @override
  State<PreviewBanqetScreen> createState() => _PreviewBanqetScreenState();
}

class _PreviewBanqetScreenState extends State<PreviewBanqetScreen> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as BanquetModel;
    return ChangeNotifierProvider(
      create: (context) => PreviewBanquerViewModel(banqetModel: args),
      child: Scaffold(
        endDrawer: const CustomDrawer(),
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
                  'КидБург банкеты',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              ),
              const SizedBox(height: AppPadding.extra),
              const _EventCardWidget(),
              const SizedBox(height: AppPadding.extra),
              const _ListCardsServingWidget(),
              const _SaveButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final vm = context.read<PreviewBanquerViewModel>();
    return ElevatedButton(
      style: Theme.of(context).elevatedButtonTheme.style,
      onPressed: () async {
        await vm.saveBanquetExcelFile(context);
      },
      child: const Text(
        'Сохранить',
        style: TextStyle(
          fontSize: 16,
          color: AppColor.infoCardPreviewColor,
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
                Center(
                  child: Text(
                    'МЕРОПРИЯТИЕ',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: AppColor.titleCardPreviewColor,
                          fontSize: 24,
                        ),
                  ),
                ),
                const SizedBox(height: AppPadding.low),
                _RowInfoWidget(
                  text: 'Заказчик: ${vm.banqetModel.nameClient}',
                  twoText:
                      "Дата: ${DateFormat('dd.MM.yy').format(vm.banqetModel.dateStart)}",
                  fontSize: 16,
                  isTitle: true,
                ),
                const SizedBox(height: AppPadding.low),
                _RowInfoWidget(
                  text: 'Домик: ${vm.banqetModel.place}',
                  twoText: 'Время: ${vm.banqetModel.timeStart.format(context)}',
                  fontSize: 14,
                ),
                const SizedBox(height: AppPadding.low),
                _RowInfoWidget(
                  text: 'Детей: ${vm.banqetModel.amountOfChildren ?? ''}',
                  twoText: 'Взрослых: ${vm.banqetModel.amountOfAdult ?? ''}',
                  fontSize: 14,
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
                    Center(
                      child: Text(
                        table.name,
                        style:
                            Theme.of(context).textTheme.headlineLarge?.copyWith(
                                  color: AppColor.titleCardPreviewColor,
                                  fontSize: 24,
                                ),
                      ),
                    ),
                    const SizedBox(height: AppPadding.low),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: dishes.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            _RowInfoWidget(
                              text: dishes[index].nameDish!,
                              twoText: "${dishes[index].count}шт",
                              fontSize: 14,
                              crossAxisAlignment: CrossAxisAlignment.center,
                            ),
                            const Divider(),
                          ],
                        );
                      },
                    ),
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

class _RowInfoWidget extends StatelessWidget {
  const _RowInfoWidget({
    super.key,
    required this.text,
    required this.twoText,
    required this.fontSize,
    this.isTitle = false,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });
  final String text;
  final String twoText;
  final double fontSize;
  final bool isTitle;
  final CrossAxisAlignment crossAxisAlignment;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: crossAxisAlignment,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 150),
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: isTitle
                      ? AppColor.titleCardPreviewColor
                      : AppColor.infoCardPreviewColor,
                  fontSize: fontSize,
                ),
          ),
        ),
        Text(
          twoText,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: isTitle
                    ? AppColor.titleCardPreviewColor
                    : AppColor.infoCardPreviewColor,
                fontSize: fontSize,
              ),
        ),
      ],
    );
  }
}
