part of 'sort_cubit.dart';

abstract class SortState extends Equatable {
  const SortState();

  @override
  List<Object> get props => [];
}

class SortInitial extends SortState {}

class SortLoading extends SortState {}

class SortLoaded extends SortState {
  final Sort sort;

  const SortLoaded(this.sort);

  @override
  List<Object> get props => [sort];
}

class SortError extends SortState {
  final String message;

  const SortError(this.message);

  @override
  List<Object> get props => [message];
}
