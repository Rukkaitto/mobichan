import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobichan/dependency_injector.dart';
import 'package:mobichan/features/core/core.dart';
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
        BlocProvider<HistoryCubit>(
          create: (_) => sl<HistoryCubit>()..getHistory(),
        ),
        BlocProvider<PostFormCubit>(
          create: (_) => PostFormCubit(),
        ),
        BlocProvider<ThreadsCubit>(
          create: (_) => sl<ThreadsCubit>(),
        ),
      ],
      child: BlocBuilder<TabsCubit, TabsState>(
        builder: (context, state) {
          if (state is TabsLoaded) {
            return DefaultTabController(
              length: state.boards.length,
              initialIndex: state.currentIndex,
              child: BlocProvider<SearchCubit>(
                create: (context) => SearchCubit(),
                child: Scaffold(
                  floatingActionButton: FloatingActionButton(
                    onPressed: () => handleFormButtonPressed(context),
                    child: Icon(Icons.edit),
                  ),
                  drawer: BoardDrawer(),
                  appBar: buildAppBar(context),
                  body: buildTabBarView(state.current, state.boards),
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
}
