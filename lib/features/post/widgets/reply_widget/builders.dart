import 'package:mobichan/localization.dart';

import 'reply_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mobichan/features/post/post.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

extension ReplyWidgetBuilders on ReplyWidget {
  Widget buildContent() {
    return Builder(
      builder: (context) {
        return SelectableHtml(
          selectionControls: PostTextSelectionControls(
            customButton: (start, end) => handleQuote(context, start, end),
          ),
          data: insertATags(post.com),
          onAnchorTap: (str, renderContext, attributes, element) {
            if (attributes['class'] == 'quotelink') {
              handleTapQuotelink(context, str!);
            } else {
              handleTapUrl(str!);
            }
          },
          style: {
            "body": Style(margin: const EdgeInsets.all(0)),
            "a": Style(
              color: Colors.lightBlueAccent,
            ),
            ".quote": Style(
              color: Colors.green.shade300,
            ),
            ".quotelink": Style(
              color: Theme.of(context).colorScheme.secondary,
            ),
          },
        );
      },
    );
  }

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
                height: 180,
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
        style: Theme.of(context).textTheme.caption,
      ),
    );
  }

  Widget buildFlag() {
    if (board.countryFlags) {
      return Padding(
        padding: const EdgeInsets.only(right: 6),
        child: Image.network(post.countryFlagUrl),
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
                  padding: const EdgeInsets.all(0),
                  primary: Theme.of(context).disabledColor,
                ),
                child: Text('reply'.plural(replies.length)),
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
          child: const Text(replyToPost).tr(),
          onTap: () => handleReply(context, post),
        ),
        PopupMenuItem(
          child: const Text(share).tr(),
          onTap: () => handleShare(),
        ),
        PopupMenuItem(
          child: const Text(saveToGallery).tr(),
          onTap: () => handleSave(context),
        ),
        PopupMenuItem(
          child: const Text(report).tr(),
          onTap: () => handleReport(),
        ),
      ],
    );
  }
}
