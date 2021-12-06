part of 'replies_cubit.dart';

class RepliesState extends BaseState {}

class RepliesInitial extends BaseInitialState with RepliesState {}

class RepliesLoading extends BaseLoadingState with RepliesState {}

class RepliesLoaded extends BaseLoadedState<List<Post>> with RepliesState {
  RepliesLoaded(List<Post> data) : super(data);
}

class RepliesError extends BaseErrorState with RepliesState {
  RepliesError(String message) : super(message);
}
