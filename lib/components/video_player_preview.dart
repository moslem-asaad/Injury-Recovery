import 'dart:async';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injury_recovery/constants/routes.dart';
import 'package:injury_recovery/features/presentation/views/feedback_request.dart';
import 'package:injury_recovery/features/presentation/views/land_scape_view.dart';
import 'package:injury_recovery/features/presentation/widgets/check_box.dart';
import 'package:video_player/video_player.dart';
import 'package:injury_recovery/constants/colors.dart' as co;

class VideoPlayerPreview extends StatefulWidget {
  const VideoPlayerPreview({
    super.key,
    //required this.controller,
    required this.videoURL,
  });

  //final VideoPlayerController? controller;
  final String? videoURL;

  @override
  State<VideoPlayerPreview> createState() => _VideoPlayerPreviewState();
}

class _VideoPlayerPreviewState extends State<VideoPlayerPreview> {
  String? _videoURL;
  VideoPlayerController? _controller;
  bool _showVideoButtons = false;
  Timer? _timer;

  @override
  void initState() {
    //_controller = widget.controller;
    _videoURL = widget.videoURL;
    //_controller!.initialize().then((_) => setState(() {}));
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(_videoURL!));
    _controller!.setLooping(true);
    _controller!.initialize().then((_) => setState(() {}));
    //_controller!.play();
  }

  @override
  void dispose() {
    _controller?.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('url1234 $_videoURL');
    return Scaffold(
      backgroundColor: co.backgraound,
      body: ConstrainedBox(
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
    );
  }

  Widget _videoPlayerPreview() {
    if (_controller != null) {
      return Column(
        children: [
          ButtonBar(
            children: [
              OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => FeedbackRequest(),
                    ));
                  },
                  child: Text('feedback')),
            ],
          ),
          GestureDetector(
            onTap: () {
              _handleTap();
            },
            onDoubleTap: () {
              _onDoubleTap();
            },
            child: Stack(
              children: [
                SizedBox(
                  width: _controller!.value.size.width / 2,
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: VideoPlayer(_controller!),
                ),
              ],
            ),
          ),
          Row(
            children: [
              _pauseVideo(25),
              _showProgressTime(),
              _videoProgress(),
              _showEndTime(),
              _fullScreenMode(),
            ],
          ),
        ],
      );
    } else {
      return const CircularProgressIndicator();
    }
  }

  void _onDoubleTap() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => LandScapeView(controller: _controller),
    ));
  }

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

  Widget _pauseVideo(double button_size) {
    return IconButton(
      icon: Icon(
        _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
        size: button_size,
        color: Colors.black,
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
            color: Colors.black,
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
            color: Colors.black,
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
        color: Colors.black,
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

  Widget _fullScreenMode() {
    return IconButton(
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => LandScapeView(controller: _controller),
        ));
      },
      icon: const Icon(
        Icons.fullscreen,
        color: Colors.black,
      ),
    );
  }
}
