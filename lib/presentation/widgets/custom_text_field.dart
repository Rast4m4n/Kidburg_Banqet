import 'package:flutter/material.dart';
import 'package:kidburg_banquet/presentation/theme/app_paddings.dart';
import 'package:kidburg_banquet/presentation/theme/app_theme.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.label,
    this.controller,
    this.onTap,
    this.suffixIcon,
    this.onChanged,
    this.textAlign,
    this.maxLines,
    this.minLines,
    this.floatingLabelAlignment,
    this.errorString,
  });

  final TextEditingController? controller;
  final String label;
  final VoidCallback? onTap;
  final Icon? suffixIcon;
  final Function(String)? onChanged;
  final TextAlign? textAlign;
  final int? maxLines;
  final int? minLines;
  final FloatingLabelAlignment? floatingLabelAlignment;
  final String? errorString;
  @override
  Widget build(BuildContext context) {
    final InputDecorationTheme textFieldTheme =
        Theme.of(context).inputDecorationTheme;
    return TextField(
      maxLines: maxLines,
      minLines: minLines,
      expands: true,
      onTap: onTap,
      textAlign: textAlign ?? TextAlign.start,
      readOnly: onTap != null ? true : false,
      onChanged: onChanged,
      controller: controller,
      decoration: InputDecoration(
        errorText: errorString,
        floatingLabelAlignment: floatingLabelAlignment,
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
