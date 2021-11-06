import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobichan_domain/mobichan_domain.dart';
import 'package:mobichan/localization.dart';
import 'package:mobichan/pages/image_carousel_page.dart';
import 'package:easy_localization/easy_localization.dart';

class GalleryPage extends StatelessWidget {
  final List<Post> imagePosts;
  final int crossAxisCount;
  final Board board;
  const GalleryPage(
      {Key? key,
      required this.imagePosts,
      required this.board,
      this.crossAxisCount = 3});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(gallery).tr(),
      ),
      backgroundColor: Theme.of(context).canvasColor,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          itemCount: imagePosts.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0),
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) {
                          return ImageCarouselPage(
                            imageIndex: index,
                            posts: imagePosts,
                            board: board,
                            heroTitle: "image$index",
                          );
                        },
                        fullscreenDialog: true));
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Hero(
                    tag: "image$index",
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: imagePosts[index].getThumbnailUrl(board),
                      placeholder: (context, url) => Container(
                        child: Center(
                          child: Platform.isAndroid
                              ? CircularProgressIndicator()
                              : CupertinoActivityIndicator(),
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    )),
              ),
            );
          },
        ),
      ),
    );
  }
}
