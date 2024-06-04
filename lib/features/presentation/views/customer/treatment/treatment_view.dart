import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:injury_recovery/constants/colors.dart' as co;
import 'package:injury_recovery/features/presentation/views/customer/treatment/all_treatment_feedbacks.dart';
import 'package:injury_recovery/features/presentation/views/customer/treatment/ro_feedback_request.dart';
import 'package:injury_recovery/features/presentation/views/customer/treatment/videos_view.dart';
import 'package:injury_recovery/features/presentation/widgets/logo_image.dart';
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
          centerTitle: false,
          title: Text('${treatment.treatmentName}'),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:25.0),
              child: getLogo(context, 0.1),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(
                child: Text(
                  'תרגילים',
                  style: TextStyle(
                    color: co.text_color,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'בקשות משוב',
                  style: TextStyle(
                    color: co.text_color,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
            indicatorColor: Colors.blue,
          ),
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
    return AllTreatmentFeedbacks(treatmentId: widget.treatment.treatmentGlobalId);
  }
}
