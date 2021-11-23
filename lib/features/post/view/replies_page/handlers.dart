import 'package:flutter/material.dart';
import 'package:mobichan/features/post/post.dart';
import 'package:mobichan_domain/mobichan_domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'replies_page.dart';

extension RepliesPageHandlers on RepliesPage {
  void handleClose(BuildContext context) {
    Navigator.of(context).pop();
  }

  void handleBack(BuildContext context, List<List<Post>> repliesHistory) {
    if (repliesHistory.length > 1) {
      context.read<RepliesDialogCubit>().pop();
    } else {
      Navigator.of(context).pop();
    }
  }
}
