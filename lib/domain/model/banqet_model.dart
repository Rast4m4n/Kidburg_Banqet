// ignore_for_file: public_member_api_docs, sort_constructors_first
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
    this.nameOfManager,
    this.phoneNumberOfManager,
    this.phoneNumberOfClient,
    this.prepayment,
    this.cake,
    this.remark,
  });

  final String? nameOfManager;
  final String? phoneNumberOfManager;
  final String nameClient;
  final String? phoneNumberOfClient;
  final String place;
  final DateTime dateStart;
  final TimeOfDay firstTimeServing;
  final TimeOfDay? secondTimeServing;
  final List<TableModel>? tables;
  final int? amountOfChildren;
  final int? amountOfAdult;
  final int? prepayment;
  final String? cake;
  // Примечание к банкету
  final String? remark;

  BanqetModel copyWith({
    String? nameOfManager,
    String? numberOfManager,
    String? nameClient,
    String? numberClient,
    String? place,
    DateTime? dateStart,
    TimeOfDay? firstTimeServing,
    TimeOfDay? secondTimeServing,
    List<TableModel>? tables,
    int? amountOfChildren,
    int? amountOfAdult,
    int? prepayment,
    String? cake,
    String? remark,
  }) {
    return BanqetModel(
      nameOfManager: nameOfManager ?? this.nameOfManager,
      phoneNumberOfManager: numberOfManager ?? this.phoneNumberOfManager,
      nameClient: nameClient ?? this.nameClient,
      phoneNumberOfClient: numberClient ?? this.phoneNumberOfClient,
      place: place ?? this.place,
      dateStart: dateStart ?? this.dateStart,
      firstTimeServing: firstTimeServing ?? this.firstTimeServing,
      secondTimeServing: secondTimeServing ?? this.secondTimeServing,
      tables: tables ?? this.tables,
      amountOfChildren: amountOfChildren ?? this.amountOfChildren,
      amountOfAdult: amountOfAdult ?? this.amountOfAdult,
      prepayment: prepayment ?? this.prepayment,
      cake: cake ?? this.cake,
      remark: remark ?? this.remark,
    );
  }

  @override
  String toString() {
    return 'BanqetModel(nameOfManager: $nameOfManager, numberOfManager: $phoneNumberOfManager, nameClient: $nameClient, numberClient: $phoneNumberOfClient, place: $place, dateStart: $dateStart, firstTimeServing: $firstTimeServing, secondTimeServing: $secondTimeServing, tables: $tables, amountOfChildren: $amountOfChildren, amountOfAdult: $amountOfAdult, prepayment: $prepayment, cake: $cake, remark: $remark)';
  }
}
