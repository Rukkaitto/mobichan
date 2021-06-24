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
  late Future<List<Board>> futureBoards;

  @override
  void initState() {
    super.initState();
    futureBoards = Api.fetchBoards();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Boards'),
      ),
      body: FutureBuilder<List<Board>>(
        future: futureBoards,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Board board = snapshot.data![index];
                return ListTile(
                  title: Text('/${board.board}/ - ${board.title}'),
                  onTap: () {
                    Utils.saveLastVisitedBoard(
                        board: board.board, title: board.title);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BoardPage(
                          args: BoardPageArguments(
                              board: board.board, title: board.title),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
