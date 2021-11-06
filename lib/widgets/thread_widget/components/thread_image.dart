import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mobichan_domain/mobichan_domain.dart';
import 'package:mobichan/widgets/thread_widget/components/thread_round_dimmed_image.dart';

import '../../../constants.dart';

class ThreadImage extends StatelessWidget {
  final Board board;
  final Post post;
  const ThreadImage({Key? key, required this.board, required this.post})
      : super(key: key);

  String getImageUrl() {
    if (post.ext == '.webm') {
      return post.getThumbnailUrl(board);
    }
    return post.getImageUrl(board);
  }

  @override
  Widget build(BuildContext context) {
    if (post.tim != null) {
      return CachedNetworkImage(
        imageUrl: getImageUrl(),
        imageBuilder: (context, imageProvider) =>
            ThreadRoundDimmedImage(imageProvider),
        placeholder: (context, url) => Center(
          child: ThreadRoundDimmedImage(
            NetworkImage('$API_IMAGES_URL/${board.board}/${post.tim}s.jpg'),
          ),
        ),
        fadeInDuration: Duration.zero,
      );
    } else {
      return Container();
    }
  }
}
