// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'dish_model.g.dart';

@JsonSerializable()
class DishModel {
  DishModel({
    required this.nameDish,
    required this.weight,
    required this.price,
    required this.count,
  });
  final String? nameDish;
  final String? weight;
  final int count;
  final int? price;

  DishModel copyWith({
    String? nameDish,
    String? weight,
    int? count,
    int? price,
  }) {
    return DishModel(
      nameDish: nameDish ?? this.nameDish,
      weight: weight ?? this.weight,
      count: count ?? this.count,
      price: price ?? this.price,
    );
  }

  @override
  String toString() {
    return 'DishModel(nameDish: $nameDish, weight: $weight, count: $count, price: $price)';
  }

  Map<String, dynamic> toMap() {
    return _$DishModelToJson(this);
  }

  factory DishModel.fromMap(Map<String, dynamic> map) {
    return _$DishModelFromJson(map);
  }

  String toJson() => json.encode(toMap());

  factory DishModel.fromJson(String source) =>
      DishModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
