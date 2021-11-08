import 'package:configurable_expansion_tile_null_safety/configurable_expansion_tile.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobichan/dependency_injector.dart';
import 'package:mobichan/localization.dart';

import 'package:mobichan/features/board/board.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

class BoardDrawer extends StatelessWidget {
  const BoardDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildMenuList(context),
            buildVersionInfo(),
          ],
        ),
      ),
    );
  }

  Container buildVersionInfo() {
    return Container(
      padding: EdgeInsets.all(10.0),
      width: double.infinity,
      child: Text('test'),
    );
  }

  ListView buildMenuList(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        ConfigurableExpansionTile(
          header: Expanded(
            child: Row(
              children: [
                Icon(Icons.list),
                Text(boards).tr(),
              ],
            ),
          ),
          children: [
            BlocProvider<BoardsCubit>(
              create: (context) => sl<BoardsCubit>()..getBoards(),
              child: BlocBuilder<BoardsCubit, BoardsState>(
                builder: (context, state) {
                  if (state is BoardsLoaded) {
                    return buildBoards(state.boards);
                  } else {
                    return buildLoading();
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  SizedBox buildBoards(List<Board> boards) {
    return SizedBox(
      height: 500.0,
      child: ListView.builder(
        itemCount: boards.length,
        itemBuilder: (context, index) {
          Board board = boards[index];
          return ListTile(
            title: RichText(
              text: TextSpan(
                text: board.title,
                children: <TextSpan>[
                  TextSpan(
                    text: ' /${board.board}/',
                    style: TextStyle(color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),
            trailing: IconButton(
              onPressed: () {},
              icon: Icon(Icons.favorite_border),
            ),
          );
        },
      ),
    );
  }

  Widget buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
