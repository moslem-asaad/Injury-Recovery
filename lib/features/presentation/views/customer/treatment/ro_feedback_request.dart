import 'dart:io';

import 'package:flutter/material.dart';
import 'package:injury_recovery/components/menu_button.dart';
import 'package:injury_recovery/components/my_button.dart';
import 'package:injury_recovery/constants/colors.dart';
import 'package:injury_recovery/features/domain/entities/exercise_video.dart';
import 'package:injury_recovery/features/domain/entities/feedback_request.dart';
import 'package:injury_recovery/features/presentation/services/service_layer.dart';
import 'package:injury_recovery/features/presentation/views/customer/all_feedbacks.dart';
import 'package:injury_recovery/features/presentation/widgets/Loading_page.dart';
import 'package:injury_recovery/features/presentation/widgets/logo_image.dart';
import 'package:injury_recovery/features/presentation/widgets/my_box_shadow.dart';
import 'package:injury_recovery/features/presentation/widgets/treatments_images.dart';
import 'package:injury_recovery/utilities/show_error_dialog.dart';
import 'package:video_player/video_player.dart';

import '../../../../../components/my_text_field.dart';
import '../../../../../constants/routes.dart';
import '../../../../domain/entities/user.dart';
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
  late bool _isOriginalVideoVisible;
  late bool _isPerformanceVideoVisible;
  String? _performanceVideoURL;
  late Future<ExerciseVideo> _exerciseVideo;
  VideoPlayerController? _controller;
  VideoPlayerController? _exerciseVideoController;
  String? feedbackDesc;
  late Future<bool> isSystemManager;

  Future<bool> _isSystemManager() async {
    return (await Service().getLoggedInUser()).val!.isSystemManager;
  }

  @override
  void initState() {
    _isOriginalVideoVisible = false;
    _isPerformanceVideoVisible = true;
    isSystemManager = _isSystemManager();
    feedbackDesc = widget.feedbackRequest.feedbackRequestDescription;
    _description = TextEditingController();
    _response = TextEditingController();
    if (widget.feedbackRequest.systemManagerResponse != null) {
      _response.text = widget.feedbackRequest.systemManagerResponse!;
    }
    _description.text = feedbackDesc!;
    if (widget.feedbackRequest.performanceVideoDownloadURL != null) {
      _performanceVideoURL =
          widget.feedbackRequest.performanceVideoDownloadURL!;
      _controller =
          VideoPlayerController.networkUrl(Uri.parse(_performanceVideoURL!))
            ..initialize().then(
              (_) {
                setState(() {});
                _controller!.setLooping(true);
                _controller!.play();
              },
            );
    }
    _exerciseVideo = _getExerciseVideo();
    super.initState();
  }

  @override
  void dispose() {
    _description.dispose();
    _controller?.dispose();
    _response.dispose();
    super.dispose();
  }

  Future<ExerciseVideo> _getExerciseVideo() async {
    var response = await Service()
        .getExerciseVideoById(widget.feedbackRequest.exerciseVideoGlobalId!);
    if (response.errorOccured!) {
      await showErrorDialog(context, response.errorMessage!);
      return response.val!;
    } else {
      print('videooo ${response.val!.videoUrl}');
      ExerciseVideo exerciseVideo = response.val!;
      _exerciseVideoController = _exerciseVideoController =
          VideoPlayerController.networkUrl(Uri.parse(exerciseVideo.videoUrl!))
            ..initialize().then(
              (_) {
                setState(() {});
                _controller!.setLooping(true);
                //_controller!.play();
              },
            );
      return exerciseVideo;
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return FutureBuilder(
      future: isSystemManager,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Loading(context);
        } else if (snapshot.hasError) {
          showErrorDialog(context, '${snapshot.error}');
          return Text('Error: ${snapshot.error}');
        } else {
          bool _ismanager = snapshot.data!;
          return FutureBuilder(
            future: _exerciseVideo,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Loading(context);
              } else if (snapshot.hasError) {
                showErrorDialog(context, '${snapshot.error}');
                return Text('Error: ${snapshot.error}');
              } else {
                return FutureBuilder<User>(
                  future:
                      getUserByEmail(widget.feedbackRequest.customerUserEmail!),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      sleep(
                        Duration(milliseconds: 1000),
                      );
                      //print('object');
                    }
                    /*while(snapshot.data==null){
                      print('ooooo');
                      if(snapshot.data!=null) break;
                    }*/
                    String firstName = snapshot.data!.firstName ?? '';
                    String lastName = snapshot.data!.lastName ?? '';
                    return Scaffold(
                      appBar:
                          const MenuButton(title: 'משוב').bar(context),
                      body: SingleChildScrollView(
                        child: Column(
                          children: [
                            Visibility(
                              child: Text('בקשת המשתמש : $firstName $lastName'),
                              visible: _ismanager,
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 25.0),
                              child: Row(
                                children: [
                                  Text(
                                    'תיאור הבעיה',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
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
                            ButtonBar(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _isPerformanceVideoVisible =
                                          !_isPerformanceVideoVisible;
                                    });
                                  },
                                  icon: Icon(Icons.minimize),
                                ),
                              ],
                            ),
                            Visibility(
                              visible: _isPerformanceVideoVisible,
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: MyVideoPlayer(
                                  controller: _controller,
                                ),
                              ),
                            ),
                            ButtonBar(
                              children: [
                                TextButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      _isOriginalVideoVisible =
                                          !_isOriginalVideoVisible;
                                    });
                                  },
                                  icon: arrow_direction(),
                                  label: label_content(),
                                ),
                              ],
                            ),
                            Visibility(
                              visible: _isOriginalVideoVisible,
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: MyVideoPlayer(
                                  controller: _exerciseVideoController,
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 25.0),
                              child: Row(
                                children: [
                                  Text(
                                    'התייחסות הפיזיותרפיסט',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            MyTextField(
                              controller: _response,
                              hintText: 'אין תשובה',
                              obscureText: false,
                              enableSuggestions: false,
                              autocorrect: false,
                              maxLines: null,
                              readOnly:
                                  !(_ismanager && (_response.text.isEmpty)),
                              fillcolor: my_green,
                            ),
                            if (_ismanager && (_response.text.isEmpty))
                              MyButton(
                                onPressed: () async {
                                  var response =
                                      await Service().sendFeedbackResponse(
                                    widget.feedbackRequest.feedbackRequestId!,
                                    _response.text,
                                  );
                                  if (response.errorOccured!) {
                                    await showErrorDialog(
                                        context, response.errorMessage!);
                                  } else {
                                    await showMyDialog(
                                        context, 'response sent succefully');
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    Navigator.pushNamed(
                                        context, usersFeedbacksRout);
                                  }
                                },
                                title: 'send response',
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            },
          );
        }
      },
    );
  }

  Icon arrow_direction() {
    if (_isOriginalVideoVisible) {
      return Icon(
        Icons.arrow_downward_rounded,
        color: my_blue,
      );
    } else {
      return Icon(
        Icons.arrow_upward_rounded,
        color: my_blue,
      );
    }
  }

  Text label_content() {
    if (_isOriginalVideoVisible) {
      return Text(
        'הסתרת התרגיל המקורי',
        style: TextStyle(color: my_blue),
      );
    } else {
      return Text(
        'הצגת התרגיל המקורי',
        style: TextStyle(color: my_blue),
      );
    }
  }

  Future<User> getUserByEmail(String userEmail) async {
    var response = await Service().getCustomerUserByEmail(userEmail);
    if (response.errorOccured!) {
      await showErrorDialog(context, response.errorMessage!);
      return response.val!;
    } else {
      return response.val!;
    }
  }

  /*bool _canRespose() {
    bool res = false;
    if (isSystemManager) {
      if (_response.text.isEmpty) {
        res = true;
      }
    }
    print('canResponse1 $isSystemManager');
    print('canResponse2 ${_response.text.isEmpty}');

    print('canResponse3 $res');
    return res;
  }*/
}
