import 'package:flutter/material.dart';
import 'package:mobichan/classes/models/post.dart';
import 'package:mobichan/constants.dart';

class ImageViewerPage extends StatelessWidget {
  final Post post;
  final String board;

  const ImageViewerPage(this.board, this.post, {Key? key}) : super(key: key);

  void _saveImage() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${post.filename}${post.ext}'),
        actions: [
          IconButton(
            onPressed: _saveImage,
            icon: Icon(Icons.save_rounded),
          ),
        ],
      ),
      backgroundColor: TRANSPARENT_COLOR,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Hero(
            tag: post.tim.toString(),
            child: InteractiveViewer(
              child: GestureDetector(
                onVerticalDragEnd: (details) {
                  if (details.primaryVelocity! < -10) {
                    Navigator.of(context).pop();
                  }
                },
                child: Stack(
                  children: [
                    Image.network(
                      '$API_IMAGES_URL/$board/${post.tim}s.jpg',
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Image.network(
                        '$API_IMAGES_URL/$board/${post.tim}${post.ext}'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
