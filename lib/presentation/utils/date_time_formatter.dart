import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

abstract class DateTimeFormatter {
  ///Переводит 12 часовой формат AM/PM на 24 формат
  static String convertToHHMMString(TimeOfDay timeOfDay) {
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
