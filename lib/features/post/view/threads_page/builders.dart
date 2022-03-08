import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:mobichan/features/board/board.dart';
import 'package:mobichan/core/core.dart';
import 'package:mobichan/features/post/post.dart';
import 'package:mobichan/features/sort/sort.dart';
import 'package:mobichan/localization.dart';
import 'package:mobichan_domain/mobichan_domain.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

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
      child: BlocBuilder<SortCubit, SortState>(
        builder: (context, state) {
          if (state is SortLoaded) {
            return RefreshIndicator(
              onRefresh: () => handleRefresh(context, state),
              child: Scrollbar(
                child: SettingProvider(
                  settingTitle: 'grid_view',
                  builder: (isGridView) {
                    return isGridView.value
                        ? getGridView(threads, sort)
                        : getListView(threads, sort);
                  },
                ),
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  void buildListener(BuildContext context, ThreadsState threadsState,
      List<int> threadsCountHistory) {
    if (threadsState is ThreadsError) {
      ScaffoldMessenger.of(context).showSnackBar(
        errorSnackbar(
          context,
          threadsState.message,
        ),
      );
    }
    if (threadsState is ThreadsLoaded) {
      if (!threadsState.shouldRefresh) return;
      final threads = threadsState.threads;
      threadsCountHistory.add(threads.length);
      final threadsCount = handleNewRepliesCount(threads, threadsCountHistory);
      if (threadsCount <= 0) return;
      ScaffoldMessenger.of(context).showSnackBar(
        successSnackbar(
          context,
          kLoadedThreads.plural(threadsCount),
        ),
      );
    }
  }

  Widget getListView(List<Post> threads, Sort sort) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemCount: threads.length,
      separatorBuilder: (context, index) => const Divider(
        height: 0,
        thickness: 1,
      ),
      itemBuilder: (context, index) {
        return getItemBuilder(context, false, index, threads, sort);
      },
    );
  }

  Widget getItemBuilder(
      context, bool inGrid, index, List<Post> threads, Sort sort) {
    Post thread = threads[index];
    return ResponsiveWidth(
      child: InkWell(
        onTap: () => handleThreadTap(context, board, thread, sort),
        child: Hero(
          tag: thread.no,
          child: ThreadWidget(
            thread: thread,
            board: board,
            inThread: false,
            inGrid: inGrid,
          ),
        ),
      ),
    );
  }

  Widget getGridView(List<Post> threads, Sort sort) {
    return Builder(builder: (context) {
      return Container(
        color: Theme.of(context).dividerColor,
        child: MasonryGridView.builder(
          itemCount: threads.length,
          mainAxisSpacing: 1,
          crossAxisSpacing: 1,
          gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: Device.get().isTablet ? 3 : 2,
          ),
          itemBuilder: (context, index) {
            return getItemBuilder(context, true, index, threads, sort);
          },
        ),
      );
    });
  }

  Widget buildLoading() {
    return ListView.builder(
      itemBuilder: (context, index) =>
          ResponsiveWidth(child: ThreadWidget.shimmer),
    );
  }
}
