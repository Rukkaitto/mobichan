import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobichan/features/post/post.dart';
import 'package:mobichan/features/sort/sort.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

extension ThreadsPageHandlers on ThreadsPage {
  Future<void> handleRefresh(BuildContext context, SortLoaded state) async {
    await context.read<ThreadsCubit>().getThreads(board, state.sort);
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

  int handleNewRepliesCount(List<Post> threads, List<int> threadsCountHistory) {
    if (threadsCountHistory.isEmpty || threadsCountHistory.length == 1) {
      return threads.length;
    }
    final last = threadsCountHistory.last;
    final beforeLast =
        threadsCountHistory.elementAt(threadsCountHistory.length - 2);
    final newRepliesCount = last - beforeLast;
    return newRepliesCount;
  }
}
