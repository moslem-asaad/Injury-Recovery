import 'package:flutter/material.dart';
import 'package:injury_recovery/features/domain/entities/feedback_request.dart';
import 'package:injury_recovery/features/presentation/views/customer/treatment/ro_feedback_request.dart';
import 'package:injury_recovery/features/presentation/widgets/treatments_images.dart';

import '../../../../../constants/colors.dart';
import '../../../../../utilities/show_error_dialog.dart';
import '../../../services/service_layer.dart';

class AllFeedbacks extends StatefulWidget {
  final int? treatmentId;
  const AllFeedbacks({super.key, required this.treatmentId});

  @override
  State<AllFeedbacks> createState() => _AllFeedbacksState();
}

class _AllFeedbacksState extends State<AllFeedbacks> {
  late Future<List<FeedbackRequest>> futureFeedbacks;

  @override
  void initState() {
    super.initState();
    futureFeedbacks = _getfeedbacks();
  }

  Future<List<FeedbackRequest>> _getfeedbacks() async {
    var feedbackResponse =
        await Service().getTreatmentFeedbackRequests(widget.treatmentId!);
    if (feedbackResponse.errorOccured!) {
      await showErrorDialog(context, feedbackResponse.errorMessage!);
      return [];
    } else {
      return feedbackResponse.val!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureFeedbacks,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          showErrorDialog(context, '${snapshot.error}');
          return Text('Error: ${snapshot.error}');
        } else {
          var feedbacks = snapshot.data!;
          return Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  for (var feedback in feedbacks) feedbackWidget(feedback),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget feedbackWidget(FeedbackRequest feedback) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.all(25),
      child: Column(
        children: [
          Container(
            height: height * 0.2,
            width: width * 0.9,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
                color: backgraound),
            child: Row(
              children: [
                Container(
                  width: width * 0.5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Feedback on video ${feedback.exerciseVideoGlobalId}',
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        Text(
                          'Feedback Status : ${_getFeedbackStatus(feedback.systemManagerResponse)}',
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                              color: Color.fromARGB(244, 107, 107, 107)),
                        ),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => RoFeedBackRequest(
                                feedbackRequest: feedback,
                              ),
                            ));
                          },
                          icon: const Icon(
                            Icons.arrow_back_sharp,
                            color: Colors.black,
                          ),
                          label: const Text(
                            'review the request',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    height: width * 0.5,
                    width: width * 0.3,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white,width: 5),
                      borderRadius: BorderRadius.circular(10),
                      //color: container_color1,
                    ),
                    child: getthumpnail(context, 0.25, 1),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getFeedbackStatus(String? systemManagerResponse) {
    if (systemManagerResponse != null) {
      return 'answered';
    } else {
      return 'not answerd yet';
    }
  }
}
