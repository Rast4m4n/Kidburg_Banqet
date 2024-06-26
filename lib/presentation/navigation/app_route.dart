import 'package:flutter/material.dart';
import 'package:kidburg_banquet/presentation/screens/main_banquet/main_banquet_screen.dart';
import 'package:kidburg_banquet/presentation/screens/preorder_form/pre_order_form_screen.dart';

abstract final class AppRoute {
  static const String mainPage = 'main';
  static const String preOrderFormPage = 'pre-order-form-page';
}

class AppNavigation {
  String get initialRoute => AppRoute.mainPage;

  Map<String, WidgetBuilder> routes(context) => {
        initialRoute: (context) => const MainBanquetScreen(),
        AppRoute.preOrderFormPage: (context) => const PreOrderFormScreen(),
      };
}
