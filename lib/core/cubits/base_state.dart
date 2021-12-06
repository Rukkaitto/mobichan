import 'package:equatable/equatable.dart';

abstract class BaseState extends Equatable {
  @override
  List<Object?> get props => [];
}

class BaseInitialState extends BaseState {}

class BaseLoadingState extends BaseState {}

class BaseLoadedState<T> extends BaseState {
  final T data;
  BaseLoadedState(this.data);

  @override
  List<Object?> get props => [data];
}

class BaseErrorState extends BaseState {
  final String message;
  BaseErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
