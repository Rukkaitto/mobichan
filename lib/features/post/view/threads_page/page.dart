import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobichan/features/board/board.dart';
import 'package:mobichan/core/core.dart';
import 'package:mobichan/features/post/post.dart';
import 'package:mobichan/features/sort/sort.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

class ThreadsPage extends StatefulWidget {
  final Board board;
  const ThreadsPage(this.board, {Key? key}) : super(key: key);

  @override
  State<ThreadsPage> createState() => _ThreadsPageState();
}

class _ThreadsPageState extends State<ThreadsPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<TabsCubit, TabsState>(
      builder: (context, tabsState) {
        if (tabsState is TabsLoaded) {
          return BlocBuilder<SortCubit, SortState>(
            builder: (context, sortState) {
              if (sortState is SortLoaded) {
                context
                    .read<ThreadsCubit>()
                    .getThreads(tabsState.current, sortState.sort);
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
                      return widget.buildLoaded(
                        board: widget.board,
                        threads: threadsState.threads,
                        sort: sortState.sort,
                      );
                    } else {
                      return widget.buildLoading();
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

  @override
  bool get wantKeepAlive => true;
}
