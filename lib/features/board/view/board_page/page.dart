import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobichan/dependency_injector.dart';
import 'package:mobichan/core/core.dart';
import 'package:mobichan/features/post/post.dart';
import 'package:mobichan/features/sort/sort.dart';
import 'package:mobichan/features/board/board.dart';

class BoardPage extends StatelessWidget {
  const BoardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SortCubit>(
          create: (_) => sl<SortCubit>()..getSort(),
        ),
        BlocProvider<PostFormCubit>(
          create: (_) => PostFormCubit(),
        ),
        BlocProvider<ThreadsCubit>(
          create: (_) => sl<ThreadsCubit>(),
        ),
        BlocProvider<FavoritesCubit>(
          create: (_) => sl<FavoritesCubit>()..getFavorites(),
        ),
      ],
      child: AsyncBlocBuilder<TabsLoadedArgs, TabsCubit, TabsState, TabsLoading,
          TabsLoaded, TabsError>(
        builder: (context, tabs) {
          return DefaultTabController(
            length: tabs.boards.length,
            initialIndex: tabs.currentIndex,
            child: BlocProvider<SearchCubit>(
              create: (context) => SearchCubit(),
              child: Scaffold(
                floatingActionButton: FloatingActionButton(
                  onPressed: () => handleFormButtonPressed(context),
                  child: const Icon(Icons.edit),
                ),
                drawer: const BoardDrawer(),
                appBar: buildAppBar(context, tabs.current),
                body: buildTabBarView(tabs.current, tabs.boards),
              ),
            ),
          );
        },
        loadingBuilder: () => Container(),
      ),
    );
  }
}
