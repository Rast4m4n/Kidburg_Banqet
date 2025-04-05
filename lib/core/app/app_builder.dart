import 'package:flutter/material.dart';
import 'package:kidburg_banquet/core/app/app.dart';
import 'package:kidburg_banquet/core/di/di_scope.dart';
import 'package:kidburg_banquet/core/di/di_scope_provider.dart';
import 'package:kidburg_banquet/core/di/i_di_scope.dart';

abstract class IAppBuilder {
  /// Метод сборки приложения
  Future<Widget> build();

  Widget getApp();

  /// Метод для инициализации асинхронных операций перед запуском приложения
  Future<void> init();
}

class AppBuilder implements IAppBuilder {
  late final IDiScope diScope;
  @override
  Future<Widget> build() async {
    await init();
    return getApp();
  }

  @override
  Widget getApp() {
    return DiScopeProvider(
      diScope: diScope,
      child: const App(),
    );
  }

  @override
  Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    diScope = DiScope();
    await diScope.init();
  }
}
