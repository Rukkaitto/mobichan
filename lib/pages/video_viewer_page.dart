import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobichan/classes/models/post.dart';
import 'package:mobichan/constants.dart';
import 'package:video_player/video_player.dart';
import 'package:mobichan/extensions/duration_extension.dart';

class VideoViewerPage extends StatefulWidget {
  final String board;
  final Post post;
  const VideoViewerPage(this.board, this.post, {Key? key}) : super(key: key);

  @override
  _VideoViewerPageState createState() => _VideoViewerPageState();
}

class _VideoViewerPageState extends State<VideoViewerPage> {
  late VideoPlayerController _controller;
  bool _paused = false;
  bool _muted = false;
  bool _showControls = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
        '$API_IMAGES_URL/${widget.board}/${widget.post.tim}${widget.post.ext}')
      ..initialize().then((_) {
        setState(() {
          _controller.setLooping(true);
          _controller.play();
          _timer = startTimeout(seconds: 5);
          _controller.addListener(() {
            setState(() {});
          });
        });
      });
  }

  void handleTimeout() {
    setState(() {
      _showControls = false;
    });
  }

  Timer startTimeout({required int seconds}) {
    Duration duration = Duration(seconds: seconds);
    return Timer(duration, handleTimeout);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _controller.seekTo(Duration.zero);
        _controller.pause();
        return true;
      },
      child: Scaffold(
        backgroundColor: Color(0xaa000000),
        body: SafeArea(
          child: Center(
            child: Hero(
              tag: widget.post.tim.toString(),
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: _onTapVideo,
                    onVerticalDragUpdate: (details) {
                      if (details.delta.dy < 8) {
                        _controller.seekTo(Duration.zero);
                        _controller.pause();
                        Navigator.of(context).pop();
                      }
                    },
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                  if (_showControls)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            _muted = !_muted;
                            _controller.setVolume(_muted ? 0 : 1);
                          });
                        },
                        icon: Icon(_muted
                            ? Icons.volume_off_rounded
                            : Icons.volume_up_rounded),
                      ),
                    ),
                  if (_showControls)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        color: Color.fromARGB(100, 0, 0, 0),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            children: [
                              VideoProgressIndicator(_controller,
                                  allowScrubbing: true),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(_controller.value.position.formatted),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _paused = !_paused;
                                        if (_paused) {
                                          _controller.pause();
                                          _timer?.cancel();
                                        } else {
                                          _controller.play();
                                          _timer?.cancel();
                                          _timer = startTimeout(seconds: 5);
                                        }
                                      });
                                    },
                                    icon: Icon(_paused
                                        ? Icons.play_arrow_rounded
                                        : Icons.pause_rounded),
                                  ),
                                  Text(_controller.value.duration.formatted),
                                ],
                              ),
                            ],
                          ),
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

  void _onTapVideo() {
    setState(() {
      _showControls = !_showControls;
      if (!_paused) {
        _timer?.cancel();
        _timer = startTimeout(seconds: 3);
      }
    });
  }
}
