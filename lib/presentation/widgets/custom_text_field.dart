import 'package:flutter/material.dart';
import 'package:kidburg_banquet/presentation/theme/app_theme.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    required this.maxWidth,
    required this.maxHeight,
    required this.label,
    this.onTap,
  });

  final double maxWidth;
  final double maxHeight;
  final TextEditingController controller;
  final Text label;
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
        controller: controller,
        decoration: InputDecoration(
          label: label,
          filled: true,
          fillColor: AppColor.textFieldColor,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
