import 'package:flutter/material.dart';
import 'package:kidburg_banquet/domain/model/establishments_enum.dart';
import 'package:kidburg_banquet/domain/model/language_enum.dart';
import 'package:kidburg_banquet/presentation/screens/selection_kidburg/selection_kidburg_vm.dart';
import 'package:kidburg_banquet/presentation/theme/app_paddings.dart';
import 'package:kidburg_banquet/presentation/theme/app_theme.dart';
import 'package:kidburg_banquet/presentation/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

class SelectionKidburScreen extends StatelessWidget {
  SelectionKidburScreen({super.key});

  final vm = SelectionKidburgViewModel();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'КидБург банкеты',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
      body: FutureBuilder(
        future: vm.loadCurrentManager(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(AppPadding.low),
              child: ChangeNotifierProvider<SelectionKidburgViewModel>(
                create: (context) => vm,
                child: Column(
                  spacing: AppPadding.low,
                  children: [
                    CustomTextField(
                      controller: vm.nameController,
                      label: 'Имя менеджера',
                    ),
                    CustomTextField(
                      controller: vm.phoneNumberOfManagerController,
                      label: 'Номер менеджера',
                    ),
                    const _EstablishmentsDropDownMenu(),
                    const _LanguageDropDownMenu(),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        style: Theme.of(context).elevatedButtonTheme.style,
                        onPressed: () async =>
                            vm.enterToHeaderFormScreen(context),
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
            );
          }
        },
      ),
    );
  }
}

class _EstablishmentsDropDownMenu extends StatelessWidget {
  const _EstablishmentsDropDownMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SelectionKidburgViewModel>();
    return DropdownMenu(
      expandedInsets: const EdgeInsets.all(0),
      inputDecorationTheme: const InputDecorationTheme(
        fillColor: AppColor.textFieldColor,
        filled: true,
        isCollapsed: true,
        contentPadding: EdgeInsets.all(AppPadding.low),
        constraints: BoxConstraints(maxHeight: 60),
      ),
      label: Text(
        'Точка кидбурга',
        style: Theme.of(context).inputDecorationTheme.labelStyle,
      ),
      controller: vm.establishmentController,
      dropdownMenuEntries:
          EstablishmentsEnum.values.map<DropdownMenuEntry<EstablishmentsEnum>>(
        (EstablishmentsEnum place) {
          return DropdownMenuEntry<EstablishmentsEnum>(
            value: place,
            label: place.name,
          );
        },
      ).toList(),
    );
  }
}

class _LanguageDropDownMenu extends StatelessWidget {
  const _LanguageDropDownMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SelectionKidburgViewModel>();
    return DropdownMenu(
      expandedInsets: const EdgeInsets.all(0),
      inputDecorationTheme: const InputDecorationTheme(
        fillColor: AppColor.textFieldColor,
        filled: true,
        isCollapsed: true,
        contentPadding: EdgeInsets.all(AppPadding.low),
        constraints: BoxConstraints(maxHeight: 60),
      ),
      label: Text(
        'Язык приложения',
        style: Theme.of(context).inputDecorationTheme.labelStyle,
      ),
      controller: vm.languageController,
      dropdownMenuEntries:
          LanguageEnum.values.map<DropdownMenuEntry<LanguageEnum>>(
        (LanguageEnum place) {
          return DropdownMenuEntry<LanguageEnum>(
            value: place,
            label: place.name,
          );
        },
      ).toList(),
    );
  }
}
