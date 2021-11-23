import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

class RepliesDialogCubit extends Cubit<List<Post>> {
  RepliesDialogCubit(List<Post> initialState) : super(initialState);

  void setReplies(List<Post> replies) {
    emit(replies);
  }
}
