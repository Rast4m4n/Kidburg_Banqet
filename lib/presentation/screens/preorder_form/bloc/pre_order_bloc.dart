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
    on<LoadListDishesEvent>((event, emit) async {
      final listDishes = await excelRepository.readDataExcel();
      emit(PreOrderLoaded(listDishes));
    });
  }
  final ExcelRepository excelRepository;
}
