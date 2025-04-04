import 'package:flutter/material.dart';
import 'package:kidburg_banquet/presentation/screens/main_banquet/main_screen_banquet_vm.dart';
import 'package:kidburg_banquet/presentation/theme/app_paddings.dart';
import 'package:kidburg_banquet/presentation/theme/app_theme.dart';
import 'package:kidburg_banquet/presentation/widgets/custom_drawer.dart';
import 'package:kidburg_banquet/presentation/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

class MainBanquetScreen extends StatefulWidget {
  const MainBanquetScreen({super.key});

  @override
  State<MainBanquetScreen> createState() => _MainBanquetScreenState();
}

class _MainBanquetScreenState extends State<MainBanquetScreen> {
  final MainBanquetViewModel vm = MainBanquetViewModel(
    nameController: TextEditingController(),
    placeEventController: TextEditingController(),
    childrenController: TextEditingController(),
    adultController: TextEditingController(),
    dateTimeManager: DateTimeImpl(),
    timeController: TextEditingController(),
    dateController: TextEditingController(),
    phoneNumberOfClientController: TextEditingController(),
    prepaymentController: TextEditingController(),
    cakeController: TextEditingController(),
    remarkController: TextEditingController(),
  );

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      endDrawer: const CustomDrawer(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Банкеты',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
      body: ChangeNotifierProvider(
        create: (context) => vm,
        child: FutureBuilder(
          future: vm.initDropDownEntriesPlacesEvent(),
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.all(AppPadding.low),
                child: Column(
                  children: [
                    const _GridActionFields(),
                    const SizedBox(height: AppPadding.low),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        style: Theme.of(context).elevatedButtonTheme.style,
                        onPressed: () {
                          vm.routingToPreOrder(context);
                        },
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
              );
            }
          },
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
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        CustomTextField(
          controller: vm.nameController,
          label: 'Имя заказчика',
          errorText: vm.errorName,
        ),
        CustomTextField(
          controller: vm.phoneNumberOfClientController,
          label: 'Номер заказчика',
        ),
        CustomTextField(
          label: 'Дата проведения',
          controller: vm.dateController,
          onTap: () => vm.showDate(context),
          errorText: vm.errorDate,
        ),
        CustomTextField(
          label: 'Время проведения',
          controller: vm.timeController,
          onTap: () => vm.showTime(context),
          errorText: vm.errorTime,
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
  });

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MainBanquetViewModel>();
    return DropdownMenu(
      expandedInsets: const EdgeInsets.all(0),
      inputDecorationTheme: InputDecorationTheme(
        floatingLabelBehavior: vm.errorPlace != null
            ? FloatingLabelBehavior.always
            : FloatingLabelBehavior.auto,
        hintStyle: TextStyle(
          color: Colors.red[200],
          fontSize: 12,
        ),
        fillColor: AppColor.textFieldColor,
        filled: true,
        isCollapsed: true,
        contentPadding: const EdgeInsets.all(AppPadding.low),
        constraints: const BoxConstraints(maxHeight: 48),
      ),
      label: Text(
        'Место проведения',
        style: Theme.of(context).inputDecorationTheme.labelStyle,
      ),
      hintText: vm.errorPlace,
      controller: vm.placeEventController,
      dropdownMenuEntries: vm.dropDownMenuEntries.map<DropdownMenuEntry>(
        (place) {
          return DropdownMenuEntry(
            value: place,
            label: place.name,
          );
        },
      ).toList(),
    );
  }
}
