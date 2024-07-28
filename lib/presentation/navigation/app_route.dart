import 'package:flutter/material.dart';
import 'package:kidburg_banquet/data/repository/shared_preferences_repository.dart';
import 'package:kidburg_banquet/presentation/screens/main_banquet/main_banquet_screen.dart';
import 'package:kidburg_banquet/presentation/screens/preorder_form/pre_order_form_screen.dart';
import 'package:kidburg_banquet/presentation/screens/preview_banqet.dart/preview_banqet_screen.dart';
import 'package:kidburg_banquet/presentation/screens/selection_kidburg/selection_kidburg_screen.dart';

abstract final class AppRoute {
  static const String mainPage = 'main';
  static const String preOrderFormPage = 'pre-order-form-page';
  static const String previewBanquetPage = 'preview-banquet-page';
  static const String selectionKidburgPage = 'selection-kidburg-page';
}

class AppNavigation {
  String _initialRoute = AppRoute.selectionKidburgPage;

  void isAuth() async {
    final managerModel =
        await SharedPreferencesRepository.instance.loadManagerInfo();
    if (managerModel == null) {
      _initialRoute;
    } else {
      _initialRoute = AppRoute.mainPage;
    }
  }

  String get initialRoute => AppRoute.preOrderFormPage;

  Map<String, WidgetBuilder> routes(context) => {
        AppRoute.selectionKidburgPage: (context) => SelectionKidburScreen(),
        AppRoute.mainPage: (context) => MainBanquetScreen(),
        AppRoute.preOrderFormPage: (context) => const PreOrderFormScreen(),
        AppRoute.previewBanquetPage: (context) => const PreviewBanqetScreen(),
      };
}
