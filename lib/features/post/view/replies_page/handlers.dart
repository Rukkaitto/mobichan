import 'package:flutter/material.dart';
import 'package:mobichan/features/post/post.dart';

import 'replies_page.dart';

extension RepliesPageHandlers on RepliesPage {
  void handleClose(BuildContext context) {
    Navigator.popUntil(context, ModalRoute.withName(ThreadPage.routeName));
  }
}
