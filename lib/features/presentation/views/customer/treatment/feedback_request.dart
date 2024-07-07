import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injury_recovery/components/menu_button.dart';
import 'package:injury_recovery/components/my_button.dart';
import 'package:injury_recovery/components/my_text_field.dart';
import 'package:injury_recovery/features/presentation/services/service_layer.dart';
import 'package:injury_recovery/features/presentation/views/customer/treatment/video_player_preview.dart';
import 'package:injury_recovery/features/presentation/widgets/Loading_page.dart';
import 'package:injury_recovery/features/presentation/widgets/row_line_with_button.dart';
import 'package:injury_recovery/features/presentation/widgets/my_video_player.dart';
import 'package:injury_recovery/utilities/show_error_dialog.dart';
import 'package:video_player/video_player.dart';

import '../../../widgets/logo_image.dart';

class FeedbackRequest extends StatefulWidget {
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
  String? _downloadURL;
  double _uploadProgress = 0;
  late bool _uploadProgressVisibile;

  @override
  void initState() {
    _description = TextEditingController();
    _uploadProgressVisibile = false;
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
      appBar: AppBar(
        title: Text('בקשת משוב'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: getLogo(context, 0.1),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
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
                text1: 'ספק את הביצועים שלך על ידי',
                onPresses: () {
                  _showOptions(context);
                },
                button_text: 'לחיצה כאן',
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.4,
                child: MyVideoPlayer(
                  controller: _controller,
                ),
              ),
              MyButton(
                onPressed: () async {
                  await sendFeedbackRequest();
                },
                title: 'שליחת הבקשה',
              ),
              SizedBox(height: 20),
              Visibility(
                visible: _uploadProgressVisibile,
                child: LinearProgressIndicator(
                  value: _uploadProgress / 100,
                  minHeight: 10,
                  backgroundColor: Colors.grey,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              ),
              SizedBox(height: 10),
              Visibility(
                visible: _uploadProgressVisibile,
                child: Text('${_uploadProgress.toStringAsFixed(2)}% Uploaded'),
              ),
            ],
          ),
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
                title: Text('פתח את הגלריה'),
                onTap: () {
                  _pickVideo(0);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('פתח את המצלמה'),
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
      return Loading(context);
    }
  }

  Future<void> sendFeedbackRequest() async {
    if (_videoURL != null) {
      setState(() {
        _uploadProgressVisibile = !_uploadProgressVisibile;
        _uploadProgress = 0; // Reset progress before starting upload
      });

      var response1 = await Service().uploadVideo(_videoURL!, 'customersVideos',
          (progress) {
        setState(() {
          _uploadProgress = progress * 100; // Convert to percentage
        });
      });

      if (response1.errorOccured!) {
        await showErrorDialog(context, response1.errorMessage!);
      }
      _downloadURL = response1.val!;
      var response2 = await Service().sendFeedbackRequest(
        widget.treatmentId,
        widget.videoId,
        _downloadURL,
        _description.text,
      );

      if (response2.errorOccured!) {
        await showErrorDialog(context, response2.errorMessage!);
      } else {
        Navigator.pop(context);
        showMyDialog(context, 'בקשת משוב נשלחה בהצלחה !');
      }
    }else{
       var response2 = await Service().sendFeedbackRequest(
        widget.treatmentId,
        widget.videoId,
        _downloadURL,
        _description.text,
      );
      if (response2.errorOccured!) {
        await showErrorDialog(context, response2.errorMessage!);
      } else {
        Navigator.pop(context);
        showMyDialog(context, 'בקשת משוב נשלחה בהצלחה !');
      }
    }
  }
}
