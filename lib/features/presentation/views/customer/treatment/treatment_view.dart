import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:injury_recovery/constants/colors.dart' as co;
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
            SingleChildScrollView(
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
            ),
            Container(
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
