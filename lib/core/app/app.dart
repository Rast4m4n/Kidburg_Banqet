import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kidburg_banquet/core/di/i_di_scope.dart';
import 'package:kidburg_banquet/generated/l10n.dart';
import 'package:kidburg_banquet/presentation/navigation/app_route.dart';
import 'package:kidburg_banquet/presentation/theme/app_theme.dart';
import 'package:provider/provider.dart';

class App extends StatefulWidget {
  const App({
    super.key,
    required this.isAuth,
  });
  final bool isAuth;
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final AppTheme appTheme = AppTheme();
  final AppNavigation appNavigation = AppNavigation();

  @override
  Widget build(BuildContext context) {
    return Consumer<IDiScope>(
      builder: (context, IDiScope di, child) {
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
            locale: di.locale.locale,
            theme: appTheme.appThemeLight,
            routes: appNavigation.routes(context),
            initialRoute: appNavigation.isAuth(widget.isAuth),
          ),
        );
      },
    );
  }
}
