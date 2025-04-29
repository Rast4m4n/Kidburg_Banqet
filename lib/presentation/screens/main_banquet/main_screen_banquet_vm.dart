import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kidburg_banquet/core/storage/i_data_storage.dart';
import 'package:kidburg_banquet/domain/model/banqet_model.dart';
import 'package:kidburg_banquet/domain/model/establishments_enum.dart';
import 'package:kidburg_banquet/domain/model/manager_model.dart';
import 'package:kidburg_banquet/domain/model/place_event_enum.dart';
import 'package:kidburg_banquet/generated/l10n.dart';
import 'package:kidburg_banquet/presentation/navigation/app_route.dart';

class MainBanquetViewModel {
  MainBanquetViewModel({
    required this.widgetState,
    required IDataStorage storage,
  }) : _storage = storage;

  final IDataStorage _storage;

  final State widgetState;
  BuildContext get _context => widgetState.context;

  final dateTimeManager = _DateTimeImpl();

  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final nameController = TextEditingController();
  final placeEventController = TextEditingController();
  final childrenController = TextEditingController();
  final adultController = TextEditingController();
  final phoneNumberOfClientController = TextEditingController();
  final prepaymentController = TextEditingController();
  final cakeController = TextEditingController();
  final remarkController = TextEditingController();

  ValueNotifier<List<DropdownMenuEntry<IPlaceEvent>>>
      dropDownMenuEntriesNotifier = ValueNotifier([]);
  ValueNotifier<String?> errorPlaceNotifier = ValueNotifier(null);

  final formKey = GlobalKey<FormState>();

  String? validatorName(String? value) {
    if (value == null || value.isEmpty) {
      return S.of(_context).requiredFiled;
    }
    return null;
  }

  String? validatorDate(String? value) {
    if (value == null || value.isEmpty) {
      return S.of(_context).requiredFiled;
    }
    return null;
  }

  String? validatorTime(String? value) {
    if (value == null || value.isEmpty) {
      return S.of(_context).requiredFiled;
    }
    return null;
  }

  String? validatePlace() {
    if (placeEventController.text.isEmpty) {
      return S.of(_context).requiredFiled;
    }
    return null;
  }

  bool validateForm() {
    final isValid = formKey.currentState!.validate();
    errorPlaceNotifier.value = validatePlace();
    return isValid && errorPlaceNotifier.value == null;
  }

  Future<void> showDate() async {
    await dateTimeManager.showDate(_context, dateController);
  }

  Future<void> showTime() async {
    await dateTimeManager.showTime(_context, timeController);
  }

  // Инициализация списка мест для выбора
  Future<void> _initDropDownEntriesPlacesEvent() async {
    final managerModel = await _storage.loadManagerInfo();
    if (managerModel == null) {
      dropDownMenuEntriesNotifier.value = [];
      return;
    }

    if (managerModel.establishmentEnum == EstablishmentsEnum.cdm) {
      dropDownMenuEntriesNotifier.value = PlaceEventCDMEnum.values
          .map((e) => DropdownMenuEntry(value: e, label: e.localizedName))
          .toList();
    } else if (managerModel.establishmentEnum == EstablishmentsEnum.riviera) {
      dropDownMenuEntriesNotifier.value = PlaceEventRivieraEnum.values
          .map((e) => DropdownMenuEntry(value: e, label: e.localizedName))
          .toList();
    }
  }

  // Переход на следующий экран с проверкой валидности формы и загрузкой данных менеджера
  void routingToPreOrder() async {
    if (!validateForm()) return;

    final managerModel = await _storage.loadManagerInfo();
    if (managerModel == null) return;

    if (!_context.mounted) return;
    final banquetModel = createBanquetModel(managerModel);

    Navigator.of(_context).pushNamed(
      AppRoute.preOrderFormPage,
      arguments: banquetModel,
    );
  }

  // Создание модели для передачи в следующий экран
  BanquetModel createBanquetModel(ManagerModel managerModel) => BanquetModel(
        managerModel: managerModel,
        nameClient: nameController.text,
        phoneNumberOfClient: phoneNumberOfClientController.text,
        prepayment: int.tryParse(prepaymentController.text),
        cake: cakeController.text,
        remark: remarkController.text,
        place: placeEventController.text,
        dateStart: dateTimeManager.selectedDate!,
        timeStart: dateTimeManager.selectedTime!,
        amountOfChildren: int.tryParse(childrenController.text),
        amountOfAdult: int.tryParse(adultController.text),
      );

  void init() {
    _initDropDownEntriesPlacesEvent();
  }

  void dispose() {
    dateController.dispose();
    timeController.dispose();
    nameController.dispose();
    placeEventController.dispose();
    childrenController.dispose();
    adultController.dispose();
    phoneNumberOfClientController.dispose();
    prepaymentController.dispose();
    cakeController.dispose();
    remarkController.dispose();
    dropDownMenuEntriesNotifier.dispose();
    errorPlaceNotifier.dispose();
  }
}

// Абстрактный класс для управления датой и временем
abstract class _DateTimeManager {
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

class _DateTimeImpl implements _DateTimeManager {
  @override
  DateTime? selectedDate;

  @override
  TimeOfDay? selectedTime;

  @override
  String get formatterDate => DateFormat('dd.MM.yy').format(selectedDate!);

  /// Форматирование времени в формате HH:mm
  ///
  /// 13:00
  @override
  String get formatterTime => DateFormat('HH:mm').format(
        DateTime.now().copyWith(
          hour: selectedTime!.hour,
          minute: selectedTime!.minute,
        ),
      );

  /// Показывает календарь для выбора даты
  @override
  Future<void> showDate(
    BuildContext context,
    TextEditingController dateController,
  ) async {
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

  /// Показывает время для выбора
  @override
  Future<void> showTime(
    BuildContext context,
    TextEditingController timeController,
  ) async {
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
