import 'package:flutter/material.dart';
import 'package:kidburg_banquet/presentation/navigation/app_route.dart';

class CreateBanquetVM extends ChangeNotifier {
  CreateBanquetVM();
  DateTime? selectedDate;

  Future<void> showDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      notifyListeners();
    }
  }

  void routingToPreOrder(BuildContext context) {
    Navigator.of(context).pushNamed(AppRoute.preOrderFormPage);
  }
}
