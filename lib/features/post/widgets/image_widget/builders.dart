import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'image_widget.dart';

extension ImageWidgetBuilders on ImageWidgetState {
  Widget buildLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade700,
      highlightColor: Colors.grey.shade600,
      child: Container(
        color: Colors.white,
      ),
    );
  }

  Widget buildImage(String imageUrl) {
    return Stack(
      fit: StackFit.expand,
      children: [
        CachedNetworkImage(
          fit: BoxFit.fitHeight,
          imageUrl: imageUrl,
          placeholder: (context, url) {
            return Image.network(
              widget.post.getThumbnailUrl(widget.board)!,
              fit: BoxFit.cover,
              loadingBuilder: (context, widget, progress) {
                return buildLoading();
              },
            );
          },
          fadeInDuration: Duration.zero,
        ),
        if (widget.post.isWebm)
          const Center(
            child: Icon(
              Icons.play_circle_outline,
              color: Colors.white,
              size: 60,
            ),
          ),
      ],
    );
  }
}
