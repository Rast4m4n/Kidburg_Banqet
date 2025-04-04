import 'package:kidburg_banquet/domain/model/manager_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract final class StorageKey {
  static const manager = 'manager';
}

class SharedPreferencesRepository {
  SharedPreferencesRepository._();

  static final SharedPreferencesRepository _singleton =
      SharedPreferencesRepository._();
  static SharedPreferencesRepository get instance => _singleton;

  final pref = SharedPreferences.getInstance();

  Future<void> saveManagerInfo(ManagerModel managerModel) async {
    (await pref).setString(StorageKey.manager, managerModel.toJson());
  }

  Future<ManagerModel?> loadManagerInfo() async {
    final json = (await pref).getString(StorageKey.manager);
    if (json == null) {
      return null;
    } else {
      print(ManagerModel.fromJson(json).toString());
      return ManagerModel.fromJson(json);
    }
  }
}
