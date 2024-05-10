import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:video_player/video_player.dart';

class LandScapeView extends StatefulWidget {
  const LandScapeView({super.key, required this.controller});
  final VideoPlayerController? controller;

  @override
  State<LandScapeView> createState() => _LandScapeViewState();
}

class _LandScapeViewState extends State<LandScapeView> {
  bool _showVideoButtons = false;

  Future _landscapeMode() async {
    double hight = widget.controller!.value.size.height;
    double width = widget.controller!.value.size.width;
    if (hight <= width) {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }
  }

  Future _setAllOrientation() async {
    await SystemChrome.setPreferredOrientations(DeviceOrientation.values);
  }

  @override
  void initState() {
    super.initState();
    _landscapeMode();
  }

  @override
  void dispose() {
    _setAllOrientation();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double aspectRatio = widget.controller!.value.aspectRatio;
    double videoWidth = screenWidth;
    double videoHeight = screenWidth / aspectRatio;

    if (videoHeight > screenHeight) {
      videoHeight = screenHeight;
      videoWidth = screenHeight * aspectRatio;
    }

    double hight = widget.controller!.value.size.height;
    double width = widget.controller!.value.size.width;
    return Scaffold(
      backgroundColor: Colors.black,
        body: GestureDetector(
      onTap: () {
        _handleTap();
      },
      onDoubleTap: (){
        _onDoubleTap();
      },
      child: Column(
        children: [
          SizedBox(height: (screenHeight - videoHeight)/2,),
          Center(
            child: Container(
              color: Colors.black,
              height: screenHeight - (screenHeight - videoHeight)/2,
              child: Stack(
                children: [
                  SizedBox(
                    width: videoWidth,
                    height: videoHeight,
                    child: AspectRatio(
                      aspectRatio: aspectRatio,
                      child: VideoPlayer(widget.controller!),
                    ),
                  ),
                  Center(
                    child: _pauseVideo(60),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Row(
                      children: [
                        _pauseVideo(25),
                        _showProgressTime(),
                        _videoProgress(),
                        _showEndTime(),
                        _fullScreenMode(),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }

  void _onDoubleTap() {
    Navigator.pop(context);
  }

  Widget _pauseVideo(double button_size) {
    return Visibility(
      visible: _showVideoButtons,
      child: IconButton(
        icon: Icon(
          widget.controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
          size: button_size,
          color: Colors.white,
        ),
        onPressed: () {
          setState(() {
            if (widget.controller!.value.isPlaying) {
              widget.controller!.pause();
            } else {
              widget.controller!.play();
            }
          });
        },
      ),
    );
  }

  void _handleTap() {
    setState(() {
      _showVideoButtons = !_showVideoButtons;
    });
  }

  Widget _videoProgress() {
    return Visibility(
      visible: _showVideoButtons,
      child: Expanded(
        child: SizedBox(
          height: 10,
          child: Container(
            color: Colors.transparent,
            child: VideoProgressIndicator(
              widget.controller!,
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
      ),
    );
  }

  Widget _showProgressTime() {
    return Visibility(
      visible: _showVideoButtons,
      child: ValueListenableBuilder(
        valueListenable: widget.controller!,
        builder: (context, value, child) {
          return Text(
            _videoDuration(value.position),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          );
        },
      ),
    );
  }

  Widget _showEndTime() {
    return Visibility(
      visible: _showVideoButtons,
      child: Text(
        _videoDuration(widget.controller!.value.duration),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
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
    return Visibility(
      visible: _showVideoButtons,
      child: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(
          Icons.fullscreen,
          color: Colors.white,
        ),
      ),
    );
  }
}
