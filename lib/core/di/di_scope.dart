import 'package:kidburg_banquet/core/di/i_di_scope.dart';
import 'package:kidburg_banquet/core/storage/i_data_storage.dart';
import 'package:kidburg_banquet/core/storage/shared_preferencese_storage.dart';

class DiScope implements IDiScope {
  @override
  Future<void> init() async {
    _dataStorage = SharedPreferencesStorage();
  }

  @override
  IDataStorage get storage => _dataStorage;
  late final IDataStorage _dataStorage;
}
