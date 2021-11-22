import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mobichan_domain/mobichan_domain.dart';
import 'package:shimmer/shimmer.dart';

class ThumbnailWidget extends StatelessWidget {
  final Board board;
  final Post post;
  final double height;
  final double borderRadius;

  const ThumbnailWidget(
      {Key? key,
      required this.board,
      required this.post,
      required this.height,
      this.borderRadius = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (post.filename != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: SizedBox(
          height: height,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: post.isWebm
                    ? post.getThumbnailUrl(board)
                    : post.getImageUrl(board),
                placeholder: (context, url) {
                  return Image.network(
                    post.getThumbnailUrl(board),
                    fit: BoxFit.cover,
                    loadingBuilder: (context, widget, progress) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey.shade700,
                        highlightColor: Colors.grey.shade600,
                        child: Container(
                          color: Colors.white,
                        ),
                      );
                    },
                  );
                },
                fadeInDuration: Duration.zero,
              ),
              if (post.isWebm)
                const Center(
                  child: Icon(
                    Icons.play_circle_outline,
                    color: Colors.white,
                    size: 60,
                  ),
                ),
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}
