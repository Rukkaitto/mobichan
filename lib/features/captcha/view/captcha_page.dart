import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobichan/dependency_injector.dart';
import 'package:mobichan/features/captcha/captcha.dart';
import 'package:mobichan/features/core/core.dart';
import 'package:mobichan/features/core/widgets/snackbars/success_snackbar.dart';
import 'package:mobichan/features/post/post.dart';
import 'package:mobichan/localization.dart';
import 'package:mobichan_data/mobichan_data.dart';
import 'package:mobichan_domain/mobichan_domain.dart';
import 'package:easy_localization/easy_localization.dart';

class CaptchaPage extends StatelessWidget {
  final Board board;
  final Post? thread;
  final Post post;
  final BuildContext context;

  const CaptchaPage(
      {required this.board,
      required this.post,
      required this.context,
      this.thread,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext dialogContext) {
    return Dialog(
      backgroundColor: Theme.of(context).cardColor,
      child: BlocProvider<CaptchaCubit>(
        create: (context) =>
            sl<CaptchaCubit>()..getCaptchaChallenge(board, thread),
        child: BlocConsumer<CaptchaCubit, CaptchaState>(
          listener: (context, state) {
            if (state is CaptchaError) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context)
                  .showSnackBar(errorSnackbar(context, state.message));
            }
          },
          builder: (context, state) {
            if (state is CaptchaLoaded) {
              return buildLoaded(state.captcha);
            } else if (state is CaptchaLoading) {
              return buildLoading();
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  void onValidate(
    BuildContext context,
    CaptchaChallenge captcha,
    String attempt,
  ) async {
    if (thread == null) {
      try {
        await context
            .read<ThreadsCubit>()
            .postThread(board, post, captcha, attempt);
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
        await context
            .read<RepliesCubit>()
            .postReply(board, post, thread!, captcha, attempt);
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

  Widget buildLoaded(CaptchaChallenge challenge) {
    return CaptchaSliderWidget(
      backgroundImage: Image.memory(base64Decode(challenge.backgroundImage)),
      foregroundImage: Image.memory(base64Decode(challenge.foregroundImage)),
      captchaChallenge: challenge,
      onValidate: (attempt) => onValidate(context, challenge, attempt),
    );
  }

  Widget buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
