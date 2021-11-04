import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobichan/constants.dart';
import 'package:mobichan/localization.dart';
import 'package:mobichan/pages/boards/view/board_list.dart';
import 'package:mobichan/pages/boards/cubit/boards_cubit/boards_cubit.dart';
import 'package:mobichan/pages/boards/cubit/search_cubit/search_cubit.dart';

class BoardsView extends StatelessWidget {
  static String routeName = BOARDS_LIST_ROUTE;

  const BoardsView({Key? key}) : super(key: key);

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
