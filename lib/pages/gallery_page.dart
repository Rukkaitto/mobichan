import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobichan/pages/image_carousel_page.dart';

class GalleryPage extends StatelessWidget {
  final List<String> imageUrlList;
  final List<String> imageThumbnailUrlList;
  final int crossAxisCount;
  const GalleryPage(
      {Key? key,
      required this.imageUrlList,
      required this.imageThumbnailUrlList,
      this.crossAxisCount = 3});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          itemCount: imageUrlList.length,
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
                            imageList: imageUrlList,
                            heroTitle: "image$index",
                          );
                        },
                        fullscreenDialog: true));
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Hero(
                    tag: "photo$index",
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: imageThumbnailUrlList[index],
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
