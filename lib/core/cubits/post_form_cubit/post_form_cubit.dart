import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

part 'post_form_state.dart';

class PostFormCubit extends Cubit<PostFormState> {
  String comment = '';
  PostFormCubit() : super(PostFormState());

  void clear() {
    state.subjectController.clear();
    emitComment('');
  }

  void toggleVisible() {
    setVisible(!state.isVisible);
  }

  void setVisible(bool isVisible) {
    emit(
      PostFormState(
        isVisible: isVisible,
        isExpanded: state.isExpanded,
        file: state.file,
        comment: comment,
      ),
    );
  }

  void setExpanded(bool isExpanded) {
    emit(
      PostFormState(
        isVisible: state.isVisible,
        isExpanded: isExpanded,
        file: state.file,
        comment: comment,
      ),
    );
  }

  void toggleExpanded() {
    setExpanded(!state.isExpanded);
  }

  void setFile(XFile file) {
    emit(
      PostFormState(
        isVisible: state.isVisible,
        isExpanded: state.isExpanded,
        file: file,
        comment: comment,
      ),
    );
  }

  void clearFile() {
    emit(
      PostFormState(
        isVisible: state.isVisible,
        isExpanded: state.isExpanded,
        file: null,
        comment: comment,
      ),
    );
  }

  void setComment(String value) {
    comment = value;
  }

  void emitComment(String value) {
    emit(
      PostFormState(
        isVisible: state.isVisible,
        isExpanded: state.isExpanded,
        file: state.file,
        comment: value,
      ),
    );
    setComment(value);
  }

  void reply(Post post) {
    var newComment = comment;
    newComment += '>>${post.no}\n';

    emitComment(newComment);
    setVisible(true);
  }

  void quote(String quote, Post reply) {
    var newComment = comment;
    if (newComment.isEmpty) {
      newComment += '>>${reply.no}\n';
    }
    newComment += '>$quote\n';

    emitComment(newComment);
    setVisible(true);
  }
}
