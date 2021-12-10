import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:mobichan/core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobichan/features/post/post.dart';
import 'package:mobichan_domain/mobichan_domain.dart';
import 'package:url_launcher/url_launcher.dart';

extension ContentWidgetHandlers on ContentWidget {
  void handleQuote(BuildContext context, int start, int end) {
    final html = insertATags(reply.com!
        .replaceAll(RegExp(r'\>\s+\<'), '><')
        .replaceAll('<br>', '\n'));
    final document = parse(html);
    final String parsedString =
        parse(document.body!.text).documentElement!.text.unescapeHtml;

    final String quote = parsedString.substring(start, end);
    context.read<PostFormCubit>().quote(quote, reply);
  }

  void handleTapUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false, universalLinksOnly: true);
    } else {
      throw Exception('Could not launch $url');
    }
  }

  void handleTapQuotelink(BuildContext context, String quotelink) {
    Post? quotedPost = threadReplies.getQuotedPost(quotelink);
    if (quotedPost == null) return;

    if (!inDialog) {
      showDialog(
        context: context,
        builder: (context) => RepliesPage(
            board: board,
            postReplies: [quotedPost],
            threadReplies: threadReplies),
      );
    } else {
      context.read<RepliesDialogCubit>().setReplies([quotedPost], null);
    }
  }
}
