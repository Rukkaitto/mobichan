import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mobichan/classes/models/post.dart';
import 'package:mobichan/constants.dart';
import 'package:mobichan/extensions/string_extension.dart';
import 'package:mobichan/pages/image_viewer_page.dart';
import 'package:mobichan/pages/replies_page.dart';
import 'package:mobichan/pages/webm_viewer_page.dart';
import 'package:mobichan/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class PostWidget extends StatelessWidget {
  final Post post;
  final String board;
  final Function? onTap;
  final double? height;
  final List<Post> threadReplies;
  final Function(int)? onPostNoTap;
  late List<Post> postReplies;

  PostWidget({
    required this.post,
    required this.board,
    required this.threadReplies,
    this.onTap,
    this.onPostNoTap,
    this.height,
  }) {
    postReplies = Utils.getReplies(threadReplies, post);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: () => onTap?.call(),
        child: Container(
          color: Theme.of(context).cardColor,
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                post.tim != null
                    ? PostImage(board: board, post: post)
                    : Container(),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.all(6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    EdgeInsets.only(top: 8, left: 8, right: 8),
                                child: PostHeader(
                                  post: post,
                                  onPostNoTap: onPostNoTap,
                                ),
                              ),
                              PostContent(
                                board: board,
                                post: post,
                                threadReplies: threadReplies,
                              ),
                            ],
                          ),
                        ),
                        if (postReplies.length > 0)
                          Padding(
                            padding: EdgeInsets.only(bottom: 8, right: 8),
                            child: PostFooter(
                                postReplies: postReplies,
                                board: board,
                                threadReplies: threadReplies),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PostFooter extends StatelessWidget {
  const PostFooter({
    Key? key,
    required this.postReplies,
    required this.threadReplies,
    required this.board,
  }) : super(key: key);

  final List<Post> postReplies;
  final List<Post> threadReplies;
  final String board;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        InkWell(
          child: Text(
            '${postReplies.length} ${postReplies.length > 1 ? 'replies' : 'reply'}',
            style: postNoTextStyle(context),
          ),
          onTap: () {
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (context, _, __) => RepliesPage(
                  postReplies,
                  board: board,
                  threadReplies: threadReplies,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class PostContent extends StatelessWidget {
  final String board;
  final Post post;
  final List<Post> threadReplies;

  const PostContent({
    Key? key,
    required this.board,
    required this.post,
    required this.threadReplies,
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
    print(str.removeWbr);
    final regExp = RegExp(
      r'(?<!(href="))http[s?]:\/\/[^\s<]+(?!<\/a>)',
    );
    return str.removeWbr.replaceAllMapped(regExp, (match) {
      return '<a href="${match.group(0)}">${match.group(0)}</a>';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Html(
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
          color: Theme.of(context).accentColor,
        ),
      },
    );
  }
}

class PostHeader extends StatelessWidget {
  const PostHeader({
    Key? key,
    this.onPostNoTap,
    required this.post,
  }) : super(key: key);

  final Post post;
  final Function(int)? onPostNoTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Row(
            children: [
              if (post.country != null)
                Padding(
                  padding: EdgeInsets.only(right: 6),
                  child: Image.network(
                    '$API_FLAGS_URL/${post.country!.toLowerCase()}.gif',
                  ),
                ),
              Flexible(
                child: Text(
                  post.name?.unescapeHtml ?? post.trip ?? 'Anonymous',
                  style: postNameTextStyle(context),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        InkWell(
          onTap: () => onPostNoTap?.call(post.no),
          child: Text(
            post.no.toString(),
            style: postNoTextStyle(context),
          ),
        ),
      ],
    );
  }
}

class PostImage extends StatelessWidget {
  const PostImage({
    Key? key,
    required this.board,
    required this.post,
  }) : super(key: key);

  final String board;
  final Post post;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () {
          if (post.ext == '.webm') {
            Navigator.of(context).push(
              PageRouteBuilder(
                opaque: false,
                pageBuilder: (context, _, __) => WebmViewerPage(board, post),
              ),
            );
          } else {
            Navigator.of(context).push(
              PageRouteBuilder(
                opaque: false,
                pageBuilder: (context, _, __) => ImageViewerPage(board, post),
              ),
            );
          }
        },
        child: Hero(
          tag: post.tim.toString(),
          child: Image.network(
            '$API_IMAGES_URL/$board/${post.tim}s.jpg',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
