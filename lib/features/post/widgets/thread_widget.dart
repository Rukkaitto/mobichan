import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mobichan/features/core/core.dart';
import 'package:mobichan_domain/mobichan_domain.dart';
import 'package:mobichan/extensions/string_extension.dart';
import 'package:shimmer/shimmer.dart';

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

  Widget buildImage() {
    if (thread.filename != null) {
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
                  loadingBuilder: (context, widget, progress) {
                    return Center(
                      child: buildLoading(progress),
                    );
                  },
                );
              },
              fadeInDuration: Duration.zero,
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  Widget buildLoading(ImageChunkEvent? loadingProgress) {
    if (loadingProgress != null) {
      return CircularProgressIndicator(
        value: loadingProgress.cumulativeBytesLoaded /
            loadingProgress.expectedTotalBytes!,
      );
    } else {
      return CircularProgressIndicator();
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

  static Widget get shimmer {
    return Builder(
      builder: (context) {
        double deviceWidth = MediaQuery.of(context).size.width;
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade700,
          highlightColor: Colors.grey.shade600,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: deviceWidth,
                      height: 15.0,
                      color: Colors.white,
                    ),
                    SizedBox(height: 10.0),
                    Container(
                      width: RandomUtils.randomDouble(100, deviceWidth),
                      height: 15.0,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              // Image
              Container(
                height: 250.0,
                color: Colors.white,
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.reply,
                          color: Colors.white,
                          size: 20.0,
                        ),
                        SizedBox(width: 30.0),
                        Icon(
                          Icons.image,
                          color: Colors.white,
                          size: 20.0,
                        ),
                      ],
                    ),
                    Icon(
                      Icons.more_vert,
                      color: Colors.white,
                      size: 20.0,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
