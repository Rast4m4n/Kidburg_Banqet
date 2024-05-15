import 'package:flutter/material.dart';
import 'package:kidburg_banquet/presentation/theme/app_paddings.dart';
import 'package:kidburg_banquet/presentation/theme/app_theme.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key,
      required this.controller,
      // required this.maxWidth,
      // required this.maxHeight,
      required this.label,
      this.onTap,
      this.suffixIcon});

  // final double maxWidth;
  // final double maxHeight;
  final TextEditingController controller;
  final String label;
  final VoidCallback? onTap;
  final Icon? suffixIcon;
  @override
  Widget build(BuildContext context) {
    final InputDecorationTheme textFieldTheme =
        Theme.of(context).inputDecorationTheme;
    return TextField(
      maxLines: null,
      minLines: null,
      expands: true,
      onTap: onTap,
      readOnly: onTap != null ? true : false,
      controller: controller,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        labelText: label,
        labelStyle: textFieldTheme.labelStyle,
        contentPadding: const EdgeInsets.only(
          left: AppPadding.low,
          bottom: AppPadding.low,
        ),
        enabledBorder: textFieldTheme.border,
        focusedBorder: textFieldTheme.focusedBorder,
        filled: true,
        fillColor: AppColor.textFieldColor,
        border: InputBorder.none,
      ),
    );
  }
}
