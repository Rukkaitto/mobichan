part of 'history_cubit.dart';

abstract class HistoryState extends Equatable {
  const HistoryState();
}

class HistoryInitial extends HistoryState {
  const HistoryInitial();

  @override
  List<Object?> get props => [];
}

class HistoryLoading extends HistoryState {
  const HistoryLoading();

  @override
  List<Object?> get props => [];
}

class HistoryLoaded extends HistoryState {
  final List<Post> history;
  const HistoryLoaded(this.history);

  @override
  List<Object?> get props => [history];
}

class HistoryError extends HistoryState {
  final String message;
  const HistoryError(this.message);

  @override
  List<Object?> get props => [message];
}
