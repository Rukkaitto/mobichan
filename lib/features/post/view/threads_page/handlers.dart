import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobichan/features/post/post.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

import 'threads_page.dart';

extension ThreadsPageHandlers on ThreadsPage {
  Future<void> handleRefresh(BuildContext context, Sort sort) async {
    await context.read<ThreadsCubit>().getThreads(board, sort);
  }

  Future<void> handleThreadTap(
    BuildContext context,
    Board board,
    Post thread,
    Sort sort,
  ) async {
    await context.read<HistoryCubit>().addToHistory(thread, board);
    Navigator.of(context).pushNamed(
      ThreadPage.routeName,
      arguments: ThreadPageArguments(board: board, thread: thread),
    );
  }
}
