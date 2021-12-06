part of 'release_cubit.dart';

class ReleaseState extends BaseState {}

class ReleaseInitial extends BaseInitialState with ReleaseState {}

class ReleaseLoading extends BaseLoadingState with ReleaseState {}

class ReleaseLoaded extends BaseLoadedState<Release> with ReleaseState {
  ReleaseLoaded(Release data) : super(data);
}

class ReleaseError extends BaseErrorState with ReleaseState {
  ReleaseError(String message) : super(message);
}
