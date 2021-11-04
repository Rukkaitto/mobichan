import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobichan/classes/models/board.dart';
import 'package:mobichan/localization.dart';
import 'package:mobichan/pages/boards_cubit_page/boards_cubit/boards_cubit.dart';
import 'package:mobichan/pages/boards_cubit_page/search_cubit/search_cubit.dart';

class BoardsViewBloc extends StatelessWidget {
  const BoardsViewBloc({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<BoardsCubit>(
          create: (context) => BoardsCubit()..getBoards(),
        ),
        BlocProvider<SearchCubit>(
          create: (context) => SearchCubit(),
        ),
      ],
      child: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          return Scaffold(
            appBar: buildAppBar(context, state),
            body: BoardList(),
          );
        },
      ),
    );
  }

  AppBar buildAppBar(BuildContext context, SearchState state) {
    final searchCubit = context.read<SearchCubit>();
    return AppBar(
      title: state is NotSearching
          ? Text(boards).tr()
          : buildTextField(searchCubit),
      leading: state is Searching ? BackButton() : null,
      actions: [
        IconButton(
          onPressed: () => searchCubit.startSearching(context),
          icon: Icon(Icons.search_rounded),
        ),
      ],
    );
  }

  TextField buildTextField(SearchCubit searchCubit) {
    return TextField(
      onChanged: (input) => searchCubit.updateInput(input),
      decoration: InputDecoration(
        hintText: search.tr(),
      ),
      autofocus: true,
    );
  }
}

class BoardList extends StatelessWidget {
  const BoardList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BoardsCubit, BoardsState>(
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
        return ListTile(
          title: Text(board.fullTitle),
          trailing: IconButton(
            onPressed: () {},
            icon: Icon(Icons.favorite_outline_rounded),
          ),
        );
      },
    );
  }
}
