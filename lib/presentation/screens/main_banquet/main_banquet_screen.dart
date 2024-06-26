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
  late final MainBanquetVM vm;

  @override
  void initState() {
    super.initState();
    vm = MainBanquetVM(
      nameController: TextEditingController(),
      timeController: TextEditingController(),
      dateController: TextEditingController(),
      placeEventController: TextEditingController(),
      childrenController: TextEditingController(),
      adultController: TextEditingController(),
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
    final vm = context.read<MainBanquetVM>();
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
          const _TextFieldDatePicker(),
          const _PlaceEventDropDownMenu(),
          CustomTextField(
            controller: vm.timeController,
            label: 'Время начало',
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
    final vm = context.read<MainBanquetVM>();
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

class _TextFieldDatePicker extends StatelessWidget {
  const _TextFieldDatePicker({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final MainBanquetVM vm = Provider.of<MainBanquetVM>(context);
    return CustomTextField(
      controller: vm.dateController,
      label: 'Дата проведения',
      onTap: () => vm.showDate(context),
    );
  }
}
