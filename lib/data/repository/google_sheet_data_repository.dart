import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kidburg_banquet/core/di/di_scope_provider.dart';
import 'package:kidburg_banquet/domain/model/category_model.dart';
import 'package:kidburg_banquet/domain/model/dish_model.dart';
import 'package:uuid/uuid.dart';

part '../../presentation/utils/mapper_api.dart';

abstract class ApiRepository {
  Future<String> get();
}

class GoogleSheetApiRepository implements ApiRepository {
  static const String _url =
      'https://script.google.com/macros/s/AKfycbwRfXear5quPtotp9Ty81As8tzN2hHmQfq5lpCOLfrFRHp1DLpia2sDw35UmsO1It7M6w/exec';
  @override
  Future<String> get() async {
    final response = await http.get(Uri.parse(_url));
    switch (response.statusCode) {
      case 200:
        try {
          return response.body;
        } catch (e) {
          throw FormatException('Ошибка форматирования данных: $e');
        }
      case 404:
        throw Exception('Данные не найдены (404)');
      case 500:
        throw Exception('Ошибка стороны сервера (500)');
      default:
        throw Exception('Ошибка загрузки данных: ${response.statusCode}');
    }
  }
}

class GoogleSheetDataRepository {
  GoogleSheetDataRepository({required this.apiRepository});
  final ApiRepository apiRepository;

  Future<List<CategoryModel>> fetchCategoriesAndDishes(
      BuildContext context) async {
    final cacheData =
        await DiScopeProvider.of(context)!.storage.loadCacheCategoryModel();
    if (cacheData != null) {
      try {
        return _mapDataToCategories(jsonDecode(cacheData));
      } catch (e) {
        throw Exception('Ошибка вывода данных из кеша: $e');
      }
    } else {
      final data = await apiRepository.get();
      if (context.mounted) {
        await DiScopeProvider.of(context)!.storage.cacheHTTPResponseDishesData(
              data,
              const Duration(hours: 24),
            );
      }
      return _mapDataToCategories(jsonDecode(data));
    }
  }
}
