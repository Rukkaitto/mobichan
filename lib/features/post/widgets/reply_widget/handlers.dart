import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:mobichan/core/core.dart';
import 'package:mobichan/core/extensions/string_extension.dart';
import 'package:mobichan/features/post/post.dart';
import 'package:mobichan_domain/mobichan_domain.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'reply_widget.dart';

extension ReplyWidgetHandlers on ReplyWidget {
  void handleTapImage({
    required BuildContext context,
    required Board board,
    required List<Post> imagePosts,
    required int imageIndex,
  }) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (context, _, __) => CarouselPage(
          board: board,
          posts: imagePosts,
          imageIndex: imageIndex,
          heroTitle: "image$imageIndex",
        ),
      ),
    );
  }

  void handleTapUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false, universalLinksOnly: true);
    } else {
      throw Exception('Could not launch $url');
    }
  }

  void handleTapReplies(BuildContext context, Post post) {
    final postReplies = post.getReplies(threadReplies);
    if (!inDialog) {
      showDialog(
        context: context,
        builder: (context) => RepliesPage(
            board: board,
            postReplies: postReplies,
            threadReplies: threadReplies),
      );
    } else {
      context.read<RepliesDialogCubit>().setReplies(postReplies);
    }
  }

  void handleTapQuotelink(BuildContext context, String quotelink) {
    int? quotedNo = int.tryParse(quotelink.substring(2));
    if (quotedNo == null) {
      return;
    }
    Post quotedPost = Post.getQuotedPost(threadReplies, quotedNo);

    if (!inDialog) {
      showDialog(
        context: context,
        builder: (context) => RepliesPage(
            board: board,
            postReplies: [quotedPost],
            threadReplies: threadReplies),
      );
    } else {
      context.read<RepliesDialogCubit>().setReplies([quotedPost]);
    }
  }

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

  void handleTapNumber(BuildContext context, Post reply) {
    context.read<PostFormCubit>().reply(reply);
  }

  void handleReport() async {
    final url =
        'https://sys.4channel.org/${board.board}/imgboard.php?mode=report&no=${reply.no}';
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false, universalLinksOnly: true);
    } else {
      throw Exception('Could not launch $url');
    }
  }
}
