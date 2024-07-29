// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dish_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DishModel _$DishModelFromJson(Map<String, dynamic> json) => DishModel(
      // rowIndex: (json['rowIndex'] as num).toInt(),
      nameDish: json['nameDish'] as String?,
      weight: json['weight'] as String?,
      price: json['price'] as int?,
      count: json['count'] as int,
    );

Map<String, dynamic> _$DishModelToJson(DishModel instance) => <String, dynamic>{
      // 'rowIndex': instance.rowIndex,
      'nameDish': instance.nameDish,
      'weight': instance.weight,
      'count': instance.count,
      'price': instance.price,
    };
