import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:mobichan_domain/mobichan_domain.dart';
import 'package:mobichan/constants.dart';
import 'package:mobichan/localization.dart';
import 'package:mobichan/pages/webm_viewer_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:share/share.dart';

class CarouselPage extends StatefulWidget {
  final String heroTitle;
  final int imageIndex;
  final Board board;
  final List<Post> posts;
  const CarouselPage({
    Key? key,
    required this.imageIndex,
    required this.board,
    required this.posts,
    this.heroTitle = "img",
  }) : super(key: key);

  @override
  _CarouselPageState createState() => _CarouselPageState();
}

class _CarouselPageState extends State<CarouselPage> {
  late PageController pageController;
  late Map<int, VlcPlayerController> videoPlayerControllers;
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.imageIndex;
    pageController = PageController(initialPage: widget.imageIndex);
    videoPlayerControllers = {};
  }

  void onPageChanged(int index) {
    setState(() {
      videoPlayerControllers[currentIndex]?.stop();
      currentIndex = index;
      videoPlayerControllers[currentIndex]?.play();
    });
  }

  String get imageUrl {
    return currentPost.getImageUrl(widget.board);
  }

  bool isWebM(String url) {
    return url.contains(".webm");
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      content: Text(
        isSuccess ? saveToGallerySuccess : saveToGalleryError,
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
      name: '${currentPost.filename}${currentPost.ext}',
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
      backgroundColor: transparentColor,
      appBar: AppBar(
        title: Text(
          '${currentPost.filename}${currentPost.ext}',
        ),
        actions: [
          IconButton(
            onPressed: _shareImage,
            icon: const Icon(Icons.share_rounded),
          ),
          IconButton(
            onPressed: _saveImage,
            icon: const Icon(Icons.save_rounded),
          ),
        ],
      ),
      body: Stack(
        children: [
          PhotoViewGallery.builder(
            backgroundDecoration:
                const BoxDecoration(color: Colors.transparent),
            scrollPhysics: const BouncingScrollPhysics(),
            pageController: pageController,
            builder: (BuildContext context, int index) {
              Post currentPost = widget.posts[index];
              if (isWebM(currentPost.getImageUrl(widget.board))) {
                if (videoPlayerControllers[index] == null) {
                  videoPlayerControllers[index] = VlcPlayerController.network(
                    currentPost.getImageUrl(widget.board),
                    hwAcc: HwAcc.FULL,
                    autoPlay: true,
                    options: VlcPlayerOptions(),
                  );
                }
                return PhotoViewGalleryPageOptions.customChild(
                  child: WebmViewerPage(
                    currentPost,
                    videoPlayerControllers[index],
                  ),
                );
              } else {
                return PhotoViewGalleryPageOptions(
                  imageProvider: NetworkImage(
                    widget.posts[index].getImageUrl(widget.board),
                  ),
                  heroAttributes: PhotoViewHeroAttributes(
                    tag: "image$index",
                  ),
                );
              }
            },
            onPageChanged: onPageChanged,
            itemCount: widget.posts.length,
            loadingBuilder: (context, progress) => Center(
              child: SizedBox(
                width: 60.0,
                height: 60.0,
                child: (progress == null || progress.expectedTotalBytes == null)
                    ? const CircularProgressIndicator()
                    : CircularProgressIndicator(
                        value: progress.cumulativeBytesLoaded /
                            progress.expectedTotalBytes!,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
