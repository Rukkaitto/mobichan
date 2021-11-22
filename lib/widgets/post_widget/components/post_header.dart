import 'package:flutter/material.dart';
import 'package:mobichan_domain/mobichan_domain.dart';
import 'package:mobichan/extensions/string_extension.dart';
import 'package:mobichan/widgets/post_widget/components/post_popup_menu.dart';

import '../../../constants.dart';

class PostHeader extends StatelessWidget {
  const PostHeader({
    Key? key,
    this.onPostNoTap,
    required this.onSave,
    required this.onShare,
    required this.post,
  }) : super(key: key);

  final Post post;
  final Function(int)? onPostNoTap;
  final Function() onSave;
  final Function() onShare;

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
                  padding: const EdgeInsets.only(right: 6),
                  child: Image.network(
                    '$apiFlagsUrl/${post.country!.toLowerCase()}.gif',
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
        Row(
          children: [
            InkWell(
              onTap: () => onPostNoTap?.call(post.no),
              child: Text(
                post.no.toString(),
                style: postNoTextStyle(context),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 22,
                maxWidth: 22,
              ),
              child: PostPopupMenu(
                onPostNoTap: onPostNoTap,
                onSave: onSave,
                onShare: onShare,
                post: post,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
