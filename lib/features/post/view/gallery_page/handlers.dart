import 'package:flutter/material.dart';
import 'package:mobichan/features/post/post.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

extension GalleryPageHandlers on GalleryPage {
  void handleImageTap({
    required BuildContext context,
    required Board board,
    required List<Post> imagePosts,
    required int index,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) {
          return CarouselPage(
            imageIndex: index,
            posts: imagePosts,
            board: board,
            heroTitle: "image$index",
          );
        },
        fullscreenDialog: true,
      ),
    );
  }
}
