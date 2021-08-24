import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobichan/classes/models/post.dart';
import 'package:mobichan/utils/utils.dart';
import 'package:mobichan/widgets/post_widget/components/post_content.dart';
import 'package:mobichan/widgets/post_widget/components/post_footer.dart';
import 'package:mobichan/widgets/post_widget/components/post_header.dart';
import 'package:mobichan/widgets/post_widget/components/post_image.dart';

// ignore: must_be_immutable
class PostWidget extends StatelessWidget {
  final Post post;
  final String board;
  final Function? onTap;
  final double? height;
  final List<Post> threadReplies;
  final Function(int)? onPostNoTap;
  late List<Post> postReplies;
  final bool? showReplies;

  PostWidget({
    required this.post,
    required this.board,
    required this.threadReplies,
    this.onTap,
    this.onPostNoTap,
    this.height,
    this.showReplies,
  }) {
    postReplies = Utils.getReplies(threadReplies, post);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: () => onTap?.call(),
        child: Container(
          color: Theme.of(context).cardColor,
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                post.tim != null
                    ? PostImage(board: board, post: post)
                    : Container(),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.all(6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    EdgeInsets.only(top: 8, left: 8, right: 8),
                                child: PostHeader(
                                  post: post,
                                  onPostNoTap: onPostNoTap,
                                ),
                              ),
                              PostContent(
                                board: board,
                                post: post,
                                threadReplies: threadReplies,
                              ),
                            ],
                          ),
                        ),
                        if (showReplies != false && postReplies.length > 0)
                          Padding(
                            padding: EdgeInsets.only(bottom: 8, right: 8),
                            child: PostFooter(
                                postReplies: postReplies,
                                board: board,
                                threadReplies: threadReplies),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
