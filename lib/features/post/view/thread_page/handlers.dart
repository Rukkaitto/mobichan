import 'package:flutter/material.dart';
import 'package:mobichan/features/post/post.dart';
import 'package:mobichan_domain/mobichan_domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'thread_page.dart';

extension ThreadPageHandlers on ThreadPage {
  void handleRefresh(BuildContext context, Board board, Post thread) async {
    await context.read<RepliesCubit>().getReplies(board, thread);
  }
}
