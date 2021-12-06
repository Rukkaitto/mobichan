part of 'threads_cubit.dart';

class ThreadsState extends BaseState {}

class ThreadsInitial extends BaseInitialState with ThreadsState {}

class ThreadsLoading extends BaseLoadingState with ThreadsState {}

class ThreadsLoaded extends BaseLoadedState<List<Post>> with ThreadsState {
  ThreadsLoaded(List<Post> data) : super(data);
}

class ThreadsError extends BaseErrorState with ThreadsState {
  ThreadsError(String message) : super(message);
}
