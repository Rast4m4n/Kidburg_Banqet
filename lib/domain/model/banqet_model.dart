// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:kidburg_banquet/domain/model/manager_model.dart';

import 'package:kidburg_banquet/domain/model/table_model.dart';

class BanquetModel {
  const BanquetModel({
    required this.nameClient,
    required this.place,
    required this.dateStart,
    required this.firstTimeServing,
    required this.amountOfChildren,
    required this.amountOfAdult,
    required this.managerModel,
    this.tables,
    this.phoneNumberOfClient,
    this.prepayment,
    this.cake,
    this.remark,
  });

  final ManagerModel managerModel;
  final String nameClient;
  final String? phoneNumberOfClient;
  final String? phoneNumberOfClient;
  final String place;
  final DateTime dateStart;
  final TimeOfDay timeStart;
  final List<TableModel>? tables;
  final int? amountOfChildren;
  final int? amountOfAdult;
  final int? prepayment;
  final String? cake;
  // Примечание к банкету
  final String? remark;

  BanquetModel copyWith({
    ManagerModel? managerModel,
    String? nameClient,
    String? phoneNumberOfClient,
    String? place,
    DateTime? dateStart,
    TimeOfDay? timeStart,
    List<TableModel>? tables,
    int? amountOfChildren,
    int? amountOfAdult,
    int? prepayment,
    String? cake,
    String? remark,
  }) {
    return BanquetModel(
      managerModel: managerModel ?? this.managerModel,
      nameClient: nameClient ?? this.nameClient,
      phoneNumberOfClient: phoneNumberOfClient ?? this.phoneNumberOfClient,
      place: place ?? this.place,
      dateStart: dateStart ?? this.dateStart,
      timeStart: timeStart ?? this.timeStart,
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
    return 'BanqetModel(nameOfManager: ${managerModel.name}, numberOfManager: ${managerModel.phoneNumber}, nameClient: $nameClient, numberClient: $phoneNumberOfClient, place: $place, dateStart: $dateStart, firstTimeServing: $timeStart, tables: $tables, amountOfChildren: $amountOfChildren, amountOfAdult: $amountOfAdult, prepayment: $prepayment, cake: $cake, remark: $remark)';
  }
}
