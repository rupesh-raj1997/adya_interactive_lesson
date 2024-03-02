import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class BaseVideoPlayer extends StatefulWidget {
  const BaseVideoPlayer({super.key});

  @override
  State<BaseVideoPlayer> createState() => _BaseVideoPlayerState();
}

class _BaseVideoPlayerState extends State<BaseVideoPlayer> {
  late VideoPlayerController _controller;
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/vid_01.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _controller.value.isInitialized
            ? Column(
                children: [
                  AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
                  VideoProgressIndicator(_controller, allowScrubbing: true),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        
                        _controller.value.isPlaying
                            ? _controller.pause()
                            : _controller.play();
                      });
                    },
                    child: Icon(
                      _controller.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                    ),
                  )
                ],
              )
            : Container(),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
