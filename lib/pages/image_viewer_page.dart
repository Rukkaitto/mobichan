import 'package:flutter/material.dart';
import 'package:mobichan/classes/models/post.dart';
import 'package:mobichan/constants.dart';

class ImageViewerPage extends StatelessWidget {
  final Post post;
  final String board;

  const ImageViewerPage(this.board, this.post, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InteractiveViewer(
        child: Hero(
            tag: post.tim.toString(),
            child:
                Image.network('$API_IMAGES_URL/$board/${post.tim}${post.ext}')),
      ),
    );
  }
}
