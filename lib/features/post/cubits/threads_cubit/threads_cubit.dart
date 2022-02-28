import 'package:equatable/equatable.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobichan/localization.dart';
import 'package:mobichan_data/mobichan_data.dart';
import 'package:mobichan_domain/mobichan_domain.dart';
import 'package:easy_localization/easy_localization.dart';

part 'threads_state.dart';

class ThreadsCubit extends Cubit<ThreadsState> {
  final PostRepository repository;
  late List<Post> threads;

  ThreadsCubit({required this.repository}) : super(const ThreadsInitial());

  Future<void> getThreads(Board board, Sort sort) async {
    try {
      emit(const ThreadsLoading());
      threads = await repository.getThreads(board: board, sort: sort);
      for (Post thread in threads) {
        await repository.insertPost(board, thread);
      }
      emit(ThreadsLoaded(threads));
    } on NetworkException {
      emit(ThreadsError(kThreadsLoadingError.tr()));
    }
  }

  Future<void> postThread({
    required Board board,
    required Post post,
    required CaptchaChallenge captcha,
    required String response,
    required XFile? file,
  }) async {
    final thread = await repository.postThread(
      board: board,
      post: post,
      captchaChallenge: captcha.challenge,
      captchaResponse: response,
      filePath: file?.path,
    );
    await repository.insertUserPost(thread);
    FirebaseAnalytics.instance.logEvent(name: 'post_thread');
  }

  void search(String input) {
    if (input == "") {
      emit(ThreadsLoaded(threads));
    } else {
      final filteredThreads = threads
          .where((thread) =>
              (thread.sub ?? '')
                  .toLowerCase()
                  .contains(input.toLowerCase().trim()) ||
              (thread.com ?? '')
                  .toLowerCase()
                  .contains(input.toLowerCase().trim()))
          .toList();
      emit(ThreadsLoaded(filteredThreads));
    }
  }
}
