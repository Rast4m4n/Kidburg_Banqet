import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kidburg_banquet/domain/model/banqet_model.dart';

abstract class DateTimeFormatter {
  ///Если index 0, то выведется время подачи на взрослый стол
  ///
  ///Если index 1, то выведется время подачи на детский стол
  static String addTimeServing(BuildContext context, int indexTimeServing) {
    final args = ModalRoute.of(context)!.settings.arguments as BanqetModel;
    final firstTimeServing = args.firstTimeServing;
    final secondTimeServing = calculateNextServingTime(firstTimeServing);
    return convertToUTC24StringFormat(
      indexTimeServing == 0 ? firstTimeServing : secondTimeServing,
    );
  }

  ///Прибавляет +1.5 часа к следующей подаче
  static TimeOfDay calculateNextServingTime(TimeOfDay timeOfDay) {
    int newHour = timeOfDay.hour + 1;
    int newMinute = timeOfDay.minute + 30;
    if (newMinute >= 60) {
      newHour += 1;
      newMinute = newMinute - 60;
    }
    return TimeOfDay(hour: newHour, minute: newMinute);
  }

  ///Переводит 12 часовой формат AM/PM на 24 формат
  static String convertToUTC24StringFormat(TimeOfDay timeOfDay) {
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
}
