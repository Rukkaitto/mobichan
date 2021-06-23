import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mobichan/classes/arguments/thread_page_arguments.dart';
import 'package:mobichan/classes/models/post.dart';
import 'package:mobichan/constants.dart';
import 'package:mobichan/pages/thread_page.dart';

class PostWidget extends StatelessWidget {
  final Post post;
  final String board;
  final Function? onTap;
  final double? height;

  const PostWidget(
      {required this.post, required this.board, this.onTap, this.height});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap?.call(),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 3,
            ),
          ],
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              post.tim != null
                  ? Container(
                      width: 150,
                      child: Image.network(
                          '$API_IMAGES_URL/$board/${post.tim}s.jpg'))
                  : Container(),
              Flexible(
                child: Html(
                  data: post.com,
                  onAnchorTap: (str, _, __, ___) {
                    print(str);
                  },
                  style: {
                    ".quote": Style(
                      color: Colors.green,
                    ),
                    ".quotelink": Style(
                      color: Colors.red,
                    ),
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
