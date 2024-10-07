import 'package:kidburg_banquet/data/repository/shared_preferences_repository.dart';
import 'package:kidburg_banquet/domain/model/statistic_model.dart';

class StatisticViewModel {
  Future<StatisticModel?> loadStatisticFromSharedPref() async {
    final keyDateStorage =
        "${DateTime.now().year}_year_${DateTime.now().month}_month";
    final statistic = await SharedPreferencesRepository.instance
        .loadStatistic(keyDateStorage);
    return statistic;
  }
}
