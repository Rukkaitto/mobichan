import 'reply_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mobichan/features/post/post.dart';
import 'package:easy_localization/easy_localization.dart';

extension ReplyWidgetBuilders on ReplyWidget {
  Widget buildContent() {
    return Builder(builder: (context) {
      return SelectableHtml(
        selectionControls: PostTextSelectionControls(
          customButton: handleQuote,
        ),
        data: insertATags(reply.com),
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
    });
  }

  Padding buildImage() {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: ThumbnailWidget(
        board: board,
        post: reply,
        height: 180,
        borderRadius: 5,
      ),
    );
  }

  Text buildNumber(BuildContext context) {
    return Text(
      '${reply.no}',
      style: Theme.of(context).textTheme.caption,
    );
  }

  Widget buildName() {
    return Flexible(
      child: Text(
        reply.name ?? 'Anonymous',
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
    final replies = reply.getReplies(threadReplies);
    return Builder(
      builder: (context) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (replies.isNotEmpty)
              TextButton(
                onPressed: () => handleTapReplies(context, reply),
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
}
