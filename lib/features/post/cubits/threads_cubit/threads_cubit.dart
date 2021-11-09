import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobichan/localization.dart';
import 'package:mobichan_data/mobichan_data.dart';
import 'package:mobichan_domain/mobichan_domain.dart';
import 'package:easy_localization/easy_localization.dart';

part 'threads_state.dart';

class ThreadsCubit extends Cubit<ThreadsState> {
  final PostRepository repository;
  late List<Post> threads;

  ThreadsCubit({required this.repository}) : super(ThreadsInitial());

  Future<void> getThreads(Board board, Sort sort) async {
    try {
      emit(ThreadsLoading());
      threads = await repository.getThreads(board: board, sort: sort);
      emit(ThreadsLoaded(threads));
    } on NetworkException {
      emit(ThreadsError(threads_loading_error.tr()));
    }
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
