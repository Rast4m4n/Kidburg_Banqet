import 'package:flutter/material.dart';
import 'package:kidburg_banquet/domain/model/place_event_enum.dart';
import 'package:kidburg_banquet/presentation/screens/main_banquet/main_screen_banquet_vm.dart';
import 'package:kidburg_banquet/presentation/theme/app_paddings.dart';
import 'package:kidburg_banquet/presentation/theme/app_theme.dart';
import 'package:kidburg_banquet/presentation/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

class MainBanquetScreen extends StatelessWidget {
  MainBanquetScreen({super.key});

  final CreateBanquetVM vm = CreateBanquetVM();

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
            controller: TextEditingController(),
            label: 'Имя заказчика',
          ),
          const _TextFieldDatePicker(),
          const _PlaceEventDropDownMenu(),
          CustomTextField(
            controller: TextEditingController(),
            label: 'Время начало',
          ),
          CustomTextField(
            controller: TextEditingController(),
            label: 'Дети',
          ),
          CustomTextField(
            controller: TextEditingController(),
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
    final CreateBanquetVM vm = Provider.of<CreateBanquetVM>(context);
    final String? isPickedDate = vm.selectedDate != null
        ? "${vm.selectedDate!.day}.${vm.selectedDate!.month}.${vm.selectedDate!.year}"
        : null;

    return CustomTextField(
      controller: TextEditingController(text: isPickedDate),
      label: 'Дата проведения',
      onTap: () => vm.showDate(context),
    );
  }
}
