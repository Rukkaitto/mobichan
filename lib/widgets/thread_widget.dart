import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mobichan/classes/models/post.dart';
import 'package:mobichan/constants.dart';
import 'package:mobichan/extensions/string_extension.dart';
import 'package:mobichan/widgets/round_dimmed_image.dart';

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
        borderRadius: BorderRadius.circular(15),
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

class ThreadImage extends StatelessWidget {
  final String board;
  final Post post;
  const ThreadImage({Key? key, required this.board, required this.post})
      : super(key: key);

  String getImageUrl() {
    if (post.ext == '.webm') {
      return '$API_IMAGES_URL/$board/${post.tim}s.jpg';
    }
    return '$API_IMAGES_URL/$board/${post.tim}${post.ext}';
  }

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: getImageUrl(),
      imageBuilder: (context, imageProvider) => RoundDimmedImage(imageProvider),
      placeholder: (context, url) => Center(
        child: RoundDimmedImage(
          NetworkImage('$API_IMAGES_URL/$board/${post.tim}s.jpg'),
        ),
      ),
      fadeInDuration: Duration.zero,
    );
  }
}

class ThreadOverlay extends StatelessWidget {
  final Post post;
  const ThreadOverlay({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Stack(
          children: [
            post.sticky == 1 ? StickyIcon() : Container(),
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
        Icon(
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
        Icon(
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

class StickyIcon extends StatelessWidget {
  const StickyIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      child: Icon(
        Icons.push_pin_rounded,
        color: Colors.white,
      ),
    );
  }
}
