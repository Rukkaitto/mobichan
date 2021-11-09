import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

part 'threads_state.dart';

class ThreadsCubit extends Cubit<ThreadsState> {
  final PostRepository repository;

  ThreadsCubit({required this.repository}) : super(ThreadsInitial());

  Future<void> getThreads(Board board, Sort sort) async {
    emit(ThreadsLoading());
    List<Post> threads = await repository.getThreads(board: board, sort: sort);
    emit(ThreadsLoaded(threads));
  }
}
