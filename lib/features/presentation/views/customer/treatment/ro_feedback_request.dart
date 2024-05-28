import 'package:flutter/material.dart';
import 'package:injury_recovery/components/menu_button.dart';
import 'package:injury_recovery/constants/colors.dart';
import 'package:injury_recovery/features/domain/entities/feedback_request.dart';
import 'package:injury_recovery/features/presentation/widgets/logo_image.dart';
import 'package:injury_recovery/features/presentation/widgets/my_box_shadow.dart';
import 'package:video_player/video_player.dart';

import '../../../../../components/my_text_field.dart';
import '../../../widgets/my_video_player.dart';

class RoFeedBackRequest extends StatefulWidget {
  const RoFeedBackRequest({
    super.key,
    required this.feedbackRequest,
  });
  final FeedbackRequest feedbackRequest;

  @override
  State<RoFeedBackRequest> createState() => _RoFeedBackRequestState();
}

class _RoFeedBackRequestState extends State<RoFeedBackRequest> {
  late final TextEditingController _description;
  late final TextEditingController _response;
  String? _performanceVideoURL;
  VideoPlayerController? _controller;
  String? feedbackDesc;

  @override
  void initState() {
    feedbackDesc = widget.feedbackRequest.feedbackRequestDescription;
    _description = TextEditingController();
    _response = TextEditingController();
    if (widget.feedbackRequest.systemManagerResponse != null) {
      _response.text = widget.feedbackRequest.systemManagerResponse!;
    }
    _response.text = "goooooooooooooof jopp!";
    _description.text = feedbackDesc!;
    _performanceVideoURL = widget.feedbackRequest.performanceVideoDownloadURL!;
    _controller =
        VideoPlayerController.networkUrl(Uri.parse(_performanceVideoURL!))
          ..initialize().then(
            (_) {
              setState(() {});
              _controller!.setLooping(true);
              _controller!.play();
            },
          );
    super.initState();
  }

  @override
  void dispose() {
    _description.dispose();
    _controller?.dispose();
    _response.dispose();
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
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                children: [
                  Text(
                    'תיאור הבעיה',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            MyTextField(
              controller: _description,
              hintText: 'הבעיה שלי',
              obscureText: false,
              enableSuggestions: false,
              autocorrect: false,
              maxLines: null,
              readOnly: true,
              fillcolor: Colors.green.shade100,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: MyVideoPlayer(
                controller: _controller,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                children: [
                  Text(
                    'התייחסות הפיזיותרפיסט',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Container(
              constraints: BoxConstraints(
                minHeight: height* 0.3, // Minimum height
              ),
              decoration: BoxDecoration(
                boxShadow: myBoxShadow(color: my_green),
              ),
              child: MyTextField(
                controller: _response,
                hintText: 'אין תשובה',
                obscureText: false,
                enableSuggestions: false,
                autocorrect: false,
                maxLines: null,
                readOnly: true,
                fillcolor: my_green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
