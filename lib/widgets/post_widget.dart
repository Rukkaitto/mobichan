import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mobichan/classes/models/post.dart';
import 'package:mobichan/constants.dart';
import 'package:mobichan/pages/image_viewer_page.dart';
import 'package:mobichan/pages/video_viewer_page.dart';

class PostWidget extends StatelessWidget {
  final Post post;
  final String board;
  final Function? onTap;
  final double? height;

  const PostWidget(
      {required this.post, required this.board, this.onTap, this.height});

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
                        Padding(
                          padding: EdgeInsets.only(top: 8, left: 8, right: 8),
                          child: PostHeader(post: post),
                        ),
                        PostContent(post: post),
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

class PostContent extends StatelessWidget {
  const PostContent({
    Key? key,
    required this.post,
  }) : super(key: key);

  final Post post;

  @override
  Widget build(BuildContext context) {
    return Html(
      data: post.com ?? '',
      onAnchorTap: (str, _, __, ___) {
        print(str);
      },
      style: {
        ".quote": Style(
          color: Colors.green.shade300,
        ),
        ".quotelink": Style(
          color: Theme.of(context).accentColor,
        ),
      },
    );
  }
}

class PostHeader extends StatelessWidget {
  const PostHeader({
    Key? key,
    required this.post,
  }) : super(key: key);

  final Post post;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            post.name ?? post.trip ?? 'Anonymous',
            style: postNameTextStyle(context),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          post.no.toString(),
          style: postNoTextStyle(context),
        ),
      ],
    );
  }
}

class PostImage extends StatelessWidget {
  const PostImage({
    Key? key,
    required this.board,
    required this.post,
  }) : super(key: key);

  final String board;
  final Post post;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () {
          if (post.ext == '.webm') {
            Navigator.of(context).push(
              PageRouteBuilder(
                opaque: false,
                pageBuilder: (context, _, __) => VideoViewerPage(board, post),
              ),
            );
          } else {
            Navigator.of(context).push(
              PageRouteBuilder(
                opaque: false,
                pageBuilder: (context, _, __) => ImageViewerPage(board, post),
              ),
            );
          }
        },
        child: Hero(
          tag: post.tim.toString(),
          child: Image.network(
            '$API_IMAGES_URL/$board/${post.tim}s.jpg',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
