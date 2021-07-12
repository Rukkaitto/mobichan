import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
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
  ScrollController _scrollController = ScrollController();

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
          return Scrollbar(
            controller: _scrollController,
            child: SingleChildScrollView(
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                controller: _scrollController,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Board board = snapshot.data![index];
                  return BoardListTile(board: board);
                },
              ),
            ),
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

class BoardListTile extends StatefulWidget {
  const BoardListTile({
    Key? key,
    required this.board,
  }) : super(key: key);

  final Board board;

  @override
  _BoardListTileState createState() => _BoardListTileState();
}

class _BoardListTileState extends State<BoardListTile> {
  void _addToFavorites() async {
    setState(() {
      Utils.addBoardToFavorites(
        Board(
          board: widget.board.board,
          title: widget.board.title,
        ),
      );
    });
  }

  void _removeFromFavorites() async {
    setState(() {
      Utils.removeBoardFromFavorites(
        Board(
          board: widget.board.board,
          title: widget.board.title,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Utils.isBoardInFavorites(
        Board(board: widget.board.board, title: widget.board.title),
      ),
      builder: (context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData) {
          final isInFavorites = snapshot.data!;
          return ListTile(
            trailing: IconButton(
              onPressed: isInFavorites ? _removeFromFavorites : _addToFavorites,
              icon: Icon(
                isInFavorites
                    ? Icons.favorite_rounded
                    : Icons.favorite_outline_rounded,
              ),
            ),
            title: Text('/${widget.board.board}/ - ${widget.board.title}'),
            onTap: () {
              Utils.saveLastVisitedBoard(
                  board: widget.board.board, title: widget.board.title);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BoardPage(
                    args: BoardPageArguments(
                        board: widget.board.board, title: widget.board.title),
                  ),
                ),
              );
            },
          );
        } else {
          return Container();
        }
      },
    );
  }
}
