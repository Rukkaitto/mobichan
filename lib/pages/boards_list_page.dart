import 'package:flutter/material.dart';
import 'package:mobichan/api/api.dart';
import 'package:mobichan/classes/models/board.dart';
import 'package:mobichan/classes/arguments/board_page_arguments.dart';
import 'package:mobichan/constants.dart';
import 'package:mobichan/pages/board_page.dart';
import 'package:mobichan/utils/utils.dart';

class BoardsListPage extends StatefulWidget {
  static const routeName = BOARDS_LIST_ROUTE;
  const BoardsListPage({Key? key}) : super(key: key);

  @override
  _BoardsListPageState createState() => _BoardsListPageState();
}

class _BoardsListPageState extends State<BoardsListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Boards'),
      ),
      body: buildFutureBuilder(),
    );
  }

  FutureBuilder<List<Board>> buildFutureBuilder() {
    return FutureBuilder<List<Board>>(
      future: Api.fetchBoards(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Board board = snapshot.data![index];
              return BoardListTile(board: board);
            },
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class BoardListTile extends StatelessWidget {
  const BoardListTile({
    Key? key,
    required this.board,
  }) : super(key: key);

  final Board board;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('/${board.board}/ - ${board.title}'),
      onTap: () {
        Utils.saveLastVisitedBoard(board: board.board, title: board.title);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BoardPage(
              args: BoardPageArguments(board: board.board, title: board.title),
            ),
          ),
        );
      },
    );
  }
}
