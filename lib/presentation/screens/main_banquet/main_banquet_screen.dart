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
      nameOfManagerController: TextEditingController(),
      phoneNumberOfManagerController: TextEditingController(),
      phoneNumberOfClientController: TextEditingController(),
      prepaymentController: TextEditingController(),
      cakeController: TextEditingController(),
      remarkController: TextEditingController(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                child: ElevatedButton(
                  style: Theme.of(context).elevatedButtonTheme.style,
                  onPressed: () => vm.routingToPreOrder(context),
                  child: const Text(
                    'Далее',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColor.infoCardPreviewColor,
                    ),
                  ),
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
    final vm = context.watch<MainBanquetViewModel>();
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: AppPadding.medium,
      childAspectRatio: 3.4,
      mainAxisSpacing: AppPadding.low,
      primary: false,
      shrinkWrap: true,
      children: [
        CustomTextField(
          controller: vm.nameOfManagerController,
          label: 'Имя менеджера',
        ),
        CustomTextField(
          controller: vm.phoneNumberOfManagerController,
          label: 'Номер менеджера',
        ),
        CustomTextField(
          controller: vm.nameController,
          label: 'Имя заказчика',
        ),
        CustomTextField(
          controller: vm.phoneNumberOfClientController,
          label: 'Номер заказчика',
        ),
        CustomTextField(
          label: 'Дата проведения',
          controller: vm.dateController,
          onTap: () => vm.showDate(context),
        ),
        CustomTextField(
          label: 'Время проведения',
          controller: vm.timeController,
          onTap: () => vm.showTime(context),
        ),
        const _PlaceEventDropDownMenu(),
        CustomTextField(
          controller: vm.prepaymentController,
          label: 'Предоплата',
        ),
        CustomTextField(
          controller: vm.childrenController,
          label: 'Дети',
        ),
        CustomTextField(
          controller: vm.adultController,
          label: 'Взрослые',
        ),
        CustomTextField(
          controller: vm.cakeController,
          label: 'Название торта',
        ),
        CustomTextField(
          controller: vm.remarkController,
          label: 'Примечание',
        ),
      ],
    );
  }
}

class _PlaceEventDropDownMenu extends StatelessWidget {
  const _PlaceEventDropDownMenu({
    super.key,
    this.errorString,
  });

  final String? errorString;
  @override
  Widget build(BuildContext context) {
    final vm = context.read<MainBanquetViewModel>();
    return DropdownMenu(
      errorText: errorString,
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
