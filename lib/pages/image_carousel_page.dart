import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:mobichan/classes/models/post.dart';
import 'package:mobichan/constants.dart';
import 'package:mobichan/localization.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:share/share.dart';

class ImageCarouselPage extends StatefulWidget {
  final String heroTitle;
  final int imageIndex;
  final String board;
  final List<Post> posts;
  ImageCarouselPage(
      {required this.imageIndex,
      required this.board,
      required this.posts,
      this.heroTitle = "img"});

  @override
  _ImageCarouselPageState createState() => _ImageCarouselPageState();
}

class _ImageCarouselPageState extends State<ImageCarouselPage> {
  late PageController pageController;
  late int currentIndex;
  @override
  void initState() {
    super.initState();
    currentIndex = widget.imageIndex;
    pageController = PageController(initialPage: widget.imageIndex);
  }

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  String get imageUrl {
    return currentPost.getImageUrl(widget.board);
  }

  Post get currentPost {
    return widget.posts[currentIndex];
  }

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
        isSuccess ? save_to_gallery_success : save_to_gallery_error,
        style: snackbarTextStyle(context),
      ).tr(),
    );
  }

  void _saveImage() async {
    var response = await Dio().get(
      imageUrl,
      options: Options(responseType: ResponseType.bytes),
    );

    final result = await ImageGallerySaver.saveImage(
      Uint8List.fromList(response.data),
      quality: 100,
      name: filenameRegExp.stringMatch(imageUrl),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      buildSnackBar(result!['isSuccess']),
    );
  }

  void _shareImage() async {
    var response = await Dio().get(
      imageUrl,
      options: Options(responseType: ResponseType.bytes),
    );

    final directory = await getTemporaryDirectory();
    final imagePath = await File('${directory.path}/image.png').create();
    await imagePath.writeAsBytes(response.data);
    await Share.shareFiles([imagePath.path]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          '${currentPost.filename}${currentPost.ext}',
          style: TextStyle(color: Colors.white),
        ),
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
        backgroundColor: Colors.black,
      ),
      body: Container(
        child: Stack(
          children: [
            PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              pageController: pageController,
              builder: (BuildContext context, int index) {
                return PhotoViewGalleryPageOptions(
                  imageProvider: NetworkImage(
                      widget.posts[index].getImageUrl(widget.board)),
                  heroAttributes:
                      PhotoViewHeroAttributes(tag: "photo${widget.imageIndex}"),
                );
              },
              onPageChanged: onPageChanged,
              itemCount: widget.posts.length,
              loadingBuilder: (context, progress) => Center(
                child: Container(
                  width: 60.0,
                  height: 60.0,
                  child:
                      (progress == null || progress.expectedTotalBytes == null)
                          ? CircularProgressIndicator()
                          : CircularProgressIndicator(
                              value: progress.cumulativeBytesLoaded /
                                  progress.expectedTotalBytes!,
                            ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
