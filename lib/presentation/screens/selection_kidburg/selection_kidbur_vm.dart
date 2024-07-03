import 'package:flutter/material.dart';
import 'package:kidburg_banquet/domain/model/establishments_enum.dart';
import 'package:kidburg_banquet/domain/model/manager_model.dart';
import 'package:kidburg_banquet/presentation/navigation/app_route.dart';

class SelectionKidburgViewModel with ChangeNotifier {
  SelectionKidburgViewModel({
    required this.nameController,
    required this.establishmentController,
    required this.phoneNumberOfManagerController,
  });

  final TextEditingController nameController;
  final TextEditingController establishmentController;
  final TextEditingController phoneNumberOfManagerController;

  void enterToHeaderFormScreen(BuildContext context) {
    try {
      Navigator.of(context).pushNamed(
        AppRoute.mainPage,
        arguments: ManagerModel(
          name: nameController.text,
          phoneNumber: phoneNumberOfManagerController.text,
          establishmentEnum: selectEstablisment(),
        ),
      );
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red.shade300,
          content: const Text('Выберите заведение'),
        ),
      );
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

  Future<void> saveManagerInfo() async {}

  Future<void> setManagerInfo() async {}
}
