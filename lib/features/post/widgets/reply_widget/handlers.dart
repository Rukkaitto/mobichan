import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:mobichan/core/core.dart';
import 'package:mobichan/features/post/post.dart';
import 'package:mobichan/localization.dart';
import 'package:mobichan_domain/mobichan_domain.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

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
            replyingTo: post,
            postReplies: postReplies,
            threadReplies: threadReplies),
      );
    } else {
      context.read<RepliesDialogCubit>().setReplies(postReplies, post);
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

  void handleQuote(BuildContext context, int start, int end) {
    final html = insertATags(post.com!
        .replaceAll(RegExp(r'\>\s+\<'), '><')
        .replaceAll('<br>', '\n'));
    final document = parse(html);
    final String parsedString =
        parse(document.body!.text).documentElement!.text.unescapeHtml;

    final String quote = parsedString.substring(start, end);
    context.read<PostFormCubit>().quote(quote, post);
  }

  void handleReply(BuildContext context, Post reply) {
    context.read<PostFormCubit>().reply(reply);
  }

  void handleReport() async {
    final url =
        'https://sys.4channel.org/${board.board}/imgboard.php?mode=report&no=${post.no}';
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false, universalLinksOnly: true);
    } else {
      throw Exception('Could not launch $url');
    }
  }

  void handleSave(BuildContext context) async {
    FirebaseAnalytics.instance.logEvent(name: 'screenshot_post');
    final image = await screenshotController.capture();
    final result = await ImageGallerySaver.saveImage(
      image!,
      name: "post_${post.no}",
      quality: 60,
    );
    if (result['isSuccess'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        successSnackbar(context, kSavePostSuccess.tr()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        errorSnackbar(context, kSavePostError.tr()),
      );
    }
  }

  void handleShare() async {
    FirebaseAnalytics.instance.logEvent(name: 'screenshot_post');
    final image = await screenshotController.capture();
    if (image != null) {
      final directory = await getTemporaryDirectory();
      final imagePath = await File('${directory.path}/image.png').create();
      await imagePath.writeAsBytes(image);
      await Share.shareFiles([imagePath.path]);
    }
  }
}
