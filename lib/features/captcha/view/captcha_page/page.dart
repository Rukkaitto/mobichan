import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobichan/dependency_injector.dart';
import 'package:mobichan/features/captcha/captcha.dart';
import 'package:mobichan/features/core/core.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

class CaptchaPage extends StatelessWidget {
  final Board board;
  final Post? thread;
  final Post post;
  final XFile? file;
  final BuildContext formContext;

  const CaptchaPage(
      {required this.board,
      required this.post,
      required this.formContext,
      this.thread,
      this.file,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(formContext).cardColor,
      child: BlocProvider<CaptchaCubit>(
        create: (formContext) =>
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
              return buildLoaded(context, state.captcha);
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
}
