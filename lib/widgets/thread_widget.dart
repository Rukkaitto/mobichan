import 'package:flutter/material.dart';
import 'package:mobichan/classes/models/post.dart';

class ThreadWidget extends StatelessWidget {
  final Post post;

  const ThreadWidget(this.post);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(post.com ?? ''),
        ),
      ),
    );
  }
}
