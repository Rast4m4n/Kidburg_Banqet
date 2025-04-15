import 'package:flutter/material.dart';
import 'package:kidburg_banquet/core/di/i_di_scope.dart';
import 'package:kidburg_banquet/domain/model/statistic_model.dart';
import 'package:provider/provider.dart';

class StatisticViewModel {
  Future<StatisticModel?> loadStatisticFromSharedPref(
      BuildContext context) async {
    final keyDateStorage =
        "${DateTime.now().year}_year_${DateTime.now().month}_month";
    final statistic =
        await context.read<IDiScope>().storage.loadStatistic(keyDateStorage);
    return statistic;
  }
}
