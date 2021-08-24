import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:mobichan/classes/models/post.dart';
import 'package:mobichan/utils/utils.dart';
import 'package:mobichan/widgets/post_widget/components/post_content.dart';
import 'package:mobichan/widgets/post_widget/components/post_footer.dart';
import 'package:mobichan/widgets/post_widget/components/post_header.dart';
import 'package:mobichan/widgets/post_widget/components/post_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';

// ignore: must_be_immutable
class PostWidget extends StatefulWidget {
  final Post post;
  final String board;
  final Function? onTap;
  final double? height;
  final List<Post> threadReplies;
  final Function(int)? onPostNoTap;
  late List<Post> postReplies;
  final bool? showReplies;

  PostWidget({
    required this.post,
    required this.board,
    required this.threadReplies,
    this.onTap,
    this.onPostNoTap,
    this.height,
    this.showReplies,
  }) {
    postReplies = Utils.getReplies(threadReplies, post);
  }

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  ScreenshotController _screenshotController = ScreenshotController();

  dynamic convertPostToImage() async {
    final image = await _screenshotController.capture();
    final result = await ImageGallerySaver.saveImage(
      image!,
      name: "post_${widget.post.no}",
      quality: 60,
    );
    return result;
  }

  void onShare() async {
    final image = await _screenshotController.capture();
    if (image != null) {
      final directory = await getTemporaryDirectory();
      final imagePath = await File('${directory.path}/image.png').create();
      await imagePath.writeAsBytes(image);
      await Share.shareFiles([imagePath.path]);
    }
  }

  void onSave() async {
    final result = await convertPostToImage();
    if (result['isSuccess'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        Utils.buildSnackBar(
          context,
          "Post saved to gallery.",
          Theme.of(context).cardColor,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        Utils.buildSnackBar(
          context,
          "Could not save post to gallery.",
          Theme.of(context).errorColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: () => widget.onTap?.call(),
        child: Screenshot(
          controller: _screenshotController,
          child: Container(
            color: Theme.of(context).cardColor,
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  widget.post.tim != null
                      ? PostImage(board: widget.board, post: widget.post)
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
                                  padding: EdgeInsets.only(
                                      top: 8, left: 8, right: 8),
                                  child: PostHeader(
                                    post: widget.post,
                                    onPostNoTap: widget.onPostNoTap,
                                    onSave: onSave,
                                    onShare: onShare,
                                  ),
                                ),
                                PostContent(
                                  board: widget.board,
                                  post: widget.post,
                                  threadReplies: widget.threadReplies,
                                ),
                              ],
                            ),
                          ),
                          if (widget.showReplies != false &&
                              widget.postReplies.length > 0)
                            Padding(
                              padding: EdgeInsets.only(bottom: 8, right: 8),
                              child: PostFooter(
                                  postReplies: widget.postReplies,
                                  board: widget.board,
                                  threadReplies: widget.threadReplies),
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
      ),
    );
  }
}
