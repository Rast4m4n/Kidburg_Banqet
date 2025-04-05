import 'package:kidburg_banquet/domain/model/manager_model.dart';
import 'package:kidburg_banquet/domain/model/statistic_model.dart';

abstract final class StorageKey {
  static const manager = 'manager';
  static const cacheDishes = 'cacheDishes';
  static const cacheCurrentDateTime = 'cacheCurrentTime';
  static const statistic = 'statistic';
}

abstract class IDataStorage {
  Future<void> saveManagerInfo(ManagerModel managerModel);
  Future<ManagerModel?> loadManagerInfo();
  Future<void> saveStatisticBanquets(
    StatisticModel statistic,
    String keyDateStorage,
  );
  Future<StatisticModel?> loadStatistic(String keyDateStorage);
  Future<void> cacheHTTPResponseDishesData(
    String data,
    Duration expirationDuration,
  );
  Future<String?> loadCacheCategoryModel();
  Future<void> removeCache();
}
