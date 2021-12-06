part of 'history_cubit.dart';

class HistoryState extends BaseState {}

class HistoryInitial extends BaseInitialState with HistoryState {}

class HistoryLoading extends BaseLoadingState with HistoryState {}

class HistoryLoaded extends BaseLoadedState<List<Post>> with HistoryState {
  HistoryLoaded(List<Post> data) : super(data);
}

class HistoryError extends BaseErrorState with HistoryState {
  HistoryError(String message) : super(message);
}
