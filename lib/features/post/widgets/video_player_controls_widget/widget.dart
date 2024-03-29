/// Open source credits and use from https://github.com/solid-software/flutter_vlc_player/blob/master/flutter_vlc_player/example/lib/controls_overlay.dart
import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

class VideoPlayerControlsWidget extends StatelessWidget {
  const VideoPlayerControlsWidget({Key? key, this.controller})
      : super(key: key);

  final VlcPlayerController? controller;

  //static const double _playButtonIconSize = 80;
  static const double _replayButtonIconSize = 100;
  //static const double _seekButtonIconSize = 48;

  //static const Duration _seekStepForward = Duration(seconds: 10);
  //static const Duration _seekStepBackward = Duration(seconds: -10);

  static const Color _iconColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 50),
      reverseDuration: const Duration(milliseconds: 200),
      child: Builder(
        builder: (ctx) {
          if (controller!.value.isEnded || controller!.value.hasError) {
            return Center(
              child: FittedBox(
                child: IconButton(
                  onPressed: _replay,
                  color: _iconColor,
                  iconSize: _replayButtonIconSize,
                  icon: const Icon(Icons.replay),
                ),
              ),
            );
          }

          switch (controller!.value.playingState) {
            case PlayingState.initialized:
            case PlayingState.stopped:
            case PlayingState.paused:
              return GestureDetector(onTap: _play);

            case PlayingState.buffering:
            case PlayingState.playing:
              return GestureDetector(onTap: _pause);

            case PlayingState.ended:
            case PlayingState.error:
              return Center(
                child: FittedBox(
                  child: IconButton(
                    onPressed: _replay,
                    color: _iconColor,
                    iconSize: _replayButtonIconSize,
                    icon: const Icon(Icons.replay),
                  ),
                ),
              );
            default:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  Future<void> _play() {
    return controller!.play();
  }

  Future<void> _replay() async {
    await controller!.stop();
    await controller!.play();
  }

  Future<void> _pause() async {
    if (controller!.value.isPlaying) {
      await controller!.pause();
    }
  }

  /// Returns a callback which seeks the video relative to current playing time.
  // Future<void> _seekRelative(Duration seekStep) async {
  //   await controller!.seekTo(controller!.value.position + seekStep);
  // }
}
