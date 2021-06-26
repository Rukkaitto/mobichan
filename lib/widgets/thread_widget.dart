import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mobichan/classes/models/post.dart';
import 'package:mobichan/constants.dart';
import 'package:mobichan/extensions/string_extension.dart';
import 'package:mobichan/widgets/round_dimmed_image.dart';

class ThreadWidget extends StatelessWidget {
  final Post post;
  final String board;
  final Function? onTap;

  const ThreadWidget(
      {Key? key, required this.post, required this.board, this.onTap})
      : super(key: key);

  String getImageUrl() {
    if (post.ext == '.webm') {
      return '$API_IMAGES_URL/$board/${post.tim}s.jpg';
    }
    return '$API_IMAGES_URL/$board/${post.tim}${post.ext}';
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap?.call(),
      child: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: getImageUrl(),
            imageBuilder: (context, imageProvider) =>
                RoundDimmedImage(imageProvider),
            placeholder: (context, url) => Center(
              child: RoundDimmedImage(
                NetworkImage('$API_IMAGES_URL/$board/${post.tim}s.jpg'),
              ),
            ),
            fadeInDuration: Duration.zero,
          ),
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Stack(
                children: [
                  post.sticky == 1
                      ? Positioned(
                          top: 0,
                          left: 0,
                          child: Icon(
                            Icons.push_pin_rounded,
                            color: Colors.white,
                          ),
                        )
                      : Container(),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Row(
                      children: [
                        post.replies != 0
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(
                                    Icons.reply_rounded,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                  Text(
                                    post.replies.toString(),
                                    style: threadNumbersTextStyle,
                                  ),
                                ],
                              )
                            : Container(),
                        Container(
                          width: 15,
                        ),
                        post.images != 0
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(
                                    Icons.image_rounded,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                  Text(
                                    post.images.toString(),
                                    style: threadNumbersTextStyle,
                                  ),
                                ],
                              )
                            : Container(),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 0,
                    bottom: 0,
                    right: 0,
                    child: Text(
                      post.sub?.removeHtmlTags.unescapeHtml ??
                          post.com?.replaceBrWithNewline.removeHtmlTags
                              .unescapeHtml ??
                          '',
                      softWrap: true,
                      maxLines: 3,
                      style: threadTitleTextStyle,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
