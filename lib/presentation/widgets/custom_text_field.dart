import 'package:flutter/material.dart';
import 'package:kidburg_banquet/presentation/theme/app_paddings.dart';
import 'package:kidburg_banquet/presentation/theme/app_theme.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    // required this.maxWidth,
    // required this.maxHeight,
    required this.label,
    this.controller,
    this.onTap,
    this.suffixIcon,
    this.onChanged,
  });

  // final double maxWidth;
  // final double maxHeight;
  final TextEditingController? controller;
  final String label;
  final VoidCallback? onTap;
  final Icon? suffixIcon;
  final Function(String)? onChanged;
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
      onChanged: (value) => onChanged!(value),
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
