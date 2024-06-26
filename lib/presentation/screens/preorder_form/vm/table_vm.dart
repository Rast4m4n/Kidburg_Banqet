import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kidburg_banquet/domain/model/banqet_model.dart';
import 'package:kidburg_banquet/domain/model/table_model.dart';

class TableViewModel with ChangeNotifier {
  TableViewModel({
    required this.tableModel,
  });

  final TableModel tableModel;

  bool _isVisibleTable = true;

  ///Если index 0, то выведется время подачи на взрослый стол
  ///
  ///Если index 1, то выведется время подачи на детский стол
  String addTimeServing(BuildContext context, int indexTimeServing) {
    final args = ModalRoute.of(context)!.settings.arguments as BanqetModel;
    final firstTimeServing = args.firstTimeServing;
    final secondTimeServing = _calculateNextServingTime(firstTimeServing);
    return _convertToUTC24Format(
      indexTimeServing == 0 ? firstTimeServing : secondTimeServing,
    );
  }

  TimeOfDay _calculateNextServingTime(TimeOfDay timeOfDay) {
    int newHour = timeOfDay.hour + 1;
    int newMinute = timeOfDay.minute + 30;
    if (newMinute >= 60) {
      newHour += 1;
      newMinute = newMinute - 60;
    }
    return TimeOfDay(hour: newHour, minute: newMinute);
  }

  String _convertToUTC24Format(TimeOfDay timeOfDay) {
    final now = DateTime.now();
    final localDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      timeOfDay.hour,
      timeOfDay.minute,
      now.second,
    );
    return DateFormat.Hm().format(localDateTime);
  }

  bool get isVisibleTable => _isVisibleTable;

  void expandTable() {
    _isVisibleTable = !isVisibleTable;
    notifyListeners();
  }
}
