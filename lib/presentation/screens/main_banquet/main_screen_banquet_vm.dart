import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kidburg_banquet/domain/model/banqet_model.dart';
import 'package:kidburg_banquet/domain/model/establishments_enum.dart';
import 'package:kidburg_banquet/domain/model/manager_model.dart';
import 'package:kidburg_banquet/domain/model/place_event_enum.dart';
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
    required this.phoneNumberOfClientController,
    required this.prepaymentController,
    required this.cakeController,
    required this.remarkController,
  });
  final DateTimeManager dateTimeManager;
  final TextEditingController dateController;
  final TextEditingController timeController;
  final TextEditingController nameController;
  final TextEditingController placeEventController;
  final TextEditingController childrenController;
  final TextEditingController adultController;
  final TextEditingController phoneNumberOfClientController;
  final TextEditingController prepaymentController;
  final TextEditingController cakeController;
  final TextEditingController remarkController;
  List<dynamic> dropDownMenuEntries = [];

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

  void initDropDownEntriesPlacesEvent(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ManagerModel;
    if (args.establishmentEnum == EstablishmentsEnum.cdm) {
      dropDownMenuEntries = PlaceEventCDMEnum.values;
    } else if (args.establishmentEnum == EstablishmentsEnum.riviera) {
      dropDownMenuEntries = PlaceEventRivieraEnum.values;
    }
  }

  void routingToPreOrder(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ManagerModel;
    Navigator.of(context).pushNamed(
      AppRoute.preOrderFormPage,
      arguments: BanqetModel(
        nameOfManager: args.name,
        phoneNumberOfManager: args.phoneNumber,
        nameClient: nameController.text,
        phoneNumberOfClient: phoneNumberOfClientController.text,
        prepayment: int.tryParse(prepaymentController.text),
        cake: cakeController.text,
        remark: remarkController.text,
        place: placeEventController.text,
        dateStart: dateTimeManager.selectedDate!,
        firstTimeServing: dateTimeManager.selectedTime!,
        secondTimeServing: DateTimeFormatter.calculateNextServingTime(
          dateTimeManager.selectedTime!,
        ),
        amountOfChildren: int.tryParse(childrenController.text),
        amountOfAdult: int.tryParse(adultController.text),
      ),
    );
  }
}

abstract class DateTimeManager {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  Future<void> showDate(
    BuildContext context,
    TextEditingController dateController,
  );
  Future<void> showTime(
    BuildContext context,
    TextEditingController timeController,
  );
  String get formatterDate;
  String get formatterTime;
}

class DateTimeImpl implements DateTimeManager {
  @override
  DateTime? selectedDate;

  @override
  TimeOfDay? selectedTime;

  @override
  String get formatterDate => DateFormat('dd.MM.yy').format(selectedDate!);

  @override
  String get formatterTime => DateFormat('HH:mm').format(
        DateTime.now().copyWith(
          hour: selectedTime!.hour,
          minute: selectedTime!.minute,
        ),
      );

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
    );
    if (picked != null && picked != selectedTime) {
      selectedTime = picked;
      timeController.text = formatterTime;
    }
  }
}
