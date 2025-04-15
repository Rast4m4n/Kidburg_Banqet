import 'package:flutter/widgets.dart';
import 'package:kidburg_banquet/core/locale/locale_app.dart';
import 'package:kidburg_banquet/core/storage/i_data_storage.dart';

abstract class IDiScope with ChangeNotifier {
  Future<void> init();

  IDataStorage get storage;
  late LocaleApp locale;
}
