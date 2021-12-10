import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobichan_domain/mobichan_domain.dart';
import 'package:equatable/equatable.dart';

part 'replies_dialog_state.dart';

class RepliesDialogCubit extends Cubit<List<RepliesDialogState>> {
  RepliesDialogCubit(
    List<Post> initialReplies,
    Post? initialReplyingTo,
  ) : super(
          [
            RepliesDialogState(
              replies: initialReplies,
              replyingTo: initialReplyingTo,
            ),
          ],
        );

  void setReplies(List<Post> replies, Post? replyingTo) {
    final newState = List<RepliesDialogState>.from(state);
    newState.add(
      RepliesDialogState(
        replies: replies,
        replyingTo: replyingTo,
      ),
    );
    emit(newState);
  }

  void pop() {
    final newState = List<RepliesDialogState>.from(state);
    newState.removeLast();
    emit(newState);
  }
}
