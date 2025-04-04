import 'dart:convert';

class StatisticModel {
  int sum;
  int guests;
  int numberOfOrder;

  StatisticModel({
    required this.sum,
    required this.guests,
    required this.numberOfOrder,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'sum': sum,
      'guests': guests,
      'numberOfOrder': numberOfOrder,
    };
  }

  factory StatisticModel.fromMap(Map<String, dynamic> map) {
    return StatisticModel(
      sum: map['sum'] as int,
      guests: map['guests'] as int,
      numberOfOrder: map['numberOfOrder'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory StatisticModel.fromJson(String source) =>
      StatisticModel.fromMap(json.decode(source) as Map<String, dynamic>);

  StatisticModel copyWith({
    int? sum,
    int? guests,
    int? numberOfOrder,
  }) {
    return StatisticModel(
      sum: sum ?? this.sum,
      guests: guests ?? this.guests,
      numberOfOrder: numberOfOrder ?? this.numberOfOrder,
    );
  }
}
