import 'package:flutter/material.dart';
import 'package:mobichan/api/api.dart';
import 'package:mobichan/classes/arguments/thread_page_arguments.dart';
import 'package:mobichan/classes/models/post.dart';
import 'package:mobichan/widgets/drawer_widget.dart';
import 'package:mobichan/widgets/post_action_button_widget.dart';
import 'package:mobichan/widgets/form/post_form_widget.dart';
import 'package:mobichan/widgets/post_widget.dart';

class ThreadPage extends StatefulWidget {
  final ThreadPageArguments args;
  const ThreadPage({Key? key, required this.args}) : super(key: key);

  @override
  _ThreadPageState createState() => _ThreadPageState();
}

class _ThreadPageState extends State<ThreadPage> {
  late Future<List<Post>> futurePosts;
  bool postFormIsOpen = false;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    setState(() {
      futurePosts =
          Api.fetchPosts(board: widget.args.board, thread: widget.args.thread);
    });
  }

  void onPressPostActionButton() {
    setState(() {
      postFormIsOpen = !postFormIsOpen;
    });
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
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: _refresh,
            child: FutureBuilder<List<Post>>(
              future: futurePosts,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      Post post = snapshot.data![index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: PostWidget(
                          post: post,
                          board: widget.args.board,
                        ),
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
          ),
          PostFormWidget(
            board: widget.args.board,
            thread: widget.args.thread,
            height: postFormIsOpen ? PostFormWidget.minHeight : 0,
          ),
        ],
      ),
    );
  }
}
