import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobichan/features/captcha/captcha.dart';
import 'package:mobichan/core/core.dart';
import 'package:mobichan/core/widgets/snackbars/success_snackbar.dart';
import 'package:mobichan/features/post/post.dart';
import 'package:mobichan/localization.dart';
import 'package:mobichan_data/mobichan_data.dart';
import 'package:mobichan_domain/mobichan_domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

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
    BuildContext context,
    PostFormState form,
    Board board,
    Post? thread,
  ) async {
    final result = await showDialog<CaptchaPopValues>(
      context: context,
      builder: (context) {
        return CaptchaPage(board: board, thread: thread);
      },
    );

    final post = Post(
      name: form.nameController.text,
      sub: form.subjectController.text,
      com: form.commentController.text,
    );

    if (result != null) {
      if (thread == null) {
        try {
          await context.read<ThreadsCubit>().postThread(
                board: board,
                post: post,
                captcha: result.captcha,
                response: result.attempt,
                file: form.file,
              );
          context.read<PostFormCubit>().setVisible(false);
          ScaffoldMessenger.of(context).showSnackBar(
            successSnackbar(context, postSuccessful.tr()),
          );
        } on ChanException catch (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            errorSnackbar(context, error.errorMessage.removeHtmlTags),
          );
        }
      } else {
        try {
          await context.read<RepliesCubit>().postReply(
                board: board,
                post: post,
                resto: thread,
                captcha: result.captcha,
                response: result.attempt,
                file: form.file,
              );
          context.read<PostFormCubit>().setVisible(false);
          ScaffoldMessenger.of(context).showSnackBar(
            successSnackbar(context, postSuccessful.tr()),
          );
        } on ChanException catch (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            errorSnackbar(context, error.errorMessage.removeHtmlTags),
          );
        }
      }
    }
  }
}
