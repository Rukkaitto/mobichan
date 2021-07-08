

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobichan/pages/view_photo.dart';

class GalleryPage extends StatelessWidget {
   final List<String >  imageUrlList;
  final int  crossAxisCount;
  const GalleryPage(
      {Key? key, required this.imageUrlList, this.crossAxisCount = 3});



  @override
  Widget  build(BuildContext  context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
            itemCount: imageUrlList.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 6.0,
                mainAxisSpacing: 6.0),
            itemBuilder: (BuildContext  context, int  index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) {
                            return ViewPhotos(
                              imageIndex: index,
                              imageList: imageUrlList,
                              heroTitle: "image$index",
                            );
                          },
                          fullscreenDialog: true));
                },
                child: Container(
                  child: Hero(
                      tag: "photo$index",
                      child: CachedNetworkImage(
                        fit: BoxFit.fill,
                        imageUrl: imageUrlList[index],
                        placeholder: (context, url) => Container(
                            child: Center(child: CupertinoActivityIndicator())),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      )),
                ),
              );
            }),
      ),
    );
  }
}