part of 'sort_cubit.dart';

class SortState extends BaseState {}

class SortInitial extends BaseInitialState with SortState {}

class SortLoading extends BaseLoadingState with SortState {}

class SortLoaded extends BaseLoadedState<Sort> with SortState {
  final Sort sort;
  SortLoaded(this.sort) : super(sort);
}

class SortError extends BaseErrorState with SortState {
  SortError(String message) : super(message);
}
