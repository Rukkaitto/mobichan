import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:mobichan/classes/models/post.dart';
import 'package:mobichan/constants.dart';
import 'package:mobichan/widgets/vlc_player_with_controls_widget.dart';

class WebmViewerPage extends StatefulWidget {
  final String board;
  final Post post;
  const WebmViewerPage(this.board, this.post, {Key? key}) : super(key: key);

  @override
  _VideoViewerPageState createState() => _VideoViewerPageState();
}

class _VideoViewerPageState extends State<WebmViewerPage> {
  late VlcPlayerController _videoPlayerController;
  @override
  void initState() {
    super.initState();

    _videoPlayerController = VlcPlayerController.network(
      '$API_IMAGES_URL/${widget.board}/${widget.post.tim}${widget.post.ext}',
      hwAcc: HwAcc.FULL,
      autoPlay: true,
      options: VlcPlayerOptions(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _videoPlayerController.seekTo(Duration.zero);
        _videoPlayerController.pause();
        return true;
      },
      child: Scaffold(
        backgroundColor: TRANSPARENT_COLOR,
        body: SafeArea(
          child: Center(
            child: Hero(
              tag: widget.post.tim.toString(),
              child: Stack(
                children: [
                  VlcPlayerWithControls(
                      controller: _videoPlayerController,
                      aspectRatio: widget.post.w! / widget.post.h!),
                  Positioned(
                    top: 50,
                    left: 0,
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          Navigator.of(context).pop();
                        });
                      },
                      icon: Icon(Icons.close),
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
