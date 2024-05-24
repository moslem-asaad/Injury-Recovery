import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:injury_recovery/features/presentation/views/customer/treatment/video_player_preview.dart';
import 'package:injury_recovery/services/store/store_date.dart';
import 'package:video_player/video_player.dart';

class PlayVideoView extends StatefulWidget {
  const PlayVideoView(
      {super.key,
      required this.videoURL,
      required this.videoName,
      required this.videoID});
  final String videoURL;
  final String videoName;
  final int videoID;

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
  void initState() {
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoURL));
    //_controller.setLooping(true);
    _controller!.initialize().then((_) => setState(() {}));
    //videoPlayerPreview = VideoPlayerPreview(controller: _controller);
    _controller!.play();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Play Video'),
      ),
      //backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  color: Colors.grey[200]),
              height: 40,
              child: Row(
                children: [
                  Container(
                    width: 204,
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.grey[100]!),
                    ),
                    height: 40,
                    child: Text(
                      ' ${widget.videoName} video ',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    alignment: Alignment.centerLeft,
                    width: 130,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[500],
                      border: Border.all(color: Colors.grey[200]!),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextButton.icon(
                      onPressed: () {
                        _playNextVideo();
                      },
                      icon: const Icon(
                        Icons.navigate_next,
                        color: Colors.black,
                        size: 17,
                      ),
                      label: const Text(
                        'Next Video',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width,
                maxHeight: MediaQuery.of(context).size.height,
              ),
              child: Center(
                child: VideoPlayerPreview(
                  controller: _controller,
                  videoURL: widget.videoURL,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _playNextVideo() async {
    int next_id = widget.videoID + 1;
    DocumentSnapshot? videoSnapshot =
        await StoreData().getVideoById(next_id);
    videoSnapshot ??= await StoreData().getVideoById(1);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) {
          return PlayVideoView(
            videoName: videoSnapshot!['name'],
            videoURL: videoSnapshot!['url'],
            videoID: videoSnapshot!['id'],
          );
        },
      ),
    );
  }
}
