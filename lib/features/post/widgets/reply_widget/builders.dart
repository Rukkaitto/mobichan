import 'reply_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mobichan/features/post/post.dart';

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
            handleTapReplies(context, str!);
          } else {
            handleTapUrl(str!);
          }
        },
        style: {
          "body": Style(margin: EdgeInsets.all(0)),
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

  Text buildName() {
    return Text(
      reply.name ?? 'Anonymous',
      style: TextStyle(
        fontWeight: FontWeight.bold,
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
}
