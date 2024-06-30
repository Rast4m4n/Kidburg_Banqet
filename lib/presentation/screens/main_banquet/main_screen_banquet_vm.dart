import 'package:flutter/material.dart';
import 'package:kidburg_banquet/domain/model/banqet_model.dart';
import 'package:kidburg_banquet/presentation/navigation/app_route.dart';
import 'package:kidburg_banquet/presentation/utils/date_time_formatter.dart';

class MainBanquetViewModel extends ChangeNotifier {
  MainBanquetViewModel({
    required this.nameController,
    required this.childrenController,
    required this.adultController,
    required this.placeEventController,
    required this.dateTimeManager,
    required this.dateController,
    required this.timeController,
  });
  final DateTimeManager dateTimeManager;
  final TextEditingController dateController;
  final TextEditingController timeController;
  final TextEditingController nameController;
  final TextEditingController placeEventController;
  final TextEditingController childrenController;
  final TextEditingController adultController;
  String formatterDate() => dateTimeManager.formatterDate;
  String formatterTime() => dateTimeManager.formatterTime;

  Future<void> showDate(BuildContext context) async {
    dateTimeManager.showDate(context, dateController);
    notifyListeners();
  }

  Future<void> showTime(BuildContext context) async {
    dateTimeManager.showTime(context, timeController);
    notifyListeners();
  }

  void routingToPreOrder(BuildContext context) {
    Navigator.of(context).pushNamed(
      AppRoute.preOrderFormPage,
      arguments: BanqetModel(
        nameClient: nameController.text,
        place: placeEventController.text,
        dateStart: dateTimeManager.selectedDate!,
        firstTimeServing: dateTimeManager.selectedTime!,
        secondTimeServing: DateTimeFormatter.calculateNextServingTime(
          dateTimeManager.selectedTime!,
        ),
        amountOfChildren: int.parse(childrenController.text),
        amountOfAdult: int.parse(adultController.text),
      ),
    );
  }
}

abstract class DateTimeManager {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  Future<void> showDate(
      BuildContext context, TextEditingController dateController);
  Future<void> showTime(
      BuildContext context, TextEditingController timeController);
  Widget hour24FormatBuilder(BuildContext context, Widget? child);
  String get formatterDate;
  String get formatterTime;
}

class DateTimeImpl implements DateTimeManager {
  @override
  DateTime? selectedDate;

  @override
  TimeOfDay? selectedTime;

  @override
  String get formatterDate =>
      "${selectedDate!.day}.${selectedDate!.month}.${selectedDate!.year}";

  @override
  String get formatterTime => "${selectedTime!.hour}:${selectedTime!.minute}";

  @override
  Widget hour24FormatBuilder(BuildContext context, Widget? child) {
    final mediaQueryData = MediaQuery.of(context);
    return MediaQuery(
      data: mediaQueryData.alwaysUse24HourFormat
          ? mediaQueryData
          : mediaQueryData.copyWith(alwaysUse24HourFormat: true),
      child: child!,
    );
  }

  @override
  Future<void> showDate(
      BuildContext context, TextEditingController dateController) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      dateController.text = formatterDate;
    }
  }

  @override
  Future<void> showTime(
      BuildContext context, TextEditingController timeController) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 10, minute: 50),
      builder: hour24FormatBuilder,
    );
    if (picked != null && picked != selectedTime) {
      selectedTime = picked;
      timeController.text = formatterTime;
    }
  }
}
