import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      if (state is ThreadsInitial) {
        emit(const ThreadsLoading());
      }
      threads = await repository.getThreads(board: board, sort: sort);
      await repository.insertPosts(board, threads);
      emit(ThreadsLoaded(threads));
    } on NetworkException {
      emit(ThreadsError(kThreadsLoadingError.tr()));
    }
  }

  Future<Post> postThread({
    required Board board,
    required Post post,
    required CaptchaChallenge captcha,
    required String response,
    required File? file,
  }) async {
    final thread = await repository.postThread(
      board: board,
      post: post,
      captchaChallenge: captcha.challenge,
      captchaResponse: response,
      filePath: file?.path,
      fileName: file?.uri.pathSegments.last,
    );
    await repository.insertUserPost(thread);
    FirebaseAnalytics.instance.logEvent(name: 'post_thread');
    return thread;
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
