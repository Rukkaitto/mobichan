import 'dart:io';

import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:mobichan/core/core.dart';
import 'package:mobichan/core/extensions/string_extension.dart';
import 'package:mobichan/core/widgets/snackbars/success_snackbar.dart';
import 'package:mobichan/features/post/post.dart';
import 'package:mobichan/localization.dart';
import 'package:mobichan_domain/mobichan_domain.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

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
    final image = await screenshotController.capture();
    final result = await ImageGallerySaver.saveImage(
      image!,
      name: "post_${post.no}",
      quality: 60,
    );
    if (result['isSuccess'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        successSnackbar(context, savePostSuccess.tr()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        errorSnackbar(context, savePostError.tr()),
      );
    }
  }

  void handleShare() async {
    final image = await screenshotController.capture();
    if (image != null) {
      final directory = await getTemporaryDirectory();
      final imagePath = await File('${directory.path}/image.png').create();
      await imagePath.writeAsBytes(image);
      await Share.shareFiles([imagePath.path]);
    }
  }
}
