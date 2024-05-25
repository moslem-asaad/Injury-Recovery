import 'package:flutter/material.dart';
import 'package:injury_recovery/components/menu_button.dart';
import 'package:injury_recovery/constants/colors.dart';
import 'package:injury_recovery/features/presentation/widgets/logo_image.dart';
import 'package:video_player/video_player.dart';

import '../../../../../components/my_text_field.dart';
import '../../../widgets/my_video_player.dart';

class RoFeedBackRequest extends StatefulWidget {
  const RoFeedBackRequest(
      {super.key, required this.treatmentId, required this.videoId});
  final int treatmentId;
  final int videoId;

  @override
  State<RoFeedBackRequest> createState() => _RoFeedBackRequestState();
}

class _RoFeedBackRequestState extends State<RoFeedBackRequest> {
  late final TextEditingController _description;
  String? _videoURL;
  VideoPlayerController? _controller;
  String? feedbackDesc;

  @override
  void initState() {
    feedbackDesc = 'my description is heeeeere dsadasdsadsadsadsa';
    _description = TextEditingController();
    _description.text = feedbackDesc!;
    //_videoURL = getMyVideo(widget.treatmentId,widget.videoId);
    _videoURL =
        'https://firebasestorage.googleapis.com/v0/b/injury-recovery.appspot.com/o/videos%2F2024-03-14%2014%3A47%3A53.057595.mp4?alt=media&token=2853134c-c7be-4f5a-9e42-2675fc88c73e';
    _controller = VideoPlayerController.networkUrl(Uri.parse(_videoURL!))
      ..initialize().then(
        (_) {
          setState(() {});
          _controller!.setLooping(true);
        },
      );
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
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: const MenuButton(title: 'feeback view').bar(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //getLogo(context, 0.1),
            SizedBox(
              height: height * 0.05,
            ),
            MyTextField(
              controller: _description,
              hintText: 'Description',
              obscureText: false,
              enableSuggestions: false,
              autocorrect: false,
              maxLines: null,
              readOnly: true,
              fillcolor: Colors.green.shade100,
            ),
            SizedBox(
              height: height * 0.05,
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.4,
                decoration: BoxDecoration(
                  border: Border.all(color: my_blue,width: 10),
                  //borderRadius: BorderRadius.circular(10),
                ),
                child: MyVideoPlayer(
                  controller: _controller,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
