import 'dart:async';

import 'package:flutter/material.dart';
import 'package:injury_recovery/views/land_scape_view.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerPreview extends StatefulWidget {
  const VideoPlayerPreview({
    super.key,
    required this.controller,
    required this.videoURL,
  });

  final VideoPlayerController? controller;
  final String? videoURL;

  @override
  State<VideoPlayerPreview> createState() => _VideoPlayerPreviewState();
}

class _VideoPlayerPreviewState extends State<VideoPlayerPreview> {
  String? _videoURL;
  VideoPlayerController? _controller;
  String? _downloadURL;
  bool _showVideoButtons = false;
  Timer? _timer;

  @override
  void initState() {
    _controller = widget.controller;
    _videoURL = widget.videoURL;
    //_controller!.initialize().then((_) => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height,
          ),
          child: Center(
            child: _videoURL != null
                ? _videoPlayerPreview()
                : const Text('No Video is Selected'),
          ),
        ),
      ),
    );
  }

  Widget _videoPlayerPreview() {
    if (_controller != null) {
      return Column(
        children: [
          SizedBox(
            height: 300,
            child: VideoPlayer(_controller!),
          ),
          Stack(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _pauseVideo(),
                  _showProgressTime(),
                  _videoProgress(),
                  _showEndTime(),
                  const SizedBox(
                    width: 10,
                  ),
                  _fullScreenMode(),
                ],
              ),
            ],
          )
        ],
      );
    } else {
      return const CircularProgressIndicator();
    }
  }

  /*Widget _videoPlayerPreview() {
    if (_controller != null) {
      /*double videoWidth = _controller!.value.size.width ?? 0;
      double videoHeight = _controller!.value.size.height ?? 0;
      double _aspectRatio = videoWidth / videoHeight;
      if (_aspectRatio < 0) {
        _aspectRatio = 0;
      }
      else if (_aspectRatio < 1) {
        _aspectRatio = _aspectRatio * 2;
      }*/
      return Column(
        children: [
          GestureDetector(
            onTap: () {
              _handleTap();
            },
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio: _controller!.value.aspectRatio,
                  child: VideoPlayer(_controller!),
                ),
                _pauseVideo(),
                _restartVideo(),
                if (_showVideoButtons) _videoProgress(),
              ],
            ),
          ),
        ],
      );
    } else {
      return const CircularProgressIndicator();
    }
  }*/

  void _handleTap() {
    setState(() {
      _showVideoButtons = !_showVideoButtons;
    });
    if (_showVideoButtons) {
      _startTimer(); // Start the timer if controls are shown
    } else {
      _timer?.cancel(); // Cancel the timer if controls are hidden
    }
  }

  void _startTimer() {
    _timer?.cancel(); // Cancel the timer if it's already running
    _timer = Timer(Duration(seconds: 4), () {
      setState(() {
        _showVideoButtons =
            false; // Hide the button after 4 seconds of inactivity
      });
    });
  }

  Widget _pauseVideo() {
    return IconButton(
      icon: Icon(
        _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
        size: 25,
        color: Colors.white,
      ),
      onPressed: () {
        setState(() {
          if (_controller!.value.isPlaying) {
            _controller!.pause();
          } else {
            _controller!.play();
          }
        });
      },
    );
  }

  Widget _restartVideo() {
    return Visibility(
      visible: _showVideoButtons,
      child: Positioned(
        top: 16,
        left: 16,
        child: IconButton(
          icon: const Icon(
            Icons.replay,
            size: 24,
            color: Colors.white,
          ),
          onPressed: () {
            setState(() {
              _controller!.seekTo(Duration.zero);
              _controller!.play();
            });
          },
        ),
      ),
    );
  }

  // Function to build the custom video controls widget
  Widget _videoProgress() {
    return Expanded(
      child: SizedBox(
        height: 10,
        child: Container(
          color: Colors.transparent,
          child: VideoProgressIndicator(
            _controller!,
            allowScrubbing: true, // Allow scrubbing
            colors: const VideoProgressColors(
              playedColor: Colors.red,
              bufferedColor: Colors.white,
              backgroundColor: Colors.grey,
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 0,
              horizontal: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _showProgressTime() {
    return ValueListenableBuilder(
      valueListenable: _controller!,
      builder: (context, value, child) {
        return Text(
          _videoDuration(value.position),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        );
      },
    );
  }

  Widget _showEndTime() {
    return Text(
      _videoDuration(_controller!.value.duration),
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14,
      ),
    );
  }

  String _videoDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [
      if (duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(':');
  }

  Widget _fullScreenMode(){
    return Positioned(
      child: IconButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder:(context) => LandScapeView(controller: _controller),)
          );
        },
        icon: const Icon(
          Icons.fullscreen,
          color: Colors.white,
        ),
      )
    );
  }
}
