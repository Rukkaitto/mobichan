import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart';
import 'package:mobichan/classes/entities/post.dart';
import 'package:mobichan/extensions/string_extension.dart';
import 'package:mobichan/pages/replies_page.dart';
import 'package:mobichan/utils/utils.dart';
import 'package:mobichan/widgets/post_widget/components/post_text_selection_controls.dart';
import 'package:url_launcher/url_launcher.dart';

class PostContent extends StatelessWidget {
  final String board;
  final Post post;
  final List<Post> threadReplies;
  final Function(String quote, int postId)? onPostQuote;

  const PostContent({
    Key? key,
    required this.board,
    required this.post,
    required this.threadReplies,
    this.onPostQuote,
  }) : super(key: key);

  void openUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false, universalLinksOnly: true);
    } else {
      throw Exception('Could not launch $url');
    }
  }

  void openRepliesPage(BuildContext context, String quotelink) {
    int? quotedNo = int.tryParse(quotelink.substring(2));
    if (quotedNo == null) {
      return;
    }
    Post quotedPost = Utils.getQuotedPost(threadReplies, quotedNo);

    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, _, __) => RepliesPage(
          [quotedPost],
          board: board,
          threadReplies: threadReplies,
        ),
      ),
    );
  }

  String insertATags(String? str) {
    if (str == null) {
      return '';
    }
    final regExp = RegExp(
      r'(?<!(href="))http[s?]:\/\/[^\s<]+(?!<\/a>)',
    );
    return str.removeWbr.replaceAllMapped(regExp, (match) {
      return '<a href="${match.group(0)}">${match.group(0)}</a>';
    });
  }

  void onQuote(int start, int end) {
    final html = insertATags(post.com!
        .replaceAll(RegExp(r'\>\s+\<'), '><')
        .replaceAll('<br>', '\n'));
    final document = parse(html);
    final String parsedString =
        parse(document.body!.text).documentElement!.text.unescapeHtml;

    final String quote = parsedString.substring(start, end);
    onPostQuote?.call(quote, post.no);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SelectableHtml(
        selectionControls: PostTextSelectionControls(
          customButton: onQuote,
        ),
        data: insertATags(post.com),
        onAnchorTap: (str, renderContext, attributes, element) {
          if (attributes['class'] == 'quotelink') {
            openRepliesPage(context, str!);
          } else {
            openUrl(str!);
          }
        },
        style: {
          "a": Style(
            color: Colors.lightBlueAccent,
          ),
          ".quote": Style(
            color: Colors.green.shade300,
          ),
          ".quotelink": Style(
            color: Theme.of(context).colorScheme.primary,
          ),
        },
      ),
    );
  }
}
