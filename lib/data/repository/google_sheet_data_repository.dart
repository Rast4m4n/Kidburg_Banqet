import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kidburg_banquet/api/i_api_google_sheet.dart';
import 'package:kidburg_banquet/core/di/i_di_scope.dart';
import 'package:kidburg_banquet/domain/model/category_model.dart';
import 'package:kidburg_banquet/domain/model/dish_model.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

part '../../presentation/utils/mapper_api.dart';

abstract class IRepository {
  IRepository({required this.iApi});
  final IApiGoogleSheet iApi;

  Future<List<CategoryModel>> fetchCategoriesAndDishes(
    BuildContext context,
  );
}

class GoogleSheetDataRepository implements IRepository {
  GoogleSheetDataRepository({
    required this.iApi,
  });
  @override
  final IApiGoogleSheet iApi;

  @override
  Future<List<CategoryModel>> fetchCategoriesAndDishes(
    BuildContext context,
  ) async {
    final cacheData =
        await context.read<IDiScope>().storage.loadCacheCategoryModel();

    if (cacheData != null) {
      try {
        return _mapDataToCategories(jsonDecode(cacheData));
      } catch (e) {
        throw Exception('Ошибка вывода данных из кеша: $e');
      }
    } else {
      late final Locale currentLocale;
      if (context.mounted) {
        currentLocale = Localizations.localeOf(context);
      }
      final data = await iApi.get(languageSheet: currentLocale.languageCode);
      if (context.mounted) {
        await context.read<IDiScope>().storage.cacheHTTPResponseDishesData(
              data,
              const Duration(hours: 24),
            );
      }
      return _mapDataToCategories(jsonDecode(data));
    }
  }
}
