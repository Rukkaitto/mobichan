import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobichan/core/widgets/async_bloc_builder.dart';
import 'package:mobichan/features/board/board.dart';
import 'package:mobichan/features/post/post.dart';
import 'package:mobichan/features/sort/sort.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

class ThreadsPage extends StatelessWidget {
  final Board board;
  const ThreadsPage(this.board, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AsyncBlocBuilder<TabsLoadedArgs, TabsCubit, TabsState, TabsLoading,
        TabsLoaded, TabsError>(
      builder: (context, tabs) {
        return AsyncBlocBuilder<Sort, SortCubit, SortState, SortLoading,
            SortLoaded, SortError>(
          builder: (context, sort) {
            context.read<ThreadsCubit>().getThreads(tabs.current, sort);
            return AsyncBlocBuilder<List<Post>, ThreadsCubit, ThreadsState,
                ThreadsLoading, ThreadsLoaded, ThreadsError>(
              builder: (context, threads) {
                return buildLoaded(
                  board: board,
                  threads: threads,
                  sort: sort,
                );
              },
              loadingBuilder: () => buildLoading(),
            );
          },
        );
      },
    );
  }
}
