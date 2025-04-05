import 'package:kidburg_banquet/core/storage/i_data_storage.dart';

abstract class IDiScope {
  Future<void> init();

  IDataStorage get storage;
}
