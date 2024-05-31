import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injury_recovery/components/my_button.dart';
import 'package:injury_recovery/features/presentation/widgets/my_video_player.dart';
import 'package:injury_recovery/services/store/store_date.dart';
import 'package:injury_recovery/utilities/show_error_dialog.dart';
import 'package:video_player/video_player.dart';

import '../../services/service_layer.dart';

class UploadVideoView extends StatefulWidget {
  const UploadVideoView({super.key});

  @override
  State<UploadVideoView> createState() => _UploadVideoViewState();
}

class _UploadVideoViewState extends State<UploadVideoView> {
  String? _videoURL;
  VideoPlayerController? _controller;
  String? _downloadURL;
  bool _showVideoButtons = false;
  Timer? _timer;
  String? _videoName;
  String? _description;
  String? _summary;
  double _uploadProgress = 0;

  @override
  void dispose() {
    _controller?.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Upload Video'),
      ),
      body: SingleChildScrollView(
        child: Container(
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
      ),
      floatingActionButton: Column(
        children: [
          const SizedBox(
            height: 700,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(8.0), // Adjust the radius as needed
              color: const Color.fromARGB(255, 237, 237, 237), // or any other color you want
            ),
            child: TextButton.icon(
              onPressed: _pickVideo,
              icon: const Icon(Icons.video_library), // Icon color
              label: const Text(
                'Pick Video',
              ), // Text color
            ),
          )
        ],
      ),
    );
  }

  void _pickVideo() async {
    final picker = ImagePicker();
    XFile? videoFile;
    try {
      videoFile = await picker.pickVideo(source: ImageSource.gallery);
      _videoURL = videoFile!.path;
    } catch (e) {
      print(e.toString());
    }
    _initializeVideoPlayer();
  }

  void _initializeVideoPlayer() {
    _controller = VideoPlayerController.file(File(_videoURL!))
      ..initialize().then((_) {
        setState(() {});
        _controller!.play();
      });
  }

  Widget _videoPlayerPreview() {
    if (_controller != null) {
      double videoWidth = _controller!.value.size.width;
      double videoHeight = _controller!.value.size.height;
      double _aspectRatio = videoWidth / videoHeight;
      if (_aspectRatio < 1) {
        _aspectRatio = _aspectRatio * 2;
      }
      return Column(
        children: [
          MyVideoPlayer(controller: _controller),
          /*GestureDetector(
            onTap: () {
              _handleTap();
            },
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio: _aspectRatio,
                  child: VideoPlayer(_controller!),
                ),
                _pauseVideo(),
                _restartVideo(),
                if (_showVideoButtons) _videoProgress(),
              ],
            ),
          ),*/
          MyButton(
            onPressed: _uploadVideo,
            title: ('Upload'),
          ),
          SizedBox(height: 20),
          LinearProgressIndicator(
            value: _uploadProgress / 100,
            minHeight: 10,
            backgroundColor: Colors.grey,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
          SizedBox(height: 10),
          Text('${_uploadProgress.toStringAsFixed(2)}% Uploaded'),
        ],
      );
    } else {
      return const CircularProgressIndicator();
    }
  }

  // Function to handle tap event on the video player
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

  // Start the timer
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
    return Visibility(
      visible: _showVideoButtons,
      child: Positioned(
        top: 0,
        left: 0,
        right: 0,
        bottom: 0,
        child: IconButton(
          icon: Icon(
            _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
            size: 48,
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
        ),
      ),
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
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        color: Colors.black.withOpacity(0.5),
        padding: EdgeInsets.symmetric(vertical: 8),
        child: VideoProgressIndicator(
          _controller!,
          allowScrubbing: true, // Allow scrubbing
          colors: const VideoProgressColors(
            playedColor: Colors.red,
            bufferedColor: Colors.white,
            backgroundColor: Colors.grey,
          ),
        ),
      ),
    );
  }

  void _uploadVideo() async {
     List<String?>? res = (await _askForVideoName());
    _videoName = res![0];
    _description = res[1];
    _summary = res[2];
    if (_videoName != null && _videoURL != null) {
      setState(() {
        _uploadProgress = 0; // Reset progress before starting upload
      });

    var response = await Service().uploadVideo(_videoURL!,'videos' ,(progress) {
        setState(() {
          _uploadProgress = progress * 100; // Convert to percentage
        });
      });
    _downloadURL = response.val!;
      /*_downloadURL = await StoreData().uploadVideo(_videoURL!, (progress) {
        setState(() {
          _uploadProgress = progress * 100; // Convert to percentage
        });
      });*/
      //_downloadURL = await StoreData().uploadVideo(_videoURL!);
      var response2 = await Service().createExerciseVideo(_downloadURL!,_description!,_summary!);
      if(response2.errorOccured!){
        await showErrorDialog(context, response2.errorMessage!);
      }
      //await StoreData().saveVideoData(_downloadURL!, _videoName!);
      setState(() {
        //_controller!.pause();
        //_videoURL = null;
      });
    }
  }

  Future<List<String?>?> _askForVideoName() async {
    return showDialog<List<String?>>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Video Name'),
          content: Column(
            children: [
              TextField(
                onChanged: (value) {
                  _videoName = value;
                },
                decoration: InputDecoration(hintText: 'Video Name'),
              ),
              TextField(
                onChanged: (value) {
                  _description = value;
                },
                decoration: InputDecoration(hintText: 'Video Description'),
              ),
              TextField(
                onChanged: (value) {
                  _summary = value;
                },
                decoration: InputDecoration(hintText: 'Video Summary'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop([_videoName,_description,_summary]);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  showUploadProgress(UploadTask task) => StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data!;
            final progress = snap.bytesTransferred / snap.totalBytes;
            final percentage = (progress * 100).toStringAsFixed(2);
            return Text(
              '$percentage %',
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            );
          } else {
            return Container();
          }
        },
      );
}
