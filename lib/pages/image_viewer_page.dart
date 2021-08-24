import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:mobichan/classes/models/post.dart';
import 'package:mobichan/constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';

class ImageViewerPage extends StatelessWidget {
  final Post post;
  final String board;

  const ImageViewerPage(this.board, this.post, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SnackBar buildSnackBar(bool isSuccess) {
      return SnackBar(
        backgroundColor: isSuccess
            ? Theme.of(context).cardColor
            : Theme.of(context).errorColor,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        content: Text(
          isSuccess ? 'Image saved to Gallery.' : 'Error saving image.',
          style: snackbarTextStyle(context),
        ),
      );
    }

    void _saveImage() async {
      var response = await Dio().get(
          '$API_IMAGES_URL/$board/${post.tim}${post.ext}',
          options: Options(responseType: ResponseType.bytes));
      final result = await ImageGallerySaver.saveImage(
          Uint8List.fromList(response.data),
          quality: 100,
          name: '${post.filename}${post.ext}');
      ScaffoldMessenger.of(context).showSnackBar(
        buildSnackBar(result!['isSuccess']),
      );
    }

    void _shareImage() async {
      var response = await Dio().get(
          '$API_IMAGES_URL/$board/${post.tim}${post.ext}',
          options: Options(responseType: ResponseType.bytes));
      final directory = await getTemporaryDirectory();
      final imagePath = await File('${directory.path}/image.png').create();
      await imagePath.writeAsBytes(response.data);
      await Share.shareFiles([imagePath.path]);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${post.filename}${post.ext}'),
        actions: [
          IconButton(
            onPressed: _shareImage,
            icon: Icon(Icons.share_rounded),
          ),
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
              clipBehavior: Clip.none,
              child: Stack(
                children: [
                  Image.network(
                    '$API_IMAGES_URL/$board/${post.tim}s.jpg',
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Image.network(
                    '$API_IMAGES_URL/$board/${post.tim}${post.ext}',
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
