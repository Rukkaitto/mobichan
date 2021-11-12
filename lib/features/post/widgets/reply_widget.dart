import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

class ReplyWidget extends StatelessWidget {
  final Post reply;
  final int recursion;
  final int maxRecursion = 5;

  const ReplyWidget({required this.reply, required this.recursion, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10.0 * recursion),
          child: Column(
            children: [
              Text('${reply.no}'),
              Html(data: reply.com ?? ''),
            ],
          ),
        ),
      ],
    );
  }
}
