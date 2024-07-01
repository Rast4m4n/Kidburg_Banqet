import 'package:flutter/material.dart';
import 'package:kidburg_banquet/core/permission_app.dart';
import 'package:kidburg_banquet/generated/l10n.dart';
import 'package:kidburg_banquet/presentation/navigation/app_route.dart';
import 'package:kidburg_banquet/presentation/theme/app_theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final AppTheme appTheme = AppTheme();
  final AppNavigation appNavigator = AppNavigation();
  final PermissionApp permission = PermissionApp();
  await permission.requestPermission();

  runApp(MainApp(
    appTheme: appTheme,
    appNavigation: appNavigator,
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({
    super.key,
    required this.appTheme,
    required this.appNavigation,
  });

  final AppTheme appTheme;
  final AppNavigation appNavigation;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        debugShowCheckedModeBanner: false,
        theme: appTheme.appThemeLight,
        routes: appNavigation.routes(context),
        initialRoute: appNavigation.initialRoute,
      ),
    );
  }
}
