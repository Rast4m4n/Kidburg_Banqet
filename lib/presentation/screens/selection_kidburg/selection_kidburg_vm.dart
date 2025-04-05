import 'package:flutter/material.dart';
import 'package:kidburg_banquet/data/repository/shared_preferences_repository.dart';
import 'package:kidburg_banquet/domain/model/establishments_enum.dart';
import 'package:kidburg_banquet/domain/model/language_enum.dart';
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
      languageEnum: selectLanguage(context),
    );

    await SharedPreferencesRepository.instance.saveManagerInfo(managerModel);
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

  LanguageEnum selectLanguage(BuildContext context) {
    final locale = Localizations.localeOf(context);
    switch (languageController.text) {
      case 'Руссикй':
        languageController.text = 'Русский';
        return LanguageEnum.russian;
      case 'Английский':
        languageController.text = 'Английский';
        return LanguageEnum.english;
      default:
        return locale.toLanguageTag() == "ru"
            ? LanguageEnum.russian
            : LanguageEnum.english;
    }
  }

  Future<void> loadCurrentManager() async {
    final managerModel =
        await SharedPreferencesRepository.instance.loadManagerInfo();
    if (managerModel != null) {
      nameController.text = managerModel.name;
      establishmentController.text = managerModel.establishmentEnum.name;
      phoneNumberOfManagerController.text = managerModel.phoneNumber;
      languageController.text = managerModel.languageEnum.name;
    }
  }
}
