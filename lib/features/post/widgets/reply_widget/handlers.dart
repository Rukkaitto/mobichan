import 'package:flutter/material.dart';
import 'package:mobichan/features/post/post.dart';
import 'package:mobichan_domain/mobichan_domain.dart';
import 'package:url_launcher/url_launcher.dart';

import 'reply_widget.dart';

extension ReplyWidgetHandlers on ReplyWidget {
  void handleTapUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false, universalLinksOnly: true);
    } else {
      throw Exception('Could not launch $url');
    }
  }

  void handleTapReplies(BuildContext context, Post post) {
    Navigator.of(context).pushNamed(
      RepliesPage.routeName,
      arguments: RepliesPageArguments(
        board: board,
        postReplies: post.getReplies(threadReplies),
        threadReplies: threadReplies,
      ),
    );
  }

  void handleTapQuotelink(BuildContext context, String quotelink) {
    int? quotedNo = int.tryParse(quotelink.substring(2));
    if (quotedNo == null) {
      return;
    }
    Post quotedPost = Post.getQuotedPost(threadReplies, quotedNo);

    Navigator.of(context).pushNamed(
      RepliesPage.routeName,
      arguments: RepliesPageArguments(
        board: board,
        postReplies: [quotedPost],
        threadReplies: threadReplies,
      ),
    );
  }

  void handleQuote(int start, int end) {
    // final html = insertATags(reply.com!
    //     .replaceAll(RegExp(r'\>\s+\<'), '><')
    //     .replaceAll('<br>', '\n'));
    // final document = parse(html);
    // final String parsedString =
    // parse(document.body!.text).documentElement!.text.unescapeHtml;

    // final String quote = parsedString.substring(start, end);
    // onPostQuote?.call(quote, reply.no);
  }
}
