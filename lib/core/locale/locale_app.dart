import 'package:flutter/widgets.dart';
import 'package:kidburg_banquet/domain/model/manager_model.dart';

class LocaleApp with ChangeNotifier {
  LocaleApp({required this.storage});
  late Locale locale;
  final Future<ManagerModel?> storage;

  Future<void> init() async => locale = (await storage)?.locale ??
      WidgetsBinding.instance.platformDispatcher.locale;

  void updateLocale(Locale newLocale) {
    locale = newLocale;
    notifyListeners();
  }
}
