import 'dart:io';

import 'package:flutter/material.dart';
import 'package:smooth_video_progress/smooth_video_progress.dart';
import 'package:video_player/video_player.dart';

import '../views/land_scape_view.dart';

class MyVideoPlayer extends StatefulWidget {
  MyVideoPlayer({super.key, required this.controller,this.onHorizontalDragEnd, this.barButtons});
  final VideoPlayerController? controller;
  Function(DragEndDetails)? onHorizontalDragEnd;
  Widget? barButtons;

  @override
  State<MyVideoPlayer> createState() => _MyVideoPlayerState();
}

class _MyVideoPlayerState extends State<MyVideoPlayer> {
  late bool is_play;
  late bool is_mute;

  @override
  void initState() {
    is_play = true;
    is_mute = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.controller != null) {
      return GestureDetector(
        onHorizontalDragEnd: widget.onHorizontalDragEnd ?? widget.onHorizontalDragEnd,
        onTap: () {
          _handleTap();
        },
        onDoubleTap: (){
          Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => LandScapeView(controller: widget.controller),
        ));
        },
        child: Column(
          children: [
            widget.barButtons!=null?widget.barButtons!:Container(), // add bar buttons if needed
            Stack(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width,
                  child: VideoPlayer(
                    widget.controller!,
                  ),
                ),
              ],
            ),
            _videoButtons(),
          ],
        ),
      );
    } else {
      return const CircularProgressIndicator();
    }
  }

  void _handleTap() {
    if (is_play) {
      widget.controller!.pause();
      setState(() {
        is_play = false;
      });
    } else {
      widget.controller!.play();
      setState(() {
        is_play = true;
      });
    }
  }

  Widget _videoButtons() {
    return Row(
      children: [
        _playAndpause(),
        _videoProgress(),
        _muteUnMute(),
        _fullScreenMode(),
      ],
    );
  }
  

  Widget _playAndpause() {
    return IconButton(
      onPressed: () {
        _handleTap();
      },
      icon: !is_play?const Icon(
          Icons.play_arrow,
          size: 30,
        ): const Icon(
          Icons.pause_outlined,
          size: 30,
        ),
    );
  }

  Widget _videoProgress() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.58,
      child: SmoothVideoProgress(
        controller: widget.controller!,
        builder: (context, position, duration, child) => Slider(
          onChanged: (value) =>
              widget.controller!.seekTo(Duration(milliseconds: value.toInt())),
          value: position.inMilliseconds.toDouble(),
          min: 0,
          max: duration.inMilliseconds.toDouble(),
          activeColor: Colors.blue,
        ),
      ),
    );
  }

  Widget _fullScreenMode() {
    return IconButton(
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => LandScapeView(controller: widget.controller),
        ));
      },
      icon: const Icon(
        Icons.fullscreen,
        size: 30,
      ),
    );
  }

  Widget _muteUnMute(){
    return IconButton(
      onPressed: () {
        !is_mute?widget.controller!.setVolume(0):widget.controller!.setVolume(1);
        setState(() {
          is_mute=!is_mute;
        });
      },
      icon: !is_mute?const Icon(
          Icons.volume_up_outlined,
          size: 30,
        ): const Icon(
          Icons.volume_off_outlined,
          size: 30,
        ),
    );
  }
}
