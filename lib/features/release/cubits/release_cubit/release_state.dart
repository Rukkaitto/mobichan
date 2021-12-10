part of 'release_cubit.dart';

abstract class ReleaseState extends Equatable {
  const ReleaseState();

  @override
  List<Object> get props => [];
}

class ReleaseInitial extends ReleaseState {}

class ReleaseLoading extends ReleaseState {}

class ReleaseLoaded extends ReleaseState {
  final Release release;

  const ReleaseLoaded(this.release);

  @override
  List<Object> get props => [release];
}

class ReleaseError extends ReleaseState {
  final String message;

  const ReleaseError(this.message);

  @override
  List<Object> get props => [message];
}
