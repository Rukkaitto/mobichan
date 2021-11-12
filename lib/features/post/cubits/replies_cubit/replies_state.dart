part of 'replies_cubit.dart';

abstract class RepliesState extends Equatable {
  const RepliesState();

  @override
  List<Object> get props => [];
}

class RepliesInitial extends RepliesState {}

class RepliesLoading extends RepliesState {}

class RepliesLoaded extends RepliesState {
  final List<Post> replies;

  const RepliesLoaded({required this.replies});

  @override
  List<Object> get props => [replies];
}

class RepliesError extends RepliesState {}
