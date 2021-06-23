import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mobichan/classes/arguments/thread_page_arguments.dart';
import 'package:mobichan/classes/models/post.dart';
import 'package:mobichan/pages/thread_page.dart';

class ThreadWidget extends StatelessWidget {
  final Post post;
  final String board;

  const ThreadWidget({required this.post, required this.board});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ThreadPage(
              args: ThreadPageArguments(
                  board: board, title: post.sub != '' ? post.sub : post.com),
            ),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 3,
              ),
            ],
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Html(
              data: post.com,
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
        ),
      ),
    );
  }
}
