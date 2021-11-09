import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mobichan_domain/mobichan_domain.dart';
import 'package:mobichan/extensions/string_extension.dart';

class ThreadWidget extends StatelessWidget {
  final Post thread;
  final Board board;

  final EdgeInsetsGeometry padding = const EdgeInsets.all(15.0);
  final SizedBox spacingBetweenIcons = const SizedBox(width: 25.0);
  final SizedBox spacingBetweenIconAndText = const SizedBox(width: 5.0);
  final double iconSize = 20.0;
  final double imageHeight = 250.0;
  final int maxLines = 3;

  const ThreadWidget({required this.thread, required this.board, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildTitle(),
        buildImage(),
        buildFooter(),
      ],
    );
  }

  Widget buildFooter() {
    return Padding(
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              buildSticky(),
              buildReplies(),
              buildImages(),
            ],
          ),
          Icon(Icons.more_vert),
        ],
      ),
    );
  }

  Widget buildSticky() {
    if (thread.sticky != null) {
      return Row(
        children: [
          Icon(
            Icons.push_pin,
            size: iconSize,
          ),
          spacingBetweenIcons,
        ],
      );
    } else {
      return Container();
    }
  }

  Widget buildReplies() {
    if (thread.replies != null) {
      return Row(
        children: [
          Icon(
            Icons.reply,
            size: iconSize,
          ),
          spacingBetweenIconAndText,
          Text('${thread.replies}'),
          spacingBetweenIcons,
        ],
      );
    } else {
      return Container();
    }
  }

  Widget buildImages() {
    if (thread.images != null) {
      return Row(
        children: [
          Icon(
            Icons.image,
            size: iconSize,
          ),
          spacingBetweenIconAndText,
          Text('${thread.images}'),
        ],
      );
    } else {
      return Container();
    }
  }

  SizedBox buildImage() {
    return SizedBox(
      height: imageHeight,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            fit: BoxFit.cover,
            imageUrl: thread.getImageUrl(board),
            placeholder: (context, url) {
              return Image.network(
                thread.getThumbnailUrl(board),
                fit: BoxFit.cover,
              );
            },
            fadeInDuration: Duration.zero,
          ),
        ],
      ),
    );
  }

  Widget buildLoading(ImageChunkEvent? loadingProgress) {
    if (loadingProgress != null) {
      return CircularProgressIndicator(
        value: loadingProgress.cumulativeBytesLoaded /
            loadingProgress.expectedTotalBytes!,
      );
    } else {
      return Container();
    }
  }

  Widget buildTitle() {
    String title = thread.sub?.removeHtmlTags.unescapeHtml ??
        thread.com?.replaceBrWithNewline.removeHtmlTags.unescapeHtml ??
        '';

    return Padding(
      padding: padding,
      child: Text(
        title,
        softWrap: true,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
