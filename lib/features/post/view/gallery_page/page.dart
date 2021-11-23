import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobichan_domain/mobichan_domain.dart';
import 'package:mobichan/localization.dart';
import 'package:mobichan/pages/image_carousel_page.dart';
import 'package:easy_localization/easy_localization.dart';

class GalleryPageArguments {
  final Board board;
  final List<Post> imagePosts;

  GalleryPageArguments({required this.board, required this.imagePosts});
}

class GalleryPage extends StatelessWidget {
  static const routeName = '/gallery';

  final int crossAxisCount = 3;

  const GalleryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as GalleryPageArguments;

    return Scaffold(
      appBar: AppBar(
        title: const Text(gallery).tr(),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: GridView.builder(
        itemCount: args.imagePosts.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 3.0,
          mainAxisSpacing: 3.0,
        ),
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) {
                        return ImageCarouselPage(
                          imageIndex: index,
                          posts: args.imagePosts,
                          board: args.board,
                          heroTitle: "image$index",
                        );
                      },
                      fullscreenDialog: true));
            },
            child: Hero(
                tag: "image$index",
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: args.imagePosts[index].getThumbnailUrl(args.board),
                  placeholder: (context, url) => Center(
                    child: Platform.isAndroid
                        ? const CircularProgressIndicator()
                        : const CupertinoActivityIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                )),
          );
        },
      ),
    );
  }
}
