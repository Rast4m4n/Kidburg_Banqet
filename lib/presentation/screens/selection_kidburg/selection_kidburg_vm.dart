import 'package:flutter/material.dart';
import 'package:kidburg_banquet/core/di/di_scope_provider.dart';
import 'package:kidburg_banquet/domain/model/establishments_enum.dart';
import 'package:kidburg_banquet/domain/model/manager_model.dart';
import 'package:kidburg_banquet/presentation/navigation/app_route.dart';

class SelectionKidburgViewModel with ChangeNotifier {
  SelectionKidburgViewModel();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController establishmentController = TextEditingController();
  final TextEditingController phoneNumberOfManagerController =
      TextEditingController();
  final TextEditingController languageController = TextEditingController();

  void enterToHeaderFormScreen(BuildContext context) async {
    final managerModel = ManagerModel(
      name: nameController.text,
      phoneNumber: phoneNumberOfManagerController.text,
      establishmentEnum: selectEstablisment(),
      locale: selectLanguage(context),
    );

    await DiScopeProvider.of(context)!.storage.saveManagerInfo(managerModel);
    try {
      if (context.mounted) {
        Navigator.of(context).pushReplacementNamed(
          AppRoute.mainPage,
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red.shade300,
            content: const Text('Выберите заведение'),
          ),
        );
      }
    }
  }

  EstablishmentsEnum selectEstablisment() {
    switch (establishmentController.text) {
      case 'ЦДМ':
        establishmentController.text = 'ЦДМ';
        return EstablishmentsEnum.cdm;
      case 'Ривьера':
        establishmentController.text = 'ривьера';
        return EstablishmentsEnum.riviera;
      default:
        throw Exception('No establishment selected');
    }
  }

  Locale selectLanguage(BuildContext context) {
    final locale = Localizations.localeOf(context);
    switch (languageController.text) {
      case 'Руссикй':
        languageController.text = 'Русский';
        return const Locale('ru');
      case 'Английский':
        languageController.text = 'Английский';
        return const Locale('en');
      default:
        return locale.toLanguageTag() == "ru"
            ? const Locale('ru')
            : const Locale('en');
    }
  }

  Future<void> loadCurrentManager(BuildContext context) async {
    final di = DiScopeProvider.of(context)!.storage;
    final managerModel = await di.loadManagerInfo();
    if (managerModel != null) {
      nameController.text = managerModel.name;
      establishmentController.text = managerModel.establishmentEnum.name;
      phoneNumberOfManagerController.text = managerModel.phoneNumber;
      languageController.text = managerModel.locale.toLanguageTag() == "ru"
          ? 'Русский'
          : 'Английский';
    }
  }
}
