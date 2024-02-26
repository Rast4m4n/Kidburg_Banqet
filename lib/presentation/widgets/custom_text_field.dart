import 'package:flutter/material.dart';
import 'package:kidburg_banquet/presentation/theme/app_paddings.dart';
import 'package:kidburg_banquet/presentation/theme/app_theme.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    required this.maxWidth,
    required this.maxHeight,
    required this.hint,
    this.onTap,
  });

  final double maxWidth;
  final double maxHeight;
  final TextEditingController controller;
  final String hint;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: maxWidth,
        maxHeight: maxHeight,
      ),
      child: TextField(
        onTap: onTap,
        readOnly: onTap != null ? true : false,
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintMaxLines: 1,
          contentPadding: const EdgeInsets.only(
            left: AppPadding.low,
            bottom: AppPadding.low,
          ),
          // hintStyle: TextStyle(fontSize: 12),
          filled: true,
          fillColor: AppColor.textFieldColor,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
