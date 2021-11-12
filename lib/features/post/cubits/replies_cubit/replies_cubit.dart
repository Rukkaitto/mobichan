import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobichan_data/mobichan_data.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

part 'replies_state.dart';

class RepliesCubit extends Cubit<RepliesState> {
  final PostRepository repository;
  RepliesCubit({required this.repository}) : super(RepliesInitial());

  void getReplies(Board board, Post thread) async {
    emit(RepliesLoading());
    try {
      List<Post> replies =
          await repository.getPosts(board: board, thread: thread);
      emit(RepliesLoaded(replies: replies..removeAt(0)));
    } on NetworkException {
      emit(RepliesError());
    }
  }
}
