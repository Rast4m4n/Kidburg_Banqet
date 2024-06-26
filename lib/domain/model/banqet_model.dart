import 'package:flutter/material.dart';
import 'package:kidburg_banquet/domain/model/table_model.dart';

class BanqetModel {
  const BanqetModel({
    required this.nameClient,
    required this.place,
    required this.dateStart,
    required this.firstTimeServing,
    required this.amountOfChildren,
    required this.amountOfAdult,
    this.secondTimeServing,
    this.tables,
  });

  final String nameClient;
  final String place;
  final DateTime dateStart;
  final TimeOfDay firstTimeServing;
  final TimeOfDay? secondTimeServing;
  final List<TableModel>? tables;
  final int amountOfChildren;
  final int amountOfAdult;
}
