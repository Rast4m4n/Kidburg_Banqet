import 'package:kidburg_banquet/core/storage/i_data_storage.dart';
import 'package:kidburg_banquet/domain/model/manager_model.dart';
import 'package:kidburg_banquet/domain/model/statistic_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesStorage implements IDataStorage {
  SharedPreferencesStorage() {
    _pref = SharedPreferences.getInstance();
  }
  late final Future<SharedPreferences> _pref;

  @override
  Future<void> saveManagerInfo(ManagerModel managerModel) async {
    (await _pref).setString(StorageKey.manager, managerModel.toJson());
  }

  @override
  Future<ManagerModel?> loadManagerInfo() async {
    final json = (await _pref).getString(StorageKey.manager);
    if (json == null) {
      return null;
    } else {
      return ManagerModel.fromJson(json);
    }
  }

  @override
  Future<void> cacheHTTPResponseDishesData(
    String data,
    Duration expirationDuration,
  ) async {
    (await _pref).setString(StorageKey.cacheDishes, data);
    try {
      DateTime expirationTime = DateTime.now().add(expirationDuration);
      (await _pref).setString(StorageKey.cacheDishes, data);
      (await _pref).setString(
          StorageKey.cacheCurrentDateTime, expirationTime.toIso8601String());
    } catch (e) {
      print('Ошибка кеширования данных: $e');
    }
  }

  @override
  Future<String?> loadCacheCategoryModel() async {
    try {
      String? data = (await _pref).getString(StorageKey.cacheDishes);
      String? expirationTimeStr =
          (await _pref).getString(StorageKey.cacheCurrentDateTime);
      if (data == null || expirationTimeStr == null) return null;

      DateTime expirationTime = DateTime.parse(expirationTimeStr);
      // Если срок хранения данных не истёк, то выводим их
      // Иначе удаляем данные и возвращаем null
      if (expirationTime.isAfter(DateTime.now())) {
        return data;
      } else {
        await removeCache();
        return null;
      }
    } catch (e) {
      print('Ошибка получения кешированных данных: $e');
      return null;
    }
  }

  @override
  Future<void> saveStatisticBanquets(
    StatisticModel statistic,
    String keyDateStorage,
  ) async {
    final json = await loadStatistic(keyDateStorage);
    if (json != null) {
      final stat = json.copyWith(
        sum: json.sum + statistic.sum,
        guests: json.guests + statistic.guests,
        numberOfOrder: json.numberOfOrder + statistic.numberOfOrder,
      );
      (await _pref)
          .setString(StorageKey.statistic + keyDateStorage, stat.toJson());
    } else {
      (await _pref)
          .setString(StorageKey.statistic + keyDateStorage, statistic.toJson());
    }
  }

  @override
  Future<StatisticModel?> loadStatistic(String keyDateStorage) async {
    final json = (await _pref).getString(StorageKey.statistic + keyDateStorage);
    if (json == null) {
      return null;
    } else {
      return StatisticModel.fromJson(json);
    }
  }

  @override
  Future<void> removeCache() async {
    (await _pref).remove(StorageKey.cacheDishes);
    (await _pref).remove(StorageKey.cacheCurrentDateTime);
  }
}
