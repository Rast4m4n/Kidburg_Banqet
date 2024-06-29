import 'package:flutter/material.dart';
import 'package:kidburg_banquet/domain/model/place_event_enum.dart';
import 'package:kidburg_banquet/presentation/screens/main_banquet/main_screen_banquet_vm.dart';
import 'package:kidburg_banquet/presentation/theme/app_paddings.dart';
import 'package:kidburg_banquet/presentation/theme/app_theme.dart';
import 'package:kidburg_banquet/presentation/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

class MainBanquetScreen extends StatefulWidget {
  const MainBanquetScreen({super.key});

  @override
  State<MainBanquetScreen> createState() => _MainBanquetScreenState();
}

class _MainBanquetScreenState extends State<MainBanquetScreen> {
  late final MainBanquetViewModel vm;

  @override
  void initState() {
    super.initState();
    vm = MainBanquetViewModel(
      nameController: TextEditingController(),
      placeEventController: TextEditingController(),
      childrenController: TextEditingController(),
      adultController: TextEditingController(),
      dateTimeManager: DateTimeImpl(),
      timeController: TextEditingController(),
      dateController: TextEditingController(),
    );
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
          child: Column(
            children: [
              const _GridActionFields(),
              const SizedBox(height: AppPadding.low),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: FilledButton(
                  onPressed: () => vm.routingToPreOrder(context),
                  child: const Text('Далее'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GridActionFields extends StatelessWidget {
  const _GridActionFields({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final vm = context.read<MainBanquetViewModel>();
    return SizedBox(
      height: 190,
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: AppPadding.medium,
        childAspectRatio: 3.4,
        mainAxisSpacing: AppPadding.low,
        primary: false,
        children: [
          CustomTextField(
            controller: vm.nameController,
            label: 'Имя заказчика',
          ),
          _TextFieldPicker(
            name: 'Дата проведения',
            controller: vm.dateController,
            onTap: () => vm.showDate(context),
          ),
          const _PlaceEventDropDownMenu(),
          _TextFieldPicker(
            name: 'Время проведения',
            controller: vm.timeController,
            onTap: () => vm.showTime(context),
          ),
          CustomTextField(
            controller: vm.childrenController,
            label: 'Дети',
          ),
          CustomTextField(
            controller: vm.adultController,
            label: 'Взрослые',
          ),
        ],
      ),
    );
  }
}

class _PlaceEventDropDownMenu extends StatelessWidget {
  const _PlaceEventDropDownMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final vm = context.read<MainBanquetViewModel>();
    return DropdownMenu(
      expandedInsets: const EdgeInsets.all(0),
      inputDecorationTheme: const InputDecorationTheme(
        fillColor: AppColor.textFieldColor,
        filled: true,
        isCollapsed: true,
        contentPadding: EdgeInsets.all(AppPadding.low),
        constraints: BoxConstraints(maxHeight: 48),
      ),
      label: Text(
        'Место проведения',
        style: Theme.of(context).inputDecorationTheme.labelStyle,
      ),
      controller: vm.placeEventController,
      dropdownMenuEntries:
          PlaceEventEnum.values.map<DropdownMenuEntry<PlaceEventEnum>>(
        (PlaceEventEnum place) {
          return DropdownMenuEntry<PlaceEventEnum>(
            value: place,
            label: place.name,
          );
        },
      ).toList(),
    );
  }
}

class _TextFieldPicker extends StatelessWidget {
  const _TextFieldPicker({
    super.key,
    required this.controller,
    required this.name,
    required this.onTap,
  });
  final TextEditingController controller;
  final String name;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      label: name,
      onTap: onTap,
    );
  }
}
