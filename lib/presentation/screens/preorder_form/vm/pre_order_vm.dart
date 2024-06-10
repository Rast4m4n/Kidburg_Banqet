import 'package:kidburg_banquet/data/repository/excel_repository.dart';
import 'package:kidburg_banquet/domain/model/table_model.dart';

class PreOrderViewModel {
  PreOrderViewModel({
    required this.excelRepository,
  });

  final ExcelRepository excelRepository;

  Future<List<TableModel>> readDataFromExcel() async {
    return await excelRepository.readDataExcel();
  }
}
