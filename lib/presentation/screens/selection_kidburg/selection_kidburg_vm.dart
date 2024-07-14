import 'package:flutter/material.dart';
import 'package:kidburg_banquet/data/repository/shared_preferences_repository.dart';
import 'package:kidburg_banquet/domain/model/establishments_enum.dart';
import 'package:kidburg_banquet/domain/model/manager_model.dart';
import 'package:kidburg_banquet/presentation/navigation/app_route.dart';

class SelectionKidburgViewModel with ChangeNotifier {
  SelectionKidburgViewModel();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController establishmentController = TextEditingController();
  final TextEditingController phoneNumberOfManagerController =
      TextEditingController();

  void enterToHeaderFormScreen(BuildContext context) async {
    final managerModel = ManagerModel(
      name: nameController.text,
      phoneNumber: phoneNumberOfManagerController.text,
      establishmentEnum: selectEstablisment(),
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

  Future<void> loadCurrentManager() async {
    final managerModel =
        await SharedPreferencesRepository.instance.loadManagerInfo();
    if (managerModel != null) {
      nameController.text = managerModel.name;
      establishmentController.text = managerModel.establishmentEnum.name;
      phoneNumberOfManagerController.text = managerModel.phoneNumber;
    }
  }
}
