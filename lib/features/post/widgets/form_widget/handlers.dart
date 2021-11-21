import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobichan/features/captcha/captcha.dart';
import 'package:mobichan/features/core/core.dart';
import 'package:mobichan_domain/mobichan_domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'form_widget.dart';

extension FormWidgetHandlers on FormWidget {
  void handleExpandPressed(BuildContext context, PostFormState form) {
    context.read<PostFormCubit>().setExpanded(!form.isExpanded);
  }

  void handlePictureIconPressed(BuildContext context) async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      context.read<PostFormCubit>().setFile(pickedFile);
    }
  }

  void handleSendIconPressed(
      BuildContext context, PostFormState form, Board board, Post? thread) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return CaptchaPage(
          context: context,
          board: board,
          thread: thread,
          post: Post(
            name: form.nameController.text,
            sub: form.subjectController.text,
            com: form.commentController.text,
          ),
          file: form.file,
        );
      },
    );
  }
}
