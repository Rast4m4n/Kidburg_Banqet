import 'package:flutter/material.dart';
import 'package:kidburg_banquet/core/di/di_scope_provider.dart';
import 'package:kidburg_banquet/domain/model/statistic_model.dart';

class StatisticViewModel {
  Future<StatisticModel?> loadStatisticFromSharedPref(
      BuildContext context) async {
    final keyDateStorage =
        "${DateTime.now().year}_year_${DateTime.now().month}_month";
    final statistic = await DiScopeProvider.of(context)!
        .storage
        .loadStatistic(keyDateStorage);
    return statistic;
  }
}
