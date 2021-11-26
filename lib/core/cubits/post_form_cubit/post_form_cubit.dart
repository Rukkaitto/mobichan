import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

part 'post_form_state.dart';

class PostFormCubit extends Cubit<PostFormState> {
  PostFormCubit() : super(PostFormState());

  void toggleVisible() {
    setVisible(!state.isVisible);
  }

  void setVisible(bool isVisible) {
    emit(
      PostFormState(
        isVisible: isVisible,
        height: state.height,
        file: state.file,
        comment: state.comment,
      ),
    );
  }

  void setExpanded(bool isExpanded) {
    emit(
      PostFormState(
        isVisible: state.isVisible,
        height: isExpanded
            ? PostFormState.expandedHeight
            : PostFormState.contractedHeight,
        file: state.file,
        comment: state.comment,
      ),
    );
  }

  void toggleExpanded() {
    state.height == PostFormState.expandedHeight
        ? setExpanded(false)
        : setExpanded(true);
  }

  void setFile(XFile file) {
    emit(
      PostFormState(
        isVisible: state.isVisible,
        height: state.height,
        file: file,
        comment: state.comment,
      ),
    );
  }

  void clearFile() {
    emit(
      PostFormState(
        isVisible: state.isVisible,
        height: state.height,
        file: null,
        comment: state.comment,
      ),
    );
  }

  void setComment(String value) {
    emit(
      PostFormState(
        isVisible: state.isVisible,
        height: state.height,
        file: state.file,
        comment: value,
      ),
    );
  }

  void reply(Post post) {
    var comment = state.comment;
    comment += '>>${post.no}\n';

    setComment(comment);
    setVisible(true);
  }

  void quote(String quote, Post reply) {
    var comment = state.comment;
    if (comment.isEmpty) {
      comment += '>>${reply.no}\n';
    }
    comment += '>$quote\n';

    setComment(comment);
    setVisible(true);
  }
}
