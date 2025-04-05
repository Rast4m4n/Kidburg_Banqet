// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dish_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DishModel _$DishModelFromJson(Map<String, dynamic> json) => DishModel(
      id: json['id'] as String,
      nameDish: json['nameDish'] as String?,
      weight: json['weight'] as String?,
      price: (json['price'] as num?)?.toInt(),
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$DishModelToJson(DishModel instance) => <String, dynamic>{
      'id': instance.id,
      'nameDish': instance.nameDish,
      'weight': instance.weight,
      'count': instance.count,
      'price': instance.price,
    };
