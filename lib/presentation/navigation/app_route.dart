import 'package:flutter/material.dart';
import 'package:kidburg_banquet/data/repository/shared_preferences_repository.dart';
import 'package:kidburg_banquet/presentation/screens/list_banquets/list_banquets_screen.dart';
import 'package:kidburg_banquet/presentation/screens/main_banquet/main_banquet_screen.dart';
import 'package:kidburg_banquet/presentation/screens/preorder_form/pre_order_form_screen.dart';
import 'package:kidburg_banquet/presentation/screens/preview_banqet.dart/preview_banqet_screen.dart';
import 'package:kidburg_banquet/presentation/screens/selection_kidburg/selection_kidburg_screen.dart';
import 'package:kidburg_banquet/presentation/screens/statistics/statistics_screen.dart';

abstract final class AppRoute {
  static const String mainPage = 'main';
  static const String preOrderFormPage = 'pre-order-form';
  static const String previewBanquetPage = 'preview-banquet';
  static const String selectionKidburgPage = 'selection-kidburg';
  static const String listBanquetPage = 'list-banquet';
  static const String statisticPage = 'statistic';
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

  String get initialRoute => _initialRoute;

  Map<String, WidgetBuilder> routes(context) => {
        AppRoute.selectionKidburgPage: (context) => SelectionKidburScreen(),
        AppRoute.mainPage: (context) => const MainBanquetScreen(),
        AppRoute.listBanquetPage: (context) => const ListBanquetsScreen(),
        AppRoute.statisticPage: (context) => const StatisticsScreen(),
        AppRoute.preOrderFormPage: (context) => const PreOrderFormScreen(),
        AppRoute.previewBanquetPage: (context) => const PreviewBanqetScreen(),
      };
}
