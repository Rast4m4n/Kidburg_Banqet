part of 'pre_order_bloc.dart';

@immutable
sealed class ExcelDataEvent {}

final class LoadedListDishesEvent extends ExcelDataEvent {}
