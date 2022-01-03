import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobichan_data/mobichan_data.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

part 'replies_state.dart';

class RepliesCubit extends Cubit<RepliesState> {
  final PostRepository repository;
  RepliesCubit({required this.repository}) : super(RepliesInitial());

  Future<void> getReplies(Board board, Post thread) async {
    emit(RepliesLoading());
    try {
      List<Post> replies =
          await repository.getPosts(board: board, thread: thread);
      for (Post post in replies) {
        await repository.insertPost(post);
      }
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
    await repository.postReply(
      board: board,
      post: post,
      resto: resto,
      captchaChallenge: captcha.challenge,
      captchaResponse: response,
      filePath: file?.path,
    );
  }
}
