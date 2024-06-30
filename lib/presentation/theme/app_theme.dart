import 'package:flutter/material.dart';
import 'package:kidburg_banquet/presentation/theme/app_paddings.dart';

abstract class AppColor {
  static const Color tableForKids = Color(0xffAAE8A0);
  static const Color tableForAdult = Color(0xffBCCFFF);
  static const Color textFieldColor = Color(0xffF3F3F3);
  static const Color textFieldInsideColor = Color(0xff898989);
  static const Color cardPreviewColor = Colors.white;
  static const Color titleCardPreviewColor = Color(0xffBFAD09);
  static const Color infoCardPreviewColor = Color(0xff727272);
  static const Color previewBackgroundColor = Color(0xffE9E9E9);
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
      labelStyle: TextStyle(color: AppColor.textFieldInsideColor),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        shape: MaterialStateProperty.resolveWith(
          (states) => const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
        ),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          AppColor.cardPreviewColor,
        ),
        padding: const MaterialStatePropertyAll(
          EdgeInsets.all(AppPadding.extra),
        ),
        splashFactory: InkRipple.splashFactory,
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    ),
  );

  final ThemeData appThemeDark = ThemeData.dark().copyWith();
}
