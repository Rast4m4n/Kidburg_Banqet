import 'package:flutter/material.dart';
import 'package:kidburg_banquet/presentation/screens/create_banquet_screen.dart';
import 'package:kidburg_banquet/presentation/theme/app_theme.dart';

void main() {
  final AppTheme appTheme = AppTheme();

  runApp(MainApp(
    appTheme: appTheme,
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({
    super.key,
    required this.appTheme,
  });

  final AppTheme appTheme;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        theme: appTheme.appThemeLight,
        home: const CreateBanquetScreen(),
      ),
    );
  }
}
