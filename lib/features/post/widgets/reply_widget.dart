import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart';
import 'package:mobichan/features/post/post.dart';
import 'package:mobichan/features/core/core.dart';
import 'package:mobichan_domain/mobichan_domain.dart';
import 'package:url_launcher/url_launcher.dart';

class ReplyWidget extends StatelessWidget {
  final Board board;
  final Post reply;
  final List<Post> threadReplies;
  final int recursion;

  const ReplyWidget({
    required this.board,
    required this.reply,
    required this.threadReplies,
    required this.recursion,
    Key? key,
  }) : super(key: key);

  double computePadding(int recursion) {
    if (recursion == 0 || recursion == 1) {
      return 0;
    } else {
      return 15.0 * (recursion - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: computePadding(recursion)),
            child: Stack(
              children: [
                buildIndentBar(),
                Padding(
                  padding: EdgeInsets.only(left: recursion > 0 ? 14 : 0),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          buildName(),
                          SizedBox(width: 5),
                          buildNumber(context),
                        ],
                      ),
                      buildImage(),
                      SizedBox(height: 5),
                      buildContent(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildContent() {
    return Builder(builder: (context) {
      return SelectableHtml(
        selectionControls: PostTextSelectionControls(
          customButton: onQuote,
        ),
        data: insertATags(reply.com),
        onAnchorTap: (str, renderContext, attributes, element) {
          if (attributes['class'] == 'quotelink') {
            openRepliesPage(context, str!);
          } else {
            openUrl(str!);
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
    Post quotedPost = Post.getQuotedPost(threadReplies, quotedNo);

    // Navigator.of(context).push(
    //   PageRouteBuilder(
    //     pageBuilder: (context, _, __) => RepliesPage(
    //       [quotedPost],
    //       board: board,
    //       threadReplies: threadReplies,
    //     ),
    //   ),
    // );
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
    final html = insertATags(reply.com!
        .replaceAll(RegExp(r'\>\s+\<'), '><')
        .replaceAll('<br>', '\n'));
    final document = parse(html);
    final String parsedString =
        parse(document.body!.text).documentElement!.text.unescapeHtml;

    final String quote = parsedString.substring(start, end);
    // onPostQuote?.call(quote, reply.no);
  }
}
