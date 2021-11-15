import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'post_form_state.dart';

class PostFormCubit extends Cubit<PostFormState> {
  PostFormCubit() : super(PostFormState());

  void toggleForm() {
    emit(
      PostFormState(
        isVisible: !state.isVisible,
        isExpanded: state.isExpanded,
      ),
    );
  }

  void setExpanded(bool isExpanded) {
    emit(
      PostFormState(
        isVisible: state.isVisible,
        isExpanded: isExpanded,
      ),
    );
  }

  void sendPost(bool isInThread) {}
}
