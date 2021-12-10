/// Open source credits and use from https://github.com/solid-software/flutter_vlc_player/blob/master/flutter_vlc_player/example/lib/vlc_player_with_controls.dart
import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:mobichan/constants.dart';
import 'package:mobichan/features/post/post.dart';
import 'package:mobichan/localization.dart';

class VideoPlayerWidget extends StatefulWidget {
  final VlcPlayerController controller;
  final bool showControls;
  final double aspectRatio;
  final bool isMuted;

  const VideoPlayerWidget({
    Key? key,
    required this.controller,
    required this.aspectRatio,
    required this.isMuted,
    this.showControls = true,
  }) : super(key: key);

  @override
  VideoPlayerWidgetState createState() => VideoPlayerWidgetState();
}

class VideoPlayerWidgetState extends State<VideoPlayerWidget>
    with AutomaticKeepAliveClientMixin {
  static const _playerControlsBgColor = Colors.black87;

  VlcPlayerController? _controller;

  //
  final double initSnapshotRightPosition = 10;
  final double initSnapshotBottomPosition = 10;
  OverlayEntry? _overlayEntry;

  //
  double sliderValue = 0.0;
  double volumeValue = 50;
  String position = '';
  String duration = '';
  int numberOfCaptions = 0;
  int numberOfAudioTracks = 0;
  bool validPosition = false;

  //
  List<double> playbackSpeeds = [0.5, 1.0, 2.0];
  int playbackSpeedIndex = 1;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    _controller!.addListener(listener);
    checkMuted();
  }

  void checkMuted() {
    if (widget.isMuted) {
      _setSoundVolume(0.0);
    }
  }

  @override
  Future<void> dispose() async {
    await _controller!.dispose();
    super.dispose();
  }

  void listener() async {
    if (!mounted) return;
    //
    if (_controller!.value.isInitialized) {
      var oPosition = _controller!.value.position;
      var oDuration = _controller!.value.duration;
      if (oDuration.inHours == 0) {
        var strPosition = oPosition.toString().split('.')[0];
        var strDuration = oDuration.toString().split('.')[0];
        position = "${strPosition.split(':')[1]}:${strPosition.split(':')[2]}";
        duration = "${strDuration.split(':')[1]}:${strDuration.split(':')[2]}";
      } else {
        position = oPosition.toString().split('.')[0];
        duration = oDuration.toString().split('.')[0];
      }
      validPosition = oDuration.compareTo(oPosition) >= 0;
      sliderValue = validPosition ? oPosition.inSeconds.toDouble() : 0;
      numberOfCaptions = _controller!.value.spuTracksCount;
      numberOfAudioTracks = _controller!.value.audioTracksCount;
      //
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Visibility(
          visible: widget.showControls,
          child: Container(
            width: double.infinity,
            color: _playerControlsBgColor,
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              children: [
                Wrap(
                  children: [
                    Stack(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.timer),
                          color: Colors.white,
                          onPressed: _cyclePlaybackSpeed,
                        ),
                        Positioned(
                          bottom: 7,
                          right: 3,
                          child: IgnorePointer(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(1),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 1,
                                horizontal: 2,
                              ),
                              child: Text(
                                '${playbackSpeeds.elementAt(playbackSpeedIndex)}x',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      tooltip: 'Get Snapshot',
                      icon: const Icon(Icons.camera),
                      color: Colors.white,
                      onPressed: _createCameraImage,
                    ),
                    IconButton(
                      icon: const Icon(Icons.cast),
                      color: Colors.white,
                      onPressed: _getRendererDevices,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Size: ' +
                            (_controller!.value.size.width.toInt()).toString() +
                            'x' +
                            (_controller!.value.size.height.toInt()).toString(),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 10),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Status: ' +
                            _controller!.value.playingState
                                .toString()
                                .split('.')[1],
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            color: transparentColor,
            child: Stack(
              children: <Widget>[
                Center(
                  child: VlcPlayer(
                    controller: _controller!,
                    aspectRatio: widget.aspectRatio,
                    placeholder:
                        const Center(child: CircularProgressIndicator()),
                  ),
                ),
                VideoPlayerControlsWidget(controller: _controller),
              ],
            ),
          ),
        ),
        Visibility(
          visible: widget.showControls,
          child: Container(
            color: _playerControlsBgColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  color: Colors.white,
                  icon: _controller!.value.isPlaying
                      ? const Icon(Icons.pause_circle_outline)
                      : const Icon(Icons.play_circle_outline),
                  onPressed: _togglePlaying,
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        position,
                        style: const TextStyle(color: Colors.white),
                      ),
                      Expanded(
                        child: Slider(
                          activeColor: Colors.redAccent,
                          inactiveColor: Colors.white70,
                          value: sliderValue,
                          min: 0.0,
                          max: (!validPosition)
                              ? 1.0
                              : _controller!.value.duration.inSeconds
                                  .toDouble(),
                          onChanged:
                              validPosition ? _onSliderPositionChanged : null,
                        ),
                      ),
                      Text(
                        duration,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Visibility(
          visible: widget.showControls,
          child: Container(
            color: _playerControlsBgColor,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                const Icon(
                  Icons.volume_down,
                  color: Colors.white,
                ),
                Expanded(
                  child: Slider(
                    min: 0,
                    max: 100,
                    value: volumeValue,
                    onChanged: _setSoundVolume,
                  ),
                ),
                const Icon(
                  Icons.volume_up,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _cyclePlaybackSpeed() async {
    playbackSpeedIndex++;
    if (playbackSpeedIndex >= playbackSpeeds.length) {
      playbackSpeedIndex = 0;
    }
    return await _controller!
        .setPlaybackSpeed(playbackSpeeds.elementAt(playbackSpeedIndex));
  }

  void _setSoundVolume(value) {
    setState(() {
      volumeValue = value;
    });
    _controller!.setVolume(volumeValue.toInt());
  }

  void _togglePlaying() async {
    _controller!.value.isPlaying
        ? await _controller!.pause()
        : await _controller!.play();
  }

  void _onSliderPositionChanged(double progress) {
    setState(() {
      sliderValue = progress.floor().toDouble();
    });
    //convert to Milliseconds since VLC requires MS to set time
    _controller!.setTime(sliderValue.toInt() * 1000);
  }

  void _getRendererDevices() async {
    var castDevices = await _controller!.getRendererDevices();
    //
    if (castDevices.isNotEmpty) {
      var selectedCastDeviceName = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Display Devices'),
            content: SizedBox(
              width: double.maxFinite,
              height: 250,
              child: ListView.builder(
                itemCount: castDevices.keys.length + 1,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      index < castDevices.keys.length
                          ? castDevices.values.elementAt(index).toString()
                          : 'Disconnect',
                    ),
                    onTap: () {
                      Navigator.pop(
                        context,
                        index < castDevices.keys.length
                            ? castDevices.keys.elementAt(index)
                            : null,
                      );
                    },
                  );
                },
              ),
            ),
          );
        },
      );
      await _controller!.castToRenderer(selectedCastDeviceName);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: const Text(kNoDisplayDevice).tr()));
    }
  }

  void _createCameraImage() async {
    var snapshot = await _controller!.takeSnapshot();
    _overlayEntry?.remove();
    _overlayEntry = _createSnapshotThumbnail(snapshot);
    Overlay.of(context)!.insert(_overlayEntry!);
  }

  OverlayEntry _createSnapshotThumbnail(Uint8List snapshot) {
    var right = initSnapshotRightPosition;
    var bottom = initSnapshotBottomPosition;
    return OverlayEntry(
      builder: (context) => Positioned(
        right: right,
        bottom: bottom,
        width: 100,
        child: Material(
          elevation: 4.0,
          child: GestureDetector(
            onTap: () async {
              _overlayEntry?.remove();
              _overlayEntry = null;
              await showDialog(
                context: context,
                builder: (ctx) {
                  return AlertDialog(
                    contentPadding: const EdgeInsets.all(0),
                    content: Image.memory(snapshot),
                  );
                },
              );
            },
            onVerticalDragUpdate: (dragUpdateDetails) {
              bottom -= dragUpdateDetails.delta.dy;
              _overlayEntry!.markNeedsBuild();
            },
            onHorizontalDragUpdate: (dragUpdateDetails) {
              right -= dragUpdateDetails.delta.dx;
              _overlayEntry!.markNeedsBuild();
            },
            onHorizontalDragEnd: (dragEndDetails) {
              if ((initSnapshotRightPosition - right).abs() >= 100) {
                _overlayEntry?.remove();
                _overlayEntry = null;
              } else {
                right = initSnapshotRightPosition;
                _overlayEntry!.markNeedsBuild();
              }
            },
            onVerticalDragEnd: (dragEndDetails) {
              if ((initSnapshotBottomPosition - bottom).abs() >= 100) {
                _overlayEntry?.remove();
                _overlayEntry = null;
              } else {
                bottom = initSnapshotBottomPosition;
                _overlayEntry!.markNeedsBuild();
              }
            },
            child: Image.memory(snapshot),
          ),
        ),
      ),
    );
  }
}
