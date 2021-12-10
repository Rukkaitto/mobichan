import 'package:flutter/material.dart';
import 'package:mobichan/features/post/post.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

extension RepliesPageHandlers on RepliesPage {
  void handleClose(BuildContext context) {
    Navigator.of(context).pop();
  }

  void handleBack(
      BuildContext context, List<RepliesDialogState> repliesHistory) {
    if (repliesHistory.length > 1) {
      context.read<RepliesDialogCubit>().pop();
    } else {
      Navigator.of(context).pop();
    }
  }
}
