import 'package:flutter/material.dart';

abstract class AppColor {
  static const Color tableForKids = Color(0xffAAE8A0);
  static const Color tableForAdult = Color(0xffBCCFFF);
  static const Color textFieldColor = Color(0xffF3F3F3);
  static const Color textFieldInsideColor = Color(0xff898989);
}

class AppTheme {
  final ThemeData appThemeLight = ThemeData.light().copyWith(
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      hintStyle: TextStyle(color: AppColor.textFieldInsideColor),
    ),
  );

  final ThemeData appThemeDark = ThemeData.dark().copyWith();
}
