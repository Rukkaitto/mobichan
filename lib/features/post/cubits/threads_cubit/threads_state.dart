part of 'threads_cubit.dart';

abstract class ThreadsState extends Equatable {
  const ThreadsState();
}

class ThreadsInitial extends ThreadsState {
  const ThreadsInitial();

  @override
  List<Object?> get props => [];
}

class ThreadsLoading extends ThreadsState {
  const ThreadsLoading();

  @override
  List<Object?> get props => [];
}

class ThreadsLoaded extends ThreadsState {
  final List<Post> threads;
  const ThreadsLoaded(this.threads);

  @override
  List<Object?> get props => [threads];
}

class ThreadsError extends ThreadsState {
  final String message;
  const ThreadsError(this.message);

  @override
  List<Object?> get props => [message];
}
