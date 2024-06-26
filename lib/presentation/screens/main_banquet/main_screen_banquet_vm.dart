import 'package:flutter/material.dart';
import 'package:kidburg_banquet/domain/model/banqet_model.dart';
import 'package:kidburg_banquet/presentation/navigation/app_route.dart';

class MainBanquetVM extends ChangeNotifier {
  MainBanquetVM({
    required this.nameController,
    required this.dateController,
    required this.childrenController,
    required this.adultController,
    required this.timeController,
    required this.placeEventController,
  });
  DateTime? selectedDate;
  final TextEditingController nameController;
  final TextEditingController dateController;
  final TextEditingController placeEventController;
  final TextEditingController timeController;
  final TextEditingController childrenController;
  final TextEditingController adultController;

  String _formatterDate() =>
      "${selectedDate!.day}.${selectedDate!.month}.${selectedDate!.year}";

  Future<void> showDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      dateController.text = _formatterDate();
      notifyListeners();
    }
  }

  void routingToPreOrder(BuildContext context) {
    Navigator.of(context).pushNamed(
      AppRoute.preOrderFormPage,
      arguments: BanqetModel(
        nameClient: nameController.text,
        place: placeEventController.text,
        dateStart: dateController.text,
        timeStart: timeController.text,
        amountOfChildren: int.parse(childrenController.text),
        amountOfAdult: int.parse(adultController.text),
      ),
    );
  }
}
