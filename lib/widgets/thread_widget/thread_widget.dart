import 'package:flutter/material.dart';
import 'package:mobichan/classes/models/post.dart';

import 'components/thread_image.dart';
import 'components/thread_overlay.dart';

class ThreadWidget extends StatelessWidget {
  final Post post;
  final String board;
  final Function? onTap;

  const ThreadWidget(
      {Key? key, required this.post, required this.board, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap?.call(),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        elevation: 3,
        child: Stack(
          children: [
            ThreadImage(board: board, post: post),
            ThreadOverlay(post: post),
          ],
        ),
      ),
    );
  }
}
