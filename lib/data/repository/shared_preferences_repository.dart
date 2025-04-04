import 'package:kidburg_banquet/domain/model/manager_model.dart';
import 'package:kidburg_banquet/domain/model/statistic_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract final class StorageKey {
  static const manager = 'manager';
  static const cacheDishes = 'cacheDishes';
  static const cacheCurrentDateTime = 'cacheCurrentTime';
  static const statistic = 'statistic';
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
      return ManagerModel.fromJson(json);
    }
  }

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
      (await pref)
          .setString(StorageKey.statistic + keyDateStorage, stat.toJson());
    } else {
      (await pref)
          .setString(StorageKey.statistic + keyDateStorage, statistic.toJson());
    }
  }

  Future<StatisticModel?> loadStatistic(String keyDateStorage) async {
    // (await pref).remove(StorageKey.statistic + keyDateStorage);
    final json = (await pref).getString(StorageKey.statistic + keyDateStorage);
    if (json == null) {
      return null;
    } else {
      return StatisticModel.fromJson(json);
    }
  }

  Future<void> cacheHTTPResponseDishesData(
      String data, Duration expirationDuration) async {
    (await pref).setString(StorageKey.cacheDishes, data);
    try {
      DateTime expirationTime = DateTime.now().add(expirationDuration);
      (await pref).setString(StorageKey.cacheDishes, data);
      (await pref).setString(
          StorageKey.cacheCurrentDateTime, expirationTime.toIso8601String());
    } catch (e) {
      print('Ошибка кеширования данных: $e');
    }
  }

  Future<String?> loadCacheCategoryModel() async {
    try {
      String? data = (await pref).getString(StorageKey.cacheDishes);
      String? expirationTimeStr =
          (await pref).getString(StorageKey.cacheCurrentDateTime);
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

  Future<void> removeCache() async {
    (await pref).remove(StorageKey.cacheDishes);
    (await pref).remove(StorageKey.cacheCurrentDateTime);
  }
}
