import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobichan/api/api.dart';
import 'package:mobichan/classes/arguments/board_page_arguments.dart';
import 'package:mobichan/classes/arguments/thread_page_arguments.dart';
import 'package:mobichan/classes/models/board.dart';
import 'package:mobichan/classes/models/post.dart';
import 'package:mobichan/enums/enums.dart';
import 'package:mobichan/extensions/string_extension.dart';
import 'package:mobichan/localization.dart';
import 'package:mobichan/pages/thread_page.dart';
import 'package:mobichan/utils/utils.dart';
import 'package:mobichan/widgets/drawer_widget/drawer_widget.dart';
import 'package:mobichan/widgets/form_widget/form_widget.dart';
import 'package:mobichan/widgets/thread_widget/thread_widget.dart';

class BoardPage extends StatefulWidget {
  static const routeName = '/board';
  final BoardPageArguments args;
  const BoardPage({Key? key, required this.args}) : super(key: key);

  @override
  _BoardPageState createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> {
  late Future<List<Post>> _futureOPs;
  bool _postFormIsOpened = false;
  bool _isSearching = false;
  String _searchQuery = '';
  Sort _sortingOrder = Sort.byBumpOrder;
  late TextEditingController _searchQueryController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _searchQueryController = TextEditingController();
    _refresh(Utils.getLastSortingOrder());
    Utils.saveLastVisitedBoard(
      board: widget.args.board,
      title: widget.args.title,
      wsBoard: widget.args.wsBoard,
    );
  }

  void _onPressPostActionButton() {
    setState(() {
      _postFormIsOpened = !_postFormIsOpened;
    });
  }

  Future<void> _refresh(Future<Sort> sorting) async {
    _futureOPs =
        Api.fetchOPs(board: widget.args.board, sorting: Sort.byBumpOrder);
    sorting.then((value) {
      setState(() {
        _futureOPs = Api.fetchOPs(board: widget.args.board, sorting: value);
        _sortingOrder = value;
      });
    });
  }

  void _onCloseForm() {
    setState(() {
      _postFormIsOpened = false;
    });
  }

  void _onFormPost(Response<String> response) async {
    _onCloseForm();
    await _refresh(Utils.getLastSortingOrder());
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
    if (_searchQuery == "") {
      return true;
    }
    if (field == null) {
      return false;
    }
    return field.toLowerCase().contains(_searchQuery.toLowerCase());
  }

  PopupMenuItem _buildPopupMenuItem(String title, Sort sorting) {
    return PopupMenuItem(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title).tr(),
          if (sorting == _sortingOrder)
            Icon(
              Icons.check_rounded,
              size: 20,
            ),
        ],
      ),
      value: sorting,
    );
  }

  PopupMenuButton<dynamic> _buildPopupMenuButton() {
    return PopupMenuButton(
      onSelected: (sorting) {
        Utils.saveLastSortingOrder(sorting);
        setState(() {
          _refresh(Future.value(sorting));
        });
      },
      itemBuilder: (context) {
        return <PopupMenuEntry>[
          _buildPopupMenuItem('sort_bump_order', Sort.byBumpOrder),
          _buildPopupMenuItem('sort_replies', Sort.byReplyCount),
          _buildPopupMenuItem('sort_images', Sort.byImagesCount),
          _buildPopupMenuItem('sort_newest', Sort.byNewest),
          _buildPopupMenuItem('sort_oldest', Sort.byOldest),
        ];
      },
    );
  }

  Widget Function(BuildContext, int) _gridViewItemBuilder(List<Post> threads) {
    return (BuildContext context, int index) {
      Post op = threads[index];
      return ThreadWidget(
        post: op,
        board: widget.args.board,
        onTap: () {
          Utils.addThreadToHistory(op, widget.args.board);
          Navigator.push(
            context,
            MaterialPageRoute(
              settings: RouteSettings(name: ThreadPage.routeName),
              builder: (context) => ThreadPage(
                args: ThreadPageArguments(
                  board: widget.args.board,
                  thread: op.no,
                  title:
                      op.sub ?? op.com?.replaceBrWithSpace.removeHtmlTags ?? '',
                ),
              ),
            ),
          );
        },
      );
    };
  }

  void _addToFavorites() async {
    setState(() {
      Utils.addBoardToFavorites(
        Board(
          board: widget.args.board,
          title: widget.args.title,
          wsBoard: widget.args.wsBoard,
        ),
      );
    });
  }

  void _removeFromFavorites() async {
    setState(() {
      Utils.removeBoardFromFavorites(
        Board(
          board: widget.args.board,
          title: widget.args.title,
          wsBoard: widget.args.wsBoard,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerWidget(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit_rounded),
        onPressed: _onPressPostActionButton,
      ),
      appBar: AppBar(
        leading: _isSearching ? BackButton() : null,
        actions: [
          IconButton(
            onPressed: _startSearching,
            icon: Icon(Icons.search_rounded),
          ),
          FutureBuilder(
            future: Utils.isBoardInFavorites(
              Board(
                board: widget.args.board,
                title: widget.args.title,
                wsBoard: widget.args.wsBoard,
              ),
            ),
            builder: (context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.hasData) {
                final isInFavorites = snapshot.data!;
                return IconButton(
                  onPressed:
                      isInFavorites ? _removeFromFavorites : _addToFavorites,
                  icon: Icon(
                    isInFavorites
                        ? Icons.favorite_rounded
                        : Icons.favorite_outline_rounded,
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
          _buildPopupMenuButton()
        ],
        title: _isSearching
            ? TextField(
                controller: _searchQueryController,
                onChanged: _updateSearchQuery,
                decoration: InputDecoration(
                  hintText: search.tr(),
                ),
                autofocus: true,
              )
            : Text('/${widget.args.board}/ - ${widget.args.title}'),
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () => _refresh(Utils.getLastSortingOrder()),
            child: buildFutureBuilder(),
          ),
          FormWidget(
            postType: PostType.thread,
            board: widget.args.board,
            isOpened: _postFormIsOpened,
            onPost: _onFormPost,
            onClose: _onCloseForm,
            commentFieldController: TextEditingController(),
          ),
        ],
      ),
    );
  }

  FutureBuilder<List<Post>> buildFutureBuilder() {
    return FutureBuilder<List<Post>>(
      future: _futureOPs,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Post> filteredThreads = snapshot.data!
              .where((thread) =>
                  _matchesSearchQuery(thread.com) ||
                  _matchesSearchQuery(thread.sub))
              .toList();

          return Scrollbar(
            controller: _scrollController,
            child: Padding(
              padding: EdgeInsets.all(8),
              child: GridView.builder(
                  addAutomaticKeepAlives: true,
                  controller: _scrollController,
                  itemCount: filteredThreads.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    crossAxisCount: 2,
                    childAspectRatio: 4 / 3,
                  ),
                  itemBuilder: _gridViewItemBuilder(filteredThreads)),
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
