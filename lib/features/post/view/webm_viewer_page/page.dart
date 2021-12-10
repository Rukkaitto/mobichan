import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:mobichan/core/core.dart';
import 'package:mobichan/features/post/post.dart';
import 'package:mobichan_domain/mobichan_domain.dart';
import 'package:mobichan/constants.dart';

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
              SettingProvider(
                settingTitle: 'mute_webm',
                builder: (setting) => VideoPlayerWidget(
                  controller: widget.videoPlayerController!,
                  aspectRatio: widget.post.w! / widget.post.h!,
                  isMuted: setting.value,
                ),
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
