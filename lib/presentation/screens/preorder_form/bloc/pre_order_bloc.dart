import 'package:bloc/bloc.dart';
import 'package:kidburg_banquet/data/repository/excel_repository.dart';
import 'package:kidburg_banquet/domain/model/table_model.dart';
import 'package:meta/meta.dart';

part 'pre_order_event.dart';
part 'pre_order_state.dart';

class ExcelDataBloc extends Bloc<ExcelDataEvent, ExcelDataState> {
  ExcelDataBloc({
    required this.excelRepository,
  }) : super(ExcelDataInitial()) {
    on<LoadedListDishesEvent>(readDataExcel);
  }

  final ExcelRepository excelRepository;

  void readDataExcel(event, emit) async {
    try {
      final listDishes = await excelRepository.readDataExcel();
      emit(ExcelDataLoaded(listDishes));
    } catch (e) {
      emit(ExcelDataFailure(e));
    }
  }
}
