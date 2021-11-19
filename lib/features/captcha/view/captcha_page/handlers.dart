import 'package:flutter/material.dart';
import 'package:mobichan/features/captcha/captcha.dart';
import 'package:mobichan/features/core/core.dart';
import 'package:mobichan/features/core/widgets/snackbars/success_snackbar.dart';
import 'package:mobichan/features/post/post.dart';
import 'package:mobichan/localization.dart';
import 'package:mobichan_data/mobichan_data.dart';
import 'package:mobichan_domain/mobichan_domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

extension CaptchaPageHandlers on CaptchaPage {
  void handleOnValidate(
    BuildContext context,
    CaptchaChallenge captcha,
    String attempt,
  ) async {
    if (thread == null) {
      try {
        await context.read<ThreadsCubit>().postThread(
              board: board,
              post: post,
              captcha: captcha,
              response: attempt,
              file: file,
            );
        ScaffoldMessenger.of(context).showSnackBar(
          successSnackbar(context, post_successful.tr()),
        );
        context.read<PostFormCubit>().setVisible(false);
      } on ChanException catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          errorSnackbar(context, error.errorMessage.removeHtmlTags),
        );
      }
      Navigator.of(context).pop();
    } else {
      try {
        await context.read<RepliesCubit>().postReply(
              board: board,
              post: post,
              resto: thread!,
              captcha: captcha,
              response: attempt,
              file: file,
            );
        ScaffoldMessenger.of(context).showSnackBar(
          successSnackbar(context, post_successful.tr()),
        );
        context.read<PostFormCubit>().setVisible(false);
      } on ChanException catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          errorSnackbar(context, error.errorMessage.removeHtmlTags),
        );
      }
      Navigator.of(context).pop();
    }
  }
}
