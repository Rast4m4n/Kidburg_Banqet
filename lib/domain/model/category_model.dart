// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import 'package:kidburg_banquet/domain/model/dish_model.dart';

part 'category_model.g.dart';

@JsonSerializable()
class CategoryModel {
  CategoryModel({
    required this.name,
    required this.dishes,
  });

  final String name;
  final List<DishModel> dishes;

  CategoryModel copywith({
    String? name,
    List<DishModel>? dishes,
  }) {
    return CategoryModel(
      name: name ?? this.name,
      dishes: dishes ?? this.dishes,
    );
  }

  Map<String, dynamic> toMap() {
    return _$CategoryModelToJson(this);
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return _$CategoryModelFromJson(map);
  }

  String toJson() => json.encode(toMap());

  factory CategoryModel.fromJson(String source) =>
      CategoryModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
