import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobichan/api/api.dart';
import 'package:mobichan/classes/arguments/board_page_arguments.dart';
import 'package:mobichan/classes/models/board.dart';
import 'package:mobichan/constants.dart';
import 'package:mobichan/localization.dart';
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
  bool _isSearching = false;
  String _searchQuery = '';
  late TextEditingController _searchQueryController;

  @override
  void initState() {
    _searchQueryController = TextEditingController();
    super.initState();
  }

  void _startSearching() {
    setState(() {
      ModalRoute.of(context)!
          .addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));
      _isSearching = true;
    });
  }

  void _stopSearching() {
    _clearSearchQuery();
    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearchQuery() {
    setState(() {
      _searchQueryController.clear();
      _updateSearchQuery('');
    });
  }

  void _updateSearchQuery(String newQuery) {
    setState(() {
      _searchQuery = newQuery;
    });
  }

  bool _matchesSearchQuery(String? field) {
    if (field == null) {
      return false;
    }
    return field.toLowerCase().contains(_searchQuery.toLowerCase());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchQueryController,
                onChanged: _updateSearchQuery,
                decoration: InputDecoration(
                  hintText: search.tr(),
                ),
                autofocus: true,
              )
            : Text(boards).tr(),
        leading: _isSearching ? BackButton() : null,
        actions: [
          IconButton(
            onPressed: _startSearching,
            icon: Icon(Icons.search_rounded),
          ),
        ],
      ),
      body: buildFutureBuilder(),
    );
  }

  FutureBuilder<List<Board>> buildFutureBuilder() {
    return FutureBuilder<List<Board>>(
      future: Api.fetchBoards(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Board> filteredBoards = snapshot.data!
              .where((board) =>
                  _matchesSearchQuery(board.board) ||
                  _matchesSearchQuery(board.title))
              .toList();
          return Scrollbar(
            controller: _scrollController,
            child: SingleChildScrollView(
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                controller: _scrollController,
                itemCount: filteredBoards.length,
                itemBuilder: (context, index) {
                  Board board = filteredBoards[index];
                  return BoardListTile(
                    board: board,
                  );
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
          wsBoard: widget.board.wsBoard,
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
          wsBoard: widget.board.wsBoard,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Utils.isBoardInFavorites(
        Board(
            board: widget.board.board,
            title: widget.board.title,
            wsBoard: widget.board.wsBoard),
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
                  board: widget.board.board,
                  title: widget.board.title,
                  wsBoard: widget.board.wsBoard);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BoardPage(
                    args: BoardPageArguments(
                        board: widget.board.board,
                        title: widget.board.title,
                        wsBoard: widget.board.wsBoard),
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
