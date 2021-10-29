import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobichan/classes/models/post.dart';
import 'package:mobichan/pages/thread_page.dart';
import 'package:mobichan/widgets/post_widget/post_widget.dart';

class RepliesPage extends StatelessWidget {
  final List<Post> postReplies;
  final List<Post> threadReplies;
  final String board;
  const RepliesPage(this.postReplies,
      {Key? key, required this.board, required this.threadReplies})
      : super(key: key);

  List<String> _getImageUrls(List<Post> posts) {
    List<String> imageUrls = [];

    for (Post post in posts) {
      if (post.tim != null) {
        imageUrls.add(post.getImageUrl(this.board));
      }
    }

    return imageUrls;
  }

  @override
  Widget build(BuildContext context) {
    List<String> imageUrls = _getImageUrls(this.threadReplies);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'reply'.plural(postReplies.length),
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
                imageIndex: imageUrls.indexOf(reply.getImageUrl(board)),
                imageUrls: imageUrls,
              ),
            );
          },
        ),
      ),
    );
  }
}
