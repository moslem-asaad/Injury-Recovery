import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:injury_recovery/constants/colors.dart' as co;
import 'package:injury_recovery/features/presentation/views/customer/treatment/ro_feedback_request.dart';
import 'package:injury_recovery/features/presentation/views/customer/treatment/videos_view.dart';
import '../../../../domain/entities/treatment.dart';

class TreatmentView extends StatefulWidget {
  TreatmentView({super.key, required this.treatment, required this.index});
  final Treatment treatment;
  int index;

  @override
  State<TreatmentView> createState() => _TreatmentViewState();
}

class _TreatmentViewState extends State<TreatmentView> {
  late Treatment treatment;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    treatment = widget.treatment;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: co.backgraound,
        appBar: AppBar(
          bottom: const TabBar(tabs: [
            Tab(
              child: Text(
                'Videos',
                style: TextStyle(
                  color: co.text_color,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Tab(
              child: Text(
                'Feedback Request',
                style: TextStyle(
                  color: co.text_color,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ]),
          title: Text('Treatment A'),
        ),
        body: TabBarView(
          children: [
            videosBarView(),
            feedbackBarView(),
          ],
        ),
      ),
    );
  }

  Widget videosBarView() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: width,
              maxHeight: height,
            ),
            child: Center(
              child: !treatment.videosList!.isEmpty
                  ? VideosView(
                      videos: treatment.videosList!,
                      treatmentId: treatment.treatmentGlobalId!,
                    )
                  : Container(),
            ),
          ),
        ],
      ),
    );
  }

  Widget feedbackBarView() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              height: height * 0.2,
              width: width * 0.9,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                  color: co.my_green),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Feedback on video 1',
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const Text(
                    'Feedback Status : not answerd yet',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'to see your request details',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                RoFeedBackRequest(treatmentId: 1, videoId: 1),
                          ));
                        },
                        child: Text(
                          'click here',
                          style: TextStyle(
                              //color: Colors.white,
                              ),
                        ),
                      ),
                    ],
                  ),
                  Center(
                      child: OutlinedButton(
                          onPressed: () {}, child: Text('Show Response'))),
                ],
              ),
            ),
            SizedBox(
              height: height * 0.05,
            ),
            Container(
              height: height * 0.2,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[200],
              ),
            )
          ],
        ),
      ),
    );
  }
}
