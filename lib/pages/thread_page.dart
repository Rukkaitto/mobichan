import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobichan/api/api.dart';
import 'package:mobichan/classes/arguments/thread_page_arguments.dart';
import 'package:mobichan/classes/models/post.dart';
import 'package:mobichan/enums/enums.dart';
import 'package:mobichan/pages/gallery_page.dart';
import 'package:mobichan/widgets/drawer_widget.dart';
import 'package:mobichan/widgets/form_widget.dart';
import 'package:mobichan/widgets/post_action_button_widget.dart';
import 'package:mobichan/widgets/post_widget.dart';

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
  List<String> imageUrls = [];

  @override
  void initState() {
    super.initState();
    _refresh();
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
  }

  List<String> _getImageUrls(List<Post> posts) {
    List<String> imageUrls = [];

    for (Post post in posts) {
      if (post.tim != null) {
        String imageUrl =
            '$API_IMAGES_URL/${widget.args.board}/${post.tim}s.jpg';
        imageUrls.add(imageUrl);
      }
    }

    return imageUrls;
  }

  void _gotoGalleryView() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return GalleryPage(imageUrlList: imageUrls);
    }));
  }

  Widget Function(BuildContext, int) _listViewItemBuilder(
      AsyncSnapshot<List<Post>> snapshot) {
    return (context, index) {
      Post post = snapshot.data![index];
      return Padding(
        padding: EdgeInsets.only(left: 15, top: 15, right: 15),
        child: PostWidget(
          post: post,
          board: widget.args.board,
          threadReplies: snapshot.data!,
          onPostNoTap: _onPostNoTap,
        ),
      );
    };
  }

  PopupMenuButton<dynamic> _buildPopupMenuButton() {
    return PopupMenuButton(
      onSelected: (position) {
        _scrollController.jumpTo(position);
      },
      itemBuilder: (context) {
        return <PopupMenuEntry>[
          PopupMenuItem(
            child: Text('Scroll to top'),
            value: _scrollController.position.minScrollExtent,
          ),
          PopupMenuItem(
            child: Text('Scroll to bottom'),
            value: _scrollController.position.maxScrollExtent,
          ),
        ];
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: PostActionButton(
        onPressed: onPressPostActionButton,
      ),
      drawer: DrawerWidget(),
      appBar: AppBar(
        title: Text(widget.args.title),
        actions: <Widget>[
          IconButton(onPressed: _gotoGalleryView, icon: Icon(Icons.image)),
    _buildPopupMenuButton(),
        ],
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: _refresh,
            child: buildFutureBuilder(),
          ),
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

  FutureBuilder<List<Post>> buildFutureBuilder() {
    return FutureBuilder<List<Post>>(
      future: _futurePosts,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          imageUrls = _getImageUrls(snapshot.data!);
          return Scrollbar(
            isAlwaysShown: true,
            controller: _scrollController,
            child: ListView.builder(
              addAutomaticKeepAlives: true,
              physics: AlwaysScrollableScrollPhysics(),
              controller: _scrollController,
              itemCount: snapshot.data!.length,
              itemBuilder: _listViewItemBuilder(snapshot),
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
