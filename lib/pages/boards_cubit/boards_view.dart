import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobichan/classes/models/board.dart';
import 'package:mobichan/localization.dart';
import 'package:mobichan/pages/boards_cubit/cubit/boards_cubit.dart';
import 'package:easy_localization/easy_localization.dart';

class BoardsViewBloc extends StatelessWidget {
  const BoardsViewBloc({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BoardsCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(boards).tr(),
        ),
        body: BoardList(),
      ),
    );
  }
}

class BoardList extends StatelessWidget {
  const BoardList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final boardsCubit = context.read<BoardsCubit>();
    boardsCubit.getBoards();

    return BlocBuilder(
      builder: (context, state) {
        if (state is BoardsInitial) {
          return Container();
        } else if (state is BoardsLoading) {
          return buildLoading();
        } else if (state is BoardsLoaded) {
          return buildLoaded(state.boards);
        } else {
          return Container();
        }
      },
    );
  }

  Widget buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget buildLoaded(List<Board> boards) {
    return ListView.builder(
      itemCount: boards.length,
      itemBuilder: (context, index) {
        Board board = boards[index];
        return ListTile(
          title: Text('/${board.board}/ - ${board.title}'),
        );
      },
    );
  }
}
