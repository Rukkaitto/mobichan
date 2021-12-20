import 'package:flutter/material.dart';
import 'package:mobichan/features/post/post.dart';
import 'package:mobichan_domain/mobichan_domain.dart';
import 'package:mobichan/localization.dart';
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
        title: Text(kFile.plural(args.imagePosts.length)),
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
            onTap: () => handleImageTap(
              context: context,
              board: args.board,
              imagePosts: args.imagePosts,
              index: index,
            ),
            child: Hero(
              tag: "image$index",
              child: ImageWidget(
                board: args.board,
                post: args.imagePosts[index],
              ),
            ),
          );
        },
      ),
    );
  }
}
