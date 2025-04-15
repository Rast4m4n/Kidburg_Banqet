import 'package:flutter/material.dart';
import 'package:kidburg_banquet/core/app/app.dart';
import 'package:kidburg_banquet/core/di/di_scope.dart';
import 'package:kidburg_banquet/core/di/i_di_scope.dart';
import 'package:provider/provider.dart';

abstract class IAppBuilder {
  /// Метод сборки приложения
  Future<Widget> build();

  Widget getApp();

  /// Метод для инициализации асинхронных операций перед запуском приложения
  Future<void> init();
}

class AppBuilder implements IAppBuilder {
  late final IDiScope diScope;
  late final bool isAuth;
  @override
  Future<Widget> build() async {
    await init();
    return getApp();
  }

  @override
  Widget getApp() {
    return ChangeNotifierProvider<IDiScope>(
      create: (context) => diScope,
      child: App(isAuth: isAuth),
    );
  }

  @override
  Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    diScope = DiScope();
    await diScope.init();
    isAuth = await diScope.storage.loadManagerInfo() != null ? true : false;
  }
}
