import 'package:flutter/widgets.dart';
import 'package:kidburg_banquet/core/di/i_di_scope.dart';
import 'package:kidburg_banquet/core/locale/locale_app.dart';
import 'package:kidburg_banquet/core/storage/i_data_storage.dart';
import 'package:kidburg_banquet/core/storage/shared_preferencese_storage.dart';

class DiScope with ChangeNotifier implements IDiScope {
  @override
  Future<void> init() async {
    _dataStorage = SharedPreferencesStorage();
    locale = LocaleApp(storage: _dataStorage.loadManagerInfo());
    locale.init();
    locale.addListener(() {
      notifyListeners();
    });
  }

  @override
  IDataStorage get storage => _dataStorage;
  late final IDataStorage _dataStorage;

  @override
  late LocaleApp locale;
}
