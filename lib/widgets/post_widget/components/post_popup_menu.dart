import 'package:flutter/material.dart';
import 'package:mobichan/classes/models/post.dart';

class PostPopupMenu extends StatelessWidget {
  const PostPopupMenu({
    Key? key,
    required this.onPostNoTap,
    required this.post,
  }) : super(key: key);

  final Function(int no)? onPostNoTap;
  final Post post;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      padding: EdgeInsets.zero,
      onSelected: (selection) {
        switch (selection) {
          case 'quote':
            onPostNoTap?.call(post.no);
            break;
          default:
            break;
        }
      },
      itemBuilder: (context) {
        return <PopupMenuEntry>[
          PopupMenuItem(
            child: Text('Quote'),
            value: 'quote',
          ),
        ];
      },
      iconSize: 18,
    );
  }
}
