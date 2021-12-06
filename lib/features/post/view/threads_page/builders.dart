import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobichan/features/board/board.dart';
import 'package:mobichan/core/core.dart';
import 'package:mobichan/core/widgets/responsive_width.dart';
import 'package:mobichan/features/post/post.dart';
import 'package:mobichan/features/sort/sort.dart';
import 'package:mobichan/localization.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

import 'threads_page.dart';

extension ThreadsPageBuilders on ThreadsPage {
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
      child: AsyncBlocBuilder<Sort, SortCubit, SortState, SortLoading,
          SortLoaded, SortError>(
        builder: (context, sort) {
          return RefreshIndicator(
            onRefresh: () => handleRefresh(context, sort),
            child: Scrollbar(
              child: SettingProvider(
                settingTitle: gridView,
                builder: (isGridView) {
                  return isGridView.value
                      ? const Center(
                          child: Text('your grid view here'),
                        )
                      : ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          itemCount: threads.length,
                          separatorBuilder: (context, index) => const Divider(
                            height: 0,
                            thickness: 1,
                          ),
                          itemBuilder: (context, index) {
                            Post thread = threads[index];
                            return ResponsiveWidth(
                              child: InkWell(
                                onTap: () => handleThreadTap(
                                    context, board, thread, sort),
                                child: Hero(
                                  tag: thread.no,
                                  child: ThreadWidget(
                                    thread: thread,
                                    board: board,
                                    inThread: false,
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                },
              ),
            ),
          );
        },
        loadingBuilder: () => Container(),
      ),
    );
  }

  Widget buildLoading() {
    return ListView.builder(
      itemBuilder: (context, index) =>
          ResponsiveWidth(child: ThreadWidget.shimmer),
    );
  }
}
