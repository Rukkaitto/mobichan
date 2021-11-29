import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

class RepliesDialogCubit extends Cubit<List<List<Post>>> {
  RepliesDialogCubit(List<Post> initialState) : super([initialState]);

  void setReplies(List<Post> replies) {
    final newState = List<List<Post>>.from(state);
    newState.add(replies);
    emit(newState);
  }

  void pop() {
    final newState = List<List<Post>>.from(state);
    newState.removeLast();
    emit(newState);
  }
}
