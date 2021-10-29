import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobichan/api/api.dart';
import 'package:mobichan/classes/arguments/thread_page_arguments.dart';
import 'package:mobichan/classes/models/post.dart';
import 'package:mobichan/enums/enums.dart';
import 'package:mobichan/extensions/string_extension.dart';
import 'package:mobichan/localization.dart';
import 'package:mobichan/pages/gallery_page.dart';
import 'package:mobichan/utils/utils.dart';
import 'package:mobichan/widgets/form_widget/form_widget.dart';
import 'package:mobichan/widgets/post_widget/post_widget.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class ThreadPage extends StatefulWidget {
  static const routeName = THREAD_ROUTE;
  final ThreadPageArguments args;
  const ThreadPage({Key? key, required this.args}) : super(key: key);

  @override
  _ThreadPageState createState() => _ThreadPageState();
}

class _ThreadPageState extends State<ThreadPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _commentFieldController = TextEditingController();
  late Future<List<Post>> _futurePosts;
  bool _postFormIsOpened = false;
  List<Post> imagePosts = [];
  List<String> imageThumbnailUrls = [];
  bool _isSearching = false;
  String _searchQuery = '';
  late TextEditingController _searchQueryController;

  @override
  void initState() {
    super.initState();
    _searchQueryController = TextEditingController();
    _refresh();
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

  Future<void> _refresh() async {
    setState(() {
      _futurePosts =
          Api.fetchPosts(board: widget.args.board, thread: widget.args.thread);
    });
  }

  void onPressPostActionButton() {
    setState(() {
      _postFormIsOpened = !_postFormIsOpened;
    });
  }

  void _onCloseForm() {
    setState(() {
      _postFormIsOpened = false;
    });
  }

  void _onFormPost(Response<String> response) async {
    _onCloseForm();
    await _refresh();
  }

  void _onPostNoTap(int no) {
    _commentFieldController.text += ">>$no\n";
    setState(() {
      _postFormIsOpened = true;
    });
  }

  void _onPostQuote(String quote, int postId) {
    if (_commentFieldController.text.isEmpty) {
      _commentFieldController.text += ">>$postId\n";
    }
    _commentFieldController.text += ">$quote\n";
    setState(() {
      _postFormIsOpened = true;
    });
  }

  List<Post> _getImagePosts(List<Post> posts) {
    List<Post> images = [];

    for (Post post in posts) {
      if (post.tim != null) {
        images.add(post);
      }
    }

    return images;
  }

  List<String> _getImageUrls(List<Post> posts) {
    List<String> imageUrls = [];

    for (Post post in posts) {
      if (post.tim != null) {
        imageUrls.add(post.getImageUrl(widget.args.board));
      }
    }

    return imageUrls;
  }

  List<String> _getImageThumbnailUrls(List<Post> posts) {
    List<String> imageUrls = [];

    for (Post post in posts) {
      if (post.tim != null) {
        imageUrls.add(post.getThumbnailUrl(widget.args.board));
      }
    }

    return imageUrls;
  }

  void _gotoGalleryView() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return GalleryPage(
        imagePosts: imagePosts,
        board: widget.args.board,
        imageThumbnailUrlList: imageThumbnailUrls,
      );
    }));
  }

  Widget Function(BuildContext, int) _listViewItemBuilder(List<Post> replies) {
    return (context, index) {
      Post post = replies[index];
      return Padding(
        padding: EdgeInsets.only(left: 8, top: 8, right: 8),
        child: PostWidget(
          post: post,
          board: widget.args.board,
          threadReplies: replies,
          imageIndex: imagePosts.indexOf(post),
          onPostNoTap: _onPostNoTap,
        ),
      );
    };
  }

  PopupMenuButton<dynamic> _buildPopupMenuButton() {
    return PopupMenuButton(
      onSelected: (selection) {
        switch (selection) {
          case 'refresh':
            _refresh();
            break;
          case 'share':
            Share.share(
                'https://boards.4channel.org/${widget.args.board}/thread/${widget.args.thread}');
            break;
          case 'top':
            _scrollController
                .jumpTo(_scrollController.position.minScrollExtent);
            break;
          case 'bottom':
            _scrollController
                .jumpTo(_scrollController.position.maxScrollExtent);
            break;
        }
      },
      itemBuilder: (context) {
        return <PopupMenuEntry>[
          PopupMenuItem(
            child: Text(refresh).tr(),
            value: 'refresh',
          ),
          PopupMenuItem(
            child: Text(share).tr(),
            value: 'share',
          ),
          PopupMenuItem(
            child: Text(go_top).tr(),
            value: 'top',
          ),
          PopupMenuItem(
            child: Text(go_bottom).tr(),
            value: 'bottom',
          ),
        ];
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit_rounded),
        onPressed: onPressPostActionButton,
      ),
      appBar: AppBar(
        leading: _isSearching ? BackButton() : null,
        title: _isSearching
            ? TextField(
                controller: _searchQueryController,
                onChanged: _updateSearchQuery,
                decoration: InputDecoration(
                  hintText: search.tr(),
                ),
                autofocus: true,
              )
            : Text(widget.args.title.unescapeHtml),
        actions: <Widget>[
          IconButton(
            onPressed: _startSearching,
            icon: Icon(Icons.search_rounded),
          ),
          IconButton(onPressed: _gotoGalleryView, icon: Icon(Icons.image)),
          _buildPopupMenuButton(),
        ],
      ),
      body: Stack(
        children: [
          FutureBuilder(
              future: SharedPreferences.getInstance(),
              builder: (context, AsyncSnapshot<SharedPreferences> snapshot) {
                if (snapshot.hasData) {
                  final prefs = snapshot.data!;
                  return RefreshIndicator(
                    onRefresh: _refresh,
                    child: !prefs.containsKey("SHOW_NESTED_REPLIES")
                        ? buildFutureBuilder()
                        : (prefs.getString("SHOW_NESTED_REPLIES")!.parseBool()
                            ? buildNestedFutureBuilder()
                            : buildFutureBuilder()),
                  );
                } else {
                  return Container();
                }
              }),
          FormWidget(
            postType: PostType.reply,
            board: widget.args.board,
            thread: widget.args.thread,
            isOpened: _postFormIsOpened,
            onPost: _onFormPost,
            onClose: _onCloseForm,
            commentFieldController: _commentFieldController,
          ),
        ],
      ),
    );
  }

  Widget recursiveWidget(Post post, List<Post> posts, int depth) {
    List<Post> replies = Utils.getReplies(posts, post);
    final maxDepth = 5;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 8, top: 8, right: 8),
          child: PostWidget(
            post: post,
            board: widget.args.board,
            threadReplies: posts,
            showReplies: depth > maxDepth,
            onPostNoTap: _onPostNoTap,
            onPostQuote: _onPostQuote,
            imageIndex: imagePosts.indexOf(post),
          ),
        ),
        Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 15),
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                primary: false,
                shrinkWrap: true,
                itemCount: replies.length,
                itemBuilder: (context, index) {
                  Post reply = replies[index];
                  List<int> replyingTo = Utils.replyingTo(posts, reply);
                  if (replies.isEmpty ||
                      replyingTo.isEmpty ||
                      replyingTo.first != post.no ||
                      depth > maxDepth) {
                    return Container();
                  }
                  return recursiveWidget(reply, posts, depth + 1);
                },
              ),
            ),
            Positioned(
              top: 10,
              left: 9,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).dividerColor,
                  borderRadius: BorderRadius.circular(100),
                ),
                width: 2,
              ),
            ),
          ],
        ),
      ],
    );
  }

  FutureBuilder<List<Post>> buildNestedFutureBuilder() {
    return FutureBuilder<List<Post>>(
      future: _futurePosts,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Post> filteredReplies = snapshot.data!
              .where((post) => _matchesSearchQuery(post.com))
              .toList();
          List<Post> replies = filteredReplies
              .where((element) => Utils.isRootPost(element))
              .toList();
          imagePosts = _getImagePosts(snapshot.data!);
          imageThumbnailUrls = _getImageThumbnailUrls(snapshot.data!);
          return Scrollbar(
            isAlwaysShown: true,
            controller: _scrollController,
            child: ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              controller: _scrollController,
              itemCount: replies.length,
              itemBuilder: (context, index) {
                final post = replies[index];
                return recursiveWidget(post, filteredReplies, 0);
              },
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

  FutureBuilder<List<Post>> buildFutureBuilder() {
    return FutureBuilder<List<Post>>(
      future: _futurePosts,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Post> filteredReplies = snapshot.data!
              .where((post) => _matchesSearchQuery(post.com))
              .toList();
          imagePosts = _getImagePosts(snapshot.data!);
          imageThumbnailUrls = _getImageThumbnailUrls(snapshot.data!);
          return Scrollbar(
            isAlwaysShown: true,
            controller: _scrollController,
            child: ListView.builder(
              addAutomaticKeepAlives: true,
              physics: AlwaysScrollableScrollPhysics(),
              controller: _scrollController,
              itemCount: filteredReplies.length,
              itemBuilder: _listViewItemBuilder(filteredReplies),
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
