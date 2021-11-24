import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mobichan/core/extensions/string_extension.dart';
import 'package:mobichan/localization.dart';
import 'package:easy_localization/easy_localization.dart';

import 'thread_widget.dart';

extension ThreadWidgetBuilders on ThreadWidget {
  Widget buildContent() {
    if (inThread && thread.com != null) {
      return Html(data: thread.com);
    } else {
      return Container();
    }
  }

  Widget buildFooter(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            thread.userName,
            style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            width: 160.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildSticky(context),
                buildReplies(context),
                buildImages(context),
                buildPopupMenuButton()
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSticky(BuildContext context) {
    if (thread.sticky != null) {
      return Row(
        children: [
          Icon(
            Icons.push_pin,
            size: iconSize,
          ),
        ],
      );
    } else {
      return Container();
    }
  }

  Widget buildReplies(BuildContext context) {
    if (thread.replies != null) {
      return Row(
        children: [
          Icon(
            Icons.reply,
            size: iconSize,
          ),
          spacingBetweenIconAndText,
          Text(
            '${thread.replies}',
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ],
      );
    } else {
      return Container();
    }
  }

  Widget buildImages(BuildContext context) {
    if (thread.images != null) {
      return Row(
        children: [
          Icon(
            Icons.image,
            size: iconSize,
          ),
          spacingBetweenIconAndText,
          Text(
            '${thread.images}',
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ],
      );
    } else {
      return Container();
    }
  }

  Widget buildLoading(ImageChunkEvent? loadingProgress) {
    if (loadingProgress != null) {
      return CircularProgressIndicator(
        value: loadingProgress.cumulativeBytesLoaded /
            loadingProgress.expectedTotalBytes!,
      );
    } else {
      return const CircularProgressIndicator();
    }
  }

  Widget buildTitle(BuildContext context) {
    String? title;
    if (inThread) {
      title = thread.sub?.removeHtmlTags;
    } else {
      title = thread.displayTitle.removeHtmlTags;
    }

    if (title != null) {
      return Padding(
        padding: padding,
        child: Text(
          thread.displayTitle.removeHtmlTags,
          softWrap: true,
          maxLines: maxLines,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.headline2,
        ),
      );
    } else {
      return Container();
    }
  }

  PopupMenuButton<dynamic> buildPopupMenuButton() {
    return PopupMenuButton(
      child: Icon(
        Icons.more_vert,
        size: iconSize,
      ),
      padding: EdgeInsets.zero,
      itemBuilder: (context) => [
        PopupMenuItem(
          child: const Text(replyToPost).tr(),
          onTap: () => handleReply(context),
        ),
      ],
    );
  }
}
