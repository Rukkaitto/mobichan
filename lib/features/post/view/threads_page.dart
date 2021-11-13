import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobichan/dependency_injector.dart';
import 'package:mobichan/features/board/board.dart';
import 'package:mobichan/features/core/core.dart';
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
                return BlocProvider<ThreadsCubit>(
                  create: (context) =>
                      sl<ThreadsCubit>()..getThreads(board, sortState.sort),
                  child: BlocConsumer<ThreadsCubit, ThreadsState>(
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
                  ),
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

  Widget buildLoaded({
    required Board board,
    required List<Post> threads,
    required Sort sort,
  }) {
    return MultiBlocListener(
      listeners: [
        BlocListener<SearchCubit, SearchState>(
          listener: (context, state) {
            final threadsCubit = context.read<ThreadsCubit>();
            if (state is Searching) {
              threadsCubit.search(state.input);
            }
            if (state is NotSearching) {
              threadsCubit.search('');
            }
          },
        ),
        BlocListener<TabsCubit, TabsState>(
          listener: (context, state) {
            if (state is TabsLoaded) {
              context.read<ThreadsCubit>().getThreads(state.current, sort);
            }
          },
        ),
        BlocListener<SortCubit, SortState>(
          listener: (context, sortState) async {
            if (sortState is SortLoaded) {
              context.read<ThreadsCubit>().getThreads(board, sortState.sort);
            }
          },
        ),
      ],
      child: BlocBuilder<SortCubit, SortState>(
        builder: (context, state) {
          if (state is SortLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<ThreadsCubit>().getThreads(board, state.sort);
              },
              child: ListView.separated(
                physics: BouncingScrollPhysics(),
                itemCount: threads.length,
                separatorBuilder: (context, index) => const Divider(
                  height: 0,
                  thickness: 1,
                ),
                itemBuilder: (context, index) {
                  Post thread = threads[index];
                  return InkWell(
                    onTap: () async {
                      await context
                          .read<HistoryCubit>()
                          .addToHistory(thread, board);
                      Navigator.of(context).pushNamed(
                        ThreadPage.routeName,
                        arguments:
                            ThreadPageArguments(board: board, thread: thread),
                      );
                    },
                    child: Hero(
                      tag: thread.no,
                      child: ThreadWidget(
                        thread: thread,
                        board: board,
                        inThread: false,
                      ),
                    ),
                  );
                },
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget buildLoading() {
    return ListView.builder(
      itemBuilder: (context, index) => ThreadWidget.shimmer,
    );
  }
}
