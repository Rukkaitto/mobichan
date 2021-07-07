import 'package:flutter/material.dart';
import 'package:mobichan/classes/models/post.dart';
import 'package:mobichan/constants.dart';
import 'package:mobichan/pages/thread_page.dart';
import 'package:mobichan/widgets/post_widget.dart';

class RepliesPage extends StatelessWidget {
  final List<Post> postReplies;
  final List<Post> threadReplies;
  final String board;
  const RepliesPage(this.postReplies,
      {Key? key, required this.board, required this.threadReplies})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${postReplies.length} ${postReplies.length > 1 ? 'replies' : 'reply'}',
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.popUntil(
                  context, ModalRoute.withName(ThreadPage.routeName));
            },
            icon: Icon(Icons.close_rounded),
          ),
        ],
      ),
      body: Center(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: postReplies.length,
          itemBuilder: (context, index) {
            Post reply = postReplies[index];
            return Padding(
              padding: EdgeInsets.all(8),
              child: PostWidget(
                post: reply,
                board: board,
                threadReplies: threadReplies,
              ),
            );
          },
        ),
      ),
    );
  }
}
