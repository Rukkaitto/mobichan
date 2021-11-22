import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mobichan_domain/mobichan_domain.dart';
import 'package:mobichan/localization.dart';

class PostPopupMenu extends StatelessWidget {
  const PostPopupMenu({
    Key? key,
    required this.onPostNoTap,
    required this.onSave,
    required this.onShare,
    required this.post,
  }) : super(key: key);

  final Function(int no)? onPostNoTap;
  final Function() onSave;
  final Function() onShare;
  final Post post;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      padding: EdgeInsets.zero,
      onSelected: (selection) {
        switch (selection) {
          case 'reply':
            onPostNoTap?.call(post.no);
            break;
          case 'share':
            onShare();
            break;
          case 'save':
            onSave();
            break;
          default:
            break;
        }
      },
      itemBuilder: (context) {
        return <PopupMenuEntry>[
          PopupMenuItem(
            child: const Text(replyToPost).tr(),
            value: 'reply',
          ),
          PopupMenuItem(
            child: const Text(share).tr(),
            value: 'share',
          ),
          PopupMenuItem(
            child: const Text(saveToGallery).tr(),
            value: 'save',
          ),
        ];
      },
      iconSize: 18,
    );
  }
}
