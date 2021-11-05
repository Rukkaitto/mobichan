import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobichan/constants.dart';
import 'package:mobichan/pages/boards/view/board_list_tile.dart';
import 'package:mobichan/pages/boards/cubit/boards_cubit/boards_cubit.dart';
import 'package:mobichan/pages/boards/cubit/search_cubit/search_cubit.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

class BoardList extends StatelessWidget {
  const BoardList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BoardsCubit, BoardsState>(
      listener: (context, state) {
        if (state is BoardsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            buildSnackBar(context, state),
          );
        }
      },
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

  SnackBar buildSnackBar(BuildContext context, BoardsError state) {
    return SnackBar(
      backgroundColor: Theme.of(context).errorColor,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      content: Text(
        state.message,
        style: snackbarTextStyle(context),
      ),
    );
  }

  Widget buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget buildLoaded(List<Board> boards) {
    return BlocListener<SearchCubit, SearchState>(
      listener: (context, state) {
        final boardsCubit = context.read<BoardsCubit>();
        if (state is Searching) {
          boardsCubit.search(state.input);
        }
        if (state is NotSearching) {
          boardsCubit.search('');
        }
      },
      child: buildListView(boards),
    );
  }

  ListView buildListView(List<Board> boards) {
    return ListView.builder(
      itemCount: boards.length,
      itemBuilder: (context, index) {
        Board board = boards[index];
        return BoardListTile(board);
      },
    );
  }
}
