part of 'replies_dialog_cubit.dart';

class RepliesDialogState extends Equatable {
  final List<Post> replies;
  final Post? replyingTo;

  const RepliesDialogState({required this.replies, required this.replyingTo});

  @override
  List<Object?> get props => [replies, replyingTo];
}
