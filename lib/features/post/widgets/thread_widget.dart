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
  final int maxLines = 5;

  const ThreadWidget({required this.thread, required this.board, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildTitle(context),
        buildImage(),
        buildFooter(context),
      ],
    );
  }

  Widget buildFooter(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              buildSticky(context),
              buildReplies(context),
              buildImages(context),
            ],
          ),
          Icon(
            Icons.more_vert,
            size: iconSize,
            color: Theme.of(context).textTheme.subtitle1!.color,
          ),
        ],
      ),
    );
  }

  Widget buildSticky(BuildContext context) {
    if (thread.sticky != null) {
      return Row(
        children: [
          Icon(
            Icons.push_pin,
            size: iconSize,
            color: Theme.of(context).textTheme.subtitle1!.color,
          ),
          spacingBetweenIcons,
        ],
      );
    } else {
      return Container();
    }
  }

  Widget buildReplies(BuildContext context) {
    if (thread.replies != null) {
      return Row(
        children: [
          Icon(
            Icons.reply,
            size: iconSize,
            color: Theme.of(context).textTheme.subtitle1!.color,
          ),
          spacingBetweenIconAndText,
          Text(
            '${thread.replies}',
            style: Theme.of(context).textTheme.subtitle1,
          ),
          spacingBetweenIcons,
        ],
      );
    } else {
      return Container();
    }
  }

  Widget buildImages(BuildContext context) {
    if (thread.images != null) {
      return Row(
        children: [
          Icon(
            Icons.image,
            size: iconSize,
            color: Theme.of(context).textTheme.subtitle1!.color,
          ),
          spacingBetweenIconAndText,
          Text(
            '${thread.images}',
            style: Theme.of(context).textTheme.subtitle1,
          ),
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
            imageUrl: thread.isWebm
                ? thread.getThumbnailUrl(board)
                : thread.getImageUrl(board),
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

  Widget buildTitle(BuildContext context) {
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
        style: Theme.of(context).textTheme.headline2,
      ),
    );
  }
}
