import 'package:flutter/material.dart';
import 'package:mobichan_domain/mobichan_domain.dart';
import 'package:mobichan/extensions/string_extension.dart';

import '../../../constants.dart';
import 'thread_sticky_icon.dart';

class ThreadOverlay extends StatelessWidget {
  final Post post;
  const ThreadOverlay({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Stack(
          children: [
            post.sticky == 1 ? const ThreadStickyIcon() : Container(),
            buildCounts(),
            buildComment(),
          ],
        ),
      ),
    );
  }

  Positioned buildComment() {
    return Positioned(
      left: 0,
      bottom: 0,
      right: 0,
      child: Text(
        post.sub?.removeHtmlTags.unescapeHtml ??
            post.com?.replaceBrWithNewline.removeHtmlTags.unescapeHtml ??
            '',
        softWrap: true,
        maxLines: 3,
        style: threadTitleTextStyle,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Positioned buildCounts() {
    return Positioned(
      top: 0,
      right: 0,
      child: Row(
        children: [
          if (post.replies != 0) buildReplyCount(),
          if (post.images != 0) Container(width: 10),
          if (post.images != 0) buildImageCount(),
        ],
      ),
    );
  }

  Row buildImageCount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Icon(
          Icons.image_rounded,
          color: Colors.white,
          size: 16,
        ),
        Text(
          post.images.toString(),
          style: threadNumbersTextStyle,
        ),
      ],
    );
  }

  Row buildReplyCount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Icon(
          Icons.reply_rounded,
          color: Colors.white,
          size: 16,
        ),
        Text(
          post.replies.toString(),
          style: threadNumbersTextStyle,
        ),
      ],
    );
  }
}
