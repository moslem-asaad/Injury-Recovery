import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injury_recovery/components/menu_button.dart';
import 'package:injury_recovery/components/my_button.dart';
import 'package:injury_recovery/components/my_text_field.dart';
import 'package:injury_recovery/features/presentation/widgets/row_line_with_button.dart';

class FeedbackRequest extends StatefulWidget {
  //todo: add treatment id and video id
  const FeedbackRequest({super.key});

  @override
  State<FeedbackRequest> createState() => _FeedbackRequestState();
}

class _FeedbackRequestState extends State<FeedbackRequest> {
  late final TextEditingController _description;
  String? _videoURL;

  @override
  void initState() {
    _description = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('feedback request')),
      body: Column(
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
              _pickVideo();
            },
            button_text: 'clicking here',
          ),
          MyButton(
            onPressed: () {
              //service.createFeedbackRequest(treatment id, video id, _description.text, videoURL)
            },
            title: 'Send your request',
          ),
        ],
      ),
    );
  }

  void _pickVideo() async {
    final picker = ImagePicker();
    XFile? videoFile;
    try {
      videoFile = await picker.pickVideo(source: ImageSource.camera);
      _videoURL = videoFile!.path;
    } catch (e) {
      print(e.toString());
    }
  }
}
