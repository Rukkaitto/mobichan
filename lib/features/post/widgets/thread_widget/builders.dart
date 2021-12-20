import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mobichan/core/extensions/string_extension.dart';
import 'package:mobichan/features/post/post.dart';
import 'package:mobichan/localization.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:timeago/timeago.dart' as timeago;

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
      padding: inGrid ? gridPadding : padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          buildFlag(),
          buildName(),
          const SizedBox(width: 5),
          buildDate(),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildSticky(context),
              const SizedBox(width: 10),
              buildReplies(context),
              const SizedBox(width: 10),
              buildImages(context),
              if (!inGrid) const SizedBox(width: 10),
              if (!inGrid) buildPopupMenuButton()
            ],
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

  Widget buildFlag() {
    if (board.countryFlags && thread.country != null) {
      return Padding(
        padding: const EdgeInsets.only(right: 6),
        child: Image.network(thread.countryFlagUrl!),
      );
    } else {
      return Container();
    }
  }

  Widget buildImage() {
    return InkWell(
      onTap: onImageTap,
      child: ThumbnailWidget(
        board: board,
        post: thread,
        height: inGrid
            ? (Device.get().isTablet ? 200 : 130)
            : (Device.get().isTablet ? 380 : 250),
        fullRes: true,
      ),
    );
  }

  Widget buildPopupMenuButton() {
    return PopupMenuButton(
      child: Icon(
        Icons.more_vert,
        size: iconSize,
      ),
      padding: EdgeInsets.zero,
      itemBuilder: (context) => [
        if (inThread)
          PopupMenuItem(
            child: const Text(kReplyToPost).tr(),
            onTap: () => handleReply(context),
          ),
        PopupMenuItem(
          child: const Text(kShare).tr(),
          onTap: () => handleShare(),
        ),
        PopupMenuItem(
          child: const Text(kSaveToGallery).tr(),
          onTap: () => handleSave(context),
        ),
        PopupMenuItem(
          child: const Text(kReport).tr(),
          onTap: () => handleReport(),
        ),
      ],
    );
  }

  Widget buildDate() {
    return Visibility(
      visible: !inGrid,
      child: Builder(
        builder: (context) {
          final date = DateTime.fromMillisecondsSinceEpoch(thread.time * 1000);
          return Text(
            timeago.format(date),
            style: Theme.of(context).textTheme.caption,
          );
        },
      ),
    );
  }

  Widget buildName() {
    return Builder(
      builder: (context) {
        return Visibility(
          visible: !inGrid,
          child: Text(
            thread.userName,
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }
}
