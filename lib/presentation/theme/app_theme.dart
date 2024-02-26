import 'package:flutter/material.dart';

abstract class AppColor {
  static const Color tableForKids = Color(0xffAAE8A0);
  static const Color tableForAdult = Color(0xffBCCFFF);
}

class AppTheme {
  final ThemeData appThemeLight = ThemeData.light().copyWith();

  final ThemeData appThemeDark = ThemeData.dark().copyWith();
}
