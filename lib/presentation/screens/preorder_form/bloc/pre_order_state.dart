part of 'pre_order_bloc.dart';

@immutable
sealed class PreOrderState {}

final class PreOrderInitial extends PreOrderState {}

final class PreOrderLoading extends PreOrderState {}

final class PreOrderLoaded extends PreOrderState {
  PreOrderLoaded(this.tableModel);

  final List<TableModel> tableModel;
}
