import 'package:flutter/material.dart';
import 'package:mobichan/features/post/post.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

class ThumbnailWidget extends StatefulWidget {
  final Board board;
  final Post post;
  final double height;
  final double borderRadius;
  final bool fullRes;

  const ThumbnailWidget({
    Key? key,
    required this.board,
    required this.post,
    required this.height,
    this.borderRadius = 0,
    this.fullRes = false,
  }) : super(key: key);

  @override
  State<ThumbnailWidget> createState() => ThumbnailWidgetState();
}

class ThumbnailWidgetState extends State<ThumbnailWidget> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: SizedBox(
        height: widget.height,
        child: ImageWidget(
          board: widget.board,
          post: widget.post,
          fullRes: widget.fullRes,
        ),
      ),
    );
  }
}
