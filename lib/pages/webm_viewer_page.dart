import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:mobichan_domain/mobichan_domain.dart';
import 'package:mobichan/constants.dart';
import 'package:mobichan/widgets/video_player_widget/video_player_widget.dart';

class WebmViewerPage extends StatefulWidget {
  final Post post;
  final VlcPlayerController? videoPlayerController;
  const WebmViewerPage(this.post, this.videoPlayerController, {Key? key})
      : super(key: key);

  @override
  _VideoViewerPageState createState() => _VideoViewerPageState();
}

class _VideoViewerPageState extends State<WebmViewerPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: transparentColor,
      body: SafeArea(
        child: Center(
          child: Stack(
            children: [
              VideoPlayerWidget(
                controller: widget.videoPlayerController!,
                aspectRatio: widget.post.w! / widget.post.h!,
              ),
              Positioned(
                top: 50,
                left: 0,
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.close),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
