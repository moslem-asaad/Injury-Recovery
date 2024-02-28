import 'package:flutter/material.dart';
import 'package:injury_recovery/components/video_player_preview.dart';
import 'package:video_player/video_player.dart';

class PlayVideoView extends StatefulWidget {
  const PlayVideoView({super.key, required this.videoURL, required this.videoName});
  final String videoURL;
  final String videoName;

  @override
  State<PlayVideoView> createState() => _PlayVideoViewState();
}

class _PlayVideoViewState extends State<PlayVideoView> {
  VideoPlayerController? _controller;
  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  void initState(){
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoURL));
    //_controller.setLooping(true);
    _controller!.initialize().then((_) => setState(() {}));
    //videoPlayerPreview = VideoPlayerPreview(controller: _controller);
    _controller!.play();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Play Video'),
      ),
      body:  SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width,
                  maxHeight: MediaQuery.of(context).size.height,
                ),
                child: Center(
                  child: VideoPlayerPreview(controller: _controller,videoURL: widget.videoURL,),
                ),
              ),
            ),
            Text(widget.videoName)
          ],
        ),
      ),
    );
  }

  
}