import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobichan_data/mobichan_data.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

part 'replies_state.dart';

class RepliesCubit extends Cubit<RepliesState> {
  final PostRepository repository;
  RepliesCubit({required this.repository}) : super(RepliesInitial());

  Future<void> getReplies(Board board, Post thread) async {
    if (state is RepliesInitial) {
      emit(RepliesLoading());
    }
    try {
      List<Post> replies =
          await repository.getPosts(board: board, thread: thread);
      List<Post> userPosts = await repository.getUserPosts();
      for (var reply in replies) {
        if (userPosts.map((post) => post.no).contains(reply.no)) {
          reply.isMine = true;
        }
      }
      await repository.insertPosts(board, replies);
      emit(RepliesLoaded(replies: replies));
    } on NetworkException {
      emit(RepliesError());
    }
  }

  Future<void> postReply({
    required Board board,
    required Post post,
    required Post resto,
    required CaptchaChallenge captcha,
    required String response,
    required XFile? file,
  }) async {
    final reply = await repository.postReply(
      board: board,
      post: post,
      resto: resto,
      captchaChallenge: captcha.challenge,
      captchaResponse: response,
      filePath: file?.path,
    );
    await repository.insertUserPost(reply);
    FirebaseAnalytics.instance.logEvent(name: 'post_reply');
  }
}
