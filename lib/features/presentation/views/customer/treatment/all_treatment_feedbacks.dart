import 'package:flutter/material.dart';
import 'package:injury_recovery/features/domain/entities/feedback_request.dart';
import 'package:injury_recovery/features/presentation/views/customer/treatment/ro_feedback_request.dart';
import 'package:injury_recovery/features/presentation/widgets/Loading_page.dart';
import 'package:injury_recovery/features/presentation/widgets/my_box_shadow.dart';
import 'package:injury_recovery/features/presentation/widgets/treatments_images.dart';

import '../../../../../constants/colors.dart';
import '../../../../../utilities/show_error_dialog.dart';
import '../../../services/service_layer.dart';

class AllTreatmentFeedbacks extends StatefulWidget {
  final int? treatmentId;
  const AllTreatmentFeedbacks({super.key, required this.treatmentId});

  @override
  State<AllTreatmentFeedbacks> createState() => _AllTreatmentFeedbacksState();
}

class _AllTreatmentFeedbacksState extends State<AllTreatmentFeedbacks> {
  late Future<List<FeedbackRequest>> futureFeedbacks;
  int image_index = 0;
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
          return Loading(context);
        } else if (snapshot.hasError) {
          showErrorDialog(context, '${snapshot.error}');
          return Text('Error: ${snapshot.error}');
        } else {
          var feedbacks = snapshot.data!;
          feedbacks.sort((a, b) => a.timeCreated.compareTo(b.timeCreated));
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

  void increment_image_indx() {
    image_index = ((image_index + 1) % 5) + 1;
  }

  Widget feedbackWidget(FeedbackRequest feedback) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    increment_image_indx();
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
              color: backgraound,
              boxShadow: myBoxShadow(),
            ),
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
                        Expanded(
                          child: Text(
                            'משוב על סרטון ${feedback.exerciseVideoGlobalId}',
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'מצב המשוב : ${_getFeedbackStatus(feedback.systemManagerResponse)}',
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                                color: Color.fromARGB(244, 107, 107, 107)),
                          ),
                        ),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        Expanded(
                          child: ElevatedButton.icon(
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
                              'עיין בבקשה',
                              style: TextStyle(
                                color: Colors.black,
                              ),
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
                      border: Border.all(color: Colors.white, width: 5),
                      borderRadius: BorderRadius.circular(10),
                      //color: container_color1,
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: getthumpnail(context, 0.25, image_index),
                        ),
                        Align(alignment: Alignment.bottomLeft,child: Text('${_filterCreatedTime(feedback.timeCreated)}',style: TextStyle(fontSize: 10),)),
                      ],
                    ),
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
      return 'נענה';
    } else {
      return 'טרם נענה';
    }
  }

  String _filterCreatedTime(DateTime createdTime){
    return '${createdTime.hour}:${createdTime.minute} ${createdTime.day}-${createdTime.month}-${createdTime.year}';
  }
}
