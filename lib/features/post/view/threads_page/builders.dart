import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:mobichan/features/board/board.dart';
import 'package:mobichan/core/core.dart';
import 'package:mobichan/features/post/post.dart';
import 'package:mobichan/features/sort/sort.dart';
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
    return StaggeredGridView.builder(
      itemCount: threads.length,
      gridDelegate: SliverStaggeredGridDelegateWithFixedCrossAxisCount(
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
        crossAxisCount: Device.get().isTablet ? 3 : 2,
        staggeredTileBuilder: (index) => const StaggeredTile.fit(1),
      ),
      itemBuilder: (context, index) {
        return getItemBuilder(context, true, index, threads, sort);
      },
    );
  }

  Widget buildLoading() {
    return ListView.builder(
      itemBuilder: (context, index) =>
          ResponsiveWidth(child: ThreadWidget.shimmer),
    );
  }
}
