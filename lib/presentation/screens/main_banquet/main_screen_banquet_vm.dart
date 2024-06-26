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
  TimeOfDay? selectedTime;
  final TextEditingController nameController;
  final TextEditingController dateController;
  final TextEditingController placeEventController;
  final TextEditingController timeController;
  final TextEditingController childrenController;
  final TextEditingController adultController;

  String _formatterDate() =>
      "${selectedDate!.day}.${selectedDate!.month}.${selectedDate!.year}";
  String _formatterTime() => "${selectedTime!.hour}:${selectedTime!.minute}";

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

  Future<void> showTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 10, minute: 50),
      builder: _hour24FormatBuilder,
    );
    if (picked != null && picked != selectedTime) {
      selectedTime = picked;
      timeController.text = _formatterTime();
      notifyListeners();
    }
  }

  Widget _hour24FormatBuilder(BuildContext context, Widget? child) {
    final mediaQueryData = MediaQuery.of(context);

    return MediaQuery(
      data: mediaQueryData.alwaysUse24HourFormat
          ? mediaQueryData
          : mediaQueryData.copyWith(alwaysUse24HourFormat: true),
      child: child!,
    );
  }

  void routingToPreOrder(BuildContext context) {
    Navigator.of(context).pushNamed(
      AppRoute.preOrderFormPage,
      arguments: BanqetModel(
        nameClient: nameController.text,
        place: placeEventController.text,
        dateStart: selectedDate!,
        timeStart: selectedTime!,
        amountOfChildren: int.parse(childrenController.text),
        amountOfAdult: int.parse(adultController.text),
      ),
    );
  }
}
