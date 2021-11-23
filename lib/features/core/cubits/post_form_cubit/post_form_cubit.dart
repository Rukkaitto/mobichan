import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
        isExpanded: state.isExpanded,
        file: state.file,
      ),
    );
  }

  void setExpanded(bool isExpanded) {
    emit(
      PostFormState(
        isVisible: state.isVisible,
        isExpanded: isExpanded,
        file: state.file,
      ),
    );
  }

  void setFile(XFile file) {
    emit(
      PostFormState(
        isVisible: state.isVisible,
        isExpanded: state.isExpanded,
        file: file,
      ),
    );
  }
}
