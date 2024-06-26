import 'package:flutter/material.dart';

class BanqetModel {
  const BanqetModel({
    required this.nameClient,
    required this.place,
    required this.dateStart,
    required this.timeStart,
    required this.amountOfChildren,
    required this.amountOfAdult,
  });

  final String nameClient;
  final String place;
  final DateTime dateStart;
  final TimeOfDay timeStart;
  final int amountOfChildren;
  final int amountOfAdult;
}
