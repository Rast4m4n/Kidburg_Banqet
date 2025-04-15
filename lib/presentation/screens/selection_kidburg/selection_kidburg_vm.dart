import 'package:flutter/material.dart';
import 'package:kidburg_banquet/core/di/i_di_scope.dart';
import 'package:kidburg_banquet/data/file_manager/file_manager.dart';
import 'package:kidburg_banquet/domain/model/establishments_enum.dart';
import 'package:kidburg_banquet/domain/model/manager_model.dart';
import 'package:kidburg_banquet/generated/l10n.dart';
import 'package:kidburg_banquet/presentation/navigation/app_route.dart';
import 'package:provider/provider.dart';

// class LocaleViewModel with ChangeNotifier {
//   // Присваивается локализация по умолчанию
//   // в зависимости от локализации системы
//   Locale locale = WidgetsBinding.instance.platformDispatcher.locale;

//   Future<void> initLocale(BuildContext context) async {
//     final savedLocale =
//         (await DiScopeProvider.of(context)!.storage.loadManagerInfo())!.locale;
//     locale = savedLocale;
//   }

//   /// если прописать notifyListener(), то перерисуется App
//   /// так как там прослушиваются изменения LocaleViewModel,
//   /// и не успеет пройти переход на другую страницу
//   /// с помощью метода enterToMainScreen()
//   Locale selectLanguage(BuildContext context, String text) {
//     switch (text) {
//       case 'Русский' || 'Russian':
//         locale = const Locale('ru');
//         return locale;
//       case 'Английский' || 'English':
//         locale = const Locale('en');
//         return locale;
//       default:
//         locale = locale.languageCode == "ru"
//             ? const Locale('ru')
//             : const Locale('en');
//         return locale;
//     }
//   }
// }

class SelectionKidburgViewModel with ChangeNotifier {
  SelectionKidburgViewModel();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController establishmentController = TextEditingController();
  final TextEditingController phoneNumberOfManagerController =
      TextEditingController();
  final TextEditingController languageController = TextEditingController();

  void enterToMainScreen(
    BuildContext context,
  ) async {
    final managerModel = ManagerModel(
      name: nameController.text,
      phoneNumber: phoneNumberOfManagerController.text,
      establishmentEnum: selectEstablisment(context),
      locale: selectLanguage(context),
    );
    final storage = context.read<IDiScope>().storage;
    await storage.removeCache();
    await storage.saveManagerInfo(managerModel);
    if (context.mounted) {
      context.read<IDiScope>().locale.updateLocale(selectLanguage(context));
    }
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
            content: Text(S.of(context).selectEstablishment),
          ),
        );
      }
    }
  }

  Locale selectLanguage(BuildContext context) {
    Locale locale = Localizations.localeOf(context);
    switch (languageController.text) {
      case 'Русский' || 'Russian':
        locale = const Locale('ru');
        return locale;
      case 'Английский' || 'English':
        locale = const Locale('en');
        return locale;
      default:
        locale = locale.languageCode == "ru"
            ? const Locale('ru')
            : const Locale('en');
        return locale;
    }
  }

  Future<void> confirmChangeLanguage() async {
    if (FileManager.directory.existsSync()) {
      await FileManager.directory.delete(recursive: true);
    }
  }

  EstablishmentsEnum selectEstablisment(BuildContext context) {
    switch (establishmentController.text) {
      case 'ЦДМ' || 'CDM':
        establishmentController.text = S.of(context).cdm;
        return EstablishmentsEnum.cdm;
      case 'Ривьера' || 'Riviera':
        establishmentController.text = S.of(context).riviera;
        return EstablishmentsEnum.riviera;
      default:
        throw Exception('No establishment selected');
    }
  }

  Future<void> loadCurrentManager(BuildContext context) async {
    final di = context.read<IDiScope>().storage;
    final managerModel = await di.loadManagerInfo();
    if (managerModel != null) {
      nameController.text = managerModel.name;
      establishmentController.text =
          managerModel.establishmentEnum.localizedName;
      phoneNumberOfManagerController.text = managerModel.phoneNumber;
      if (context.mounted) {
        languageController.text = managerModel.locale.toLanguageTag() == "ru"
            ? S.of(context).russian
            : S.of(context).english;
      }
    }
  }
}
