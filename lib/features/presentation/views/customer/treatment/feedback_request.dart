import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injury_recovery/components/menu_button.dart';
import 'package:injury_recovery/components/my_button.dart';
import 'package:injury_recovery/components/my_text_field.dart';
import 'package:injury_recovery/features/presentation/services/service_layer.dart';
import 'package:injury_recovery/features/presentation/views/customer/treatment/video_player_preview.dart';
import 'package:injury_recovery/features/presentation/widgets/row_line_with_button.dart';
import 'package:injury_recovery/features/presentation/widgets/my_video_player.dart';
import 'package:injury_recovery/utilities/show_error_dialog.dart';
import 'package:video_player/video_player.dart';

class FeedbackRequest extends StatefulWidget {
  //todo: add treatment id and video id

  const FeedbackRequest(
      {super.key, required this.treatmentId, required this.videoId});

  final int treatmentId;
  final int videoId;

  @override
  State<FeedbackRequest> createState() => _FeedbackRequestState();
}

class _FeedbackRequestState extends State<FeedbackRequest> {
  late final TextEditingController _description;
  String? _videoURL;
  VideoPlayerController? _controller;

  @override
  void initState() {
    _description = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _description.dispose();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('feedback request')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            MyTextField(
              controller: _description,
              hintText: 'Description',
              obscureText: false,
              enableSuggestions: false,
              autocorrect: false,
              maxLines: null,
              //keyboardType: TextInputType.emailAddress,
            ),
            RowTextTextButtun(
              text1: 'provide your performe by',
              onPresses: () {
                _showOptions(context);
              },
              button_text: 'clicking here',
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              child: MyVideoPlayer(
                controller: _controller,
              ),
              /*child: _videoURL != null
                  ? _videoPlayerPreview()
                  : Text('no video selected'),*/
            ),
            MyButton(
              onPressed: () async {
                //print('asdasd ${widget.videoId} ${_description.text} ${_videoURL}');
                await sendFeedbackRequest();
              },
              title: 'Send your request',
            ),
          ],
        ),
      ),
    );
  }

  void _pickVideo(int option) async {
    final picker = ImagePicker();
    XFile? videoFile;
    try {
      if (option == 0) {
        videoFile = await picker.pickVideo(source: ImageSource.gallery);
      } else {
        videoFile = await picker.pickVideo(source: ImageSource.camera);
      }
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
        _controller!.setLooping(true);
      });
  }

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.image),
                title: Text('Open Gallary'),
                onTap: () {
                  _pickVideo(0);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Open Camera'),
                onTap: () {
                  _pickVideo(1);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _videoPlayerPreview() {
    if (_controller != null) {
      return GestureDetector(
        onTap: () {
          _controller!.pause();
        },
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: VideoPlayer(
                    _controller!,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      return const CircularProgressIndicator();
    }
  }

  Future<void> sendFeedbackRequest() async {
    var response = await Service().sendFeedbackRequest(
      widget.treatmentId,
      widget.videoId,
      _videoURL,
      _description.text,
    );

    if(response.errorOccured!){
      await showErrorDialog(context, response.errorMessage!);
    }
    else{
      Navigator.pop(context);
    }
  }
}
