import 'package:flutter/material.dart';
import 'package:kidburg_banquet/domain/model/category_model.dart';

class TableModel {
  TableModel({
    required this.id,
    required this.name,
    required this.categories,
    this.timeServing,
  });
  final String id;
  final String name;
  final TimeOfDay? timeServing;
  final List<CategoryModel> categories;

  TableModel copyWith({
    String? id,
    String? name,
    List<CategoryModel>? categories,
    TimeOfDay? timeServing,
  }) {
    return TableModel(
      id: id ?? this.id,
      name: name ?? this.name,
      categories: categories ?? this.categories,
      timeServing: timeServing ?? this.timeServing,
    );
  }
}
