import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobichan/classes/arguments/board_page_arguments.dart';
import 'package:mobichan/classes/arguments/thread_page_arguments.dart';
import 'package:mobichan/enums/enums.dart';
import 'package:mobichan/localization.dart';
import 'package:mobichan/pages/thread_page.dart';
import 'package:mobichan/widgets/drawer/view/drawer_view.dart';
import 'package:mobichan/widgets/form_widget/form_widget.dart';
import 'package:mobichan/widgets/thread_widget/thread_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

class BoardPage extends StatefulWidget {
  static const routeName = '/board';
  final BoardPageArguments args;
  const BoardPage({Key? key, required this.args}) : super(key: key);

  @override
  _BoardPageState createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> {
  Future<List<Post>>? _futureOPs;
  bool _postFormIsOpened = false;
  bool _isSearching = false;
  String _searchQuery = '';
  late Sort _sort;
  late TextEditingController _searchQueryController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _searchQueryController = TextEditingController();
    _refresh();
    context.read<BoardRepository>().saveLastVisitedBoard(widget.args.board);
    super.initState();
  }

  void _onPressPostActionButton() {
    setState(() {
      _postFormIsOpened = !_postFormIsOpened;
    });
  }

  Future<void> _refresh() async {
    final postRepository = context.read<PostRepository>();
    final sortRepository = context.read<SortRepository>();
    Sort sort = await sortRepository.getLastSort();
    setState(() {
      _sort = sort;
      _futureOPs = postRepository.getThreads(
        board: widget.args.board,
        sort: sort,
      );
    });
  }

  void _onCloseForm() {
    setState(() {
      _postFormIsOpened = false;
    });
  }

  void _onFormPost() async {
    _onCloseForm();
    await _refresh();
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

  PopupMenuItem _buildPopupMenuItem(String title, Sort sort) {
    return PopupMenuItem(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title).tr(),
          if (sort.order == _sort.order)
            const Icon(
              Icons.check_rounded,
              size: 20,
            ),
        ],
      ),
      value: sort,
    );
  }

  PopupMenuButton<dynamic> _buildPopupMenuButton() {
    return PopupMenuButton(
      icon: const Icon(Icons.sort),
      onSelected: (sort) {
        context.read<SortRepository>().saveSort(sort);
        _refresh();
      },
      itemBuilder: (context) {
        return <PopupMenuEntry>[
          _buildPopupMenuItem(sortBumpOrder, const Sort(order: Order.byBump)),
          _buildPopupMenuItem(sortReplies, const Sort(order: Order.byReplies)),
          _buildPopupMenuItem(sortImages, const Sort(order: Order.byImages)),
          _buildPopupMenuItem(sortNewest, const Sort(order: Order.byNew)),
          _buildPopupMenuItem(sortOldest, const Sort(order: Order.byOld)),
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
          context
              .read<PostRepository>()
              .addThreadToHistory(op, widget.args.board);
          Navigator.push(
            context,
            MaterialPageRoute(
              settings: const RouteSettings(name: ThreadPage.routeName),
              builder: (context) => ThreadPage(
                args: ThreadPageArguments(
                  board: widget.args.board,
                  thread: op,
                ),
              ),
            ),
          );
        },
      );
    };
  }

  void _addToFavorites() async {
    setState(
      () {
        context.read<BoardRepository>().addBoardToFavorites(widget.args.board);
      },
    );
  }

  void _removeFromFavorites() async {
    setState(
      () {
        context
            .read<BoardRepository>()
            .removeBoardFromFavorites(widget.args.board);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerView(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.edit_rounded),
        onPressed: _onPressPostActionButton,
      ),
      appBar: AppBar(
        leading: _isSearching ? const BackButton() : null,
        actions: [
          IconButton(
            onPressed: _startSearching,
            icon: const Icon(Icons.search_rounded),
          ),
          FutureBuilder(
            future: context
                .read<BoardRepository>()
                .isBoardInFavorites(widget.args.board),
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
            : Text(widget.args.board.title),
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () => _refresh(),
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
              padding: const EdgeInsets.all(8),
              child: GridView.builder(
                  addAutomaticKeepAlives: true,
                  controller: _scrollController,
                  itemCount: filteredThreads.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
