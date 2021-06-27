import 'package:flutter/material.dart';
import 'package:mobichan/classes/models/post.dart';
import 'package:mobichan/constants.dart';

class ImageViewerPage extends StatelessWidget {
  final Post post;
  final String board;

  const ImageViewerPage(this.board, this.post, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: post.tim.toString(),
      child: GestureDetector(
        onVerticalDragUpdate: (details) {
          if (details.delta.dy < 8) {
            Navigator.of(context).pop();
          }
        },
        child: InteractiveViewer(
          clipBehavior: Clip.none,
          child: FittedBox(
            child: Stack(
              children: [
                Image.network('$API_IMAGES_URL/$board/${post.tim}s.jpg'),
                Image.network('$API_IMAGES_URL/$board/${post.tim}${post.ext}'),
              ],
            ),
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
    );
  }
}
