import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:mobichan/localization.dart';

import 'package:flutter/material.dart';
import 'package:mobichan/features/post/post.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

extension ReplyWidgetBuilders on ReplyWidget {
  Widget buildImage() {
    final imagePosts = threadReplies.imagePosts;
    final imageIndex = imagePosts.indexOf(post);

    return Builder(builder: (context) {
      return Padding(
        padding: const EdgeInsets.only(top: 5),
        child: InkWell(
          onTap: () => handleTapImage(
            context: context,
            board: board,
            imagePosts: imagePosts,
            imageIndex: imageIndex,
          ),
          child: Hero(
            tag: 'image$imageIndex',
            child: Material(
              child: ThumbnailWidget(
                board: board,
                post: post,
                height: Device.get().isTablet ? 380 : 180,
                borderRadius: 5,
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget buildNumber(BuildContext context) {
    return InkWell(
      onTap: () => handleReply(context, post),
      child: Text(
        '${post.no}',
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }

  Widget buildFlag() {
    if (board.countryFlags && post.country != null) {
      return Padding(
        padding: const EdgeInsets.only(right: 6),
        child: Image.network(post.countryFlagUrl!),
      );
    } else {
      return Container();
    }
  }

  Widget buildName() {
    return Flexible(
      child: Text(
        post.name ?? 'Anonymous',
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Positioned buildIndentBar() {
    return Positioned(
      left: 0,
      top: 5,
      bottom: 5,
      child: recursion > 0
          ? Container(
              width: 1,
              color: Colors.white,
            )
          : Container(),
    );
  }

  Widget buildFooter() {
    final replies = post.getReplies(threadReplies);
    return Builder(
      builder: (context) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (replies.isNotEmpty)
              TextButton(
                onPressed: () => handleTapReplies(context, post),
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).disabledColor, minimumSize: Size.zero,
                  padding: const EdgeInsets.only(top: 8),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(kReply.plural(replies.length)),
              ),
          ],
        );
      },
    );
  }

  Widget buildPopupMenuButton() {
    return PopupMenuButton(
      child: const Icon(Icons.more_horiz),
      itemBuilder: (context) => [
        PopupMenuItem(
          child: const Text(kReplyToPost).tr(),
          onTap: () => handleReply(context, post),
        ),
        PopupMenuItem(
          child: const Text(kShare).tr(),
          onTap: () => handleShare(),
        ),
        PopupMenuItem(
          child: const Text(kSaveToGallery).tr(),
          onTap: () => handleSave(context),
        ),
        PopupMenuItem(
          child: const Text(kReport).tr(),
          onTap: () => handleReport(),
        ),
      ],
    );
  }
}
