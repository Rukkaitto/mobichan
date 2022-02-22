import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobichan/features/board/board.dart';
import 'package:mobichan/core/core.dart';
import 'package:mobichan/features/post/post.dart';
import 'package:mobichan/features/sort/sort.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

class ThreadsPage extends StatelessWidget {
  final Board board;
  const ThreadsPage(this.board, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TabsCubit, TabsState>(
      builder: (context, tabsState) {
        if (tabsState is TabsLoaded) {
          return BlocBuilder<SortCubit, SortState>(
            builder: (context, sortState) {
              if (sortState is SortLoaded) {
                context.read<ThreadsCubit>().getThreads(board, sortState.sort);
                return BlocConsumer<ThreadsCubit, ThreadsState>(
                  listener: (context, threadsState) {
                    if (threadsState is ThreadsError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        errorSnackbar(
                          context,
                          threadsState.message,
                        ),
                      );
                    }
                  },
                  builder: (context, threadsState) {
                    if (threadsState is ThreadsLoaded) {
                      return buildLoaded(
                        board: board,
                        threads: threadsState.threads,
                        sort: sortState.sort,
                      );
                    } else {
                      return buildLoading();
                    }
                  },
                );
              } else {
                return Container();
              }
            },
          );
        } else {
          return Container();
        }
      },
    );
  }
}
