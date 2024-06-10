part of 'pre_order_bloc.dart';

@immutable
sealed class ExcelDataState {}

final class ExcelDataInitial extends ExcelDataState {}

final class ExcelDataLoading extends ExcelDataState {}

final class ExcelDataLoaded extends ExcelDataState {
  ExcelDataLoaded(this.tableModel);

  final List<TableModel> tableModel;
}

final class ExcelDataFailure extends ExcelDataState {
  ExcelDataFailure(this.exception);
  final Object? exception;
}
