import 'package:flutter/material.dart';
import 'package:mobichan/classes/models/post.dart';
import 'package:mobichan/pages/image_viewer_page.dart';
import 'package:mobichan/pages/webm_viewer_page.dart';

import '../../../constants.dart';

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
                pageBuilder: (context, _, __) => WebmViewerPage(board, post),
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
