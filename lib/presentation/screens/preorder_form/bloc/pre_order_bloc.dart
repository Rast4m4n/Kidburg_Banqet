import 'package:bloc/bloc.dart';
import 'package:kidburg_banquet/data/repository/excel_repository.dart';
import 'package:kidburg_banquet/domain/model/table_model.dart';
import 'package:meta/meta.dart';

part 'pre_order_event.dart';
part 'pre_order_state.dart';

class PreOrderBloc extends Bloc<PreOrderEvent, PreOrderState> {
  PreOrderBloc({
    required this.excelRepository,
  }) : super(PreOrderInitial()) {
    on<LoadListDishesEvent>(readDataExcel);
  }

  final ExcelRepository excelRepository;

  void readDataExcel(event, emit) async {
    try {
      final listDishes = await excelRepository.readDataExcel();
      emit(PreOrderLoaded(listDishes));
    } catch (e) {
      emit(PreOrderFailure(e));
    }
  }
}
