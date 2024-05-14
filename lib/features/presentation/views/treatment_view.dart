import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:injury_recovery/constants/colors.dart' as co;
import 'package:injury_recovery/features/presentation/widgets/video_navigation_button.dart';

class TreatmentView extends StatefulWidget {
  const TreatmentView({super.key});

  @override
  State<TreatmentView> createState() => _TreatmentViewState();
}

class _TreatmentViewState extends State<TreatmentView> {
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
                  GestureDetector(
                    onHorizontalDragEnd: (details) {
                      if (details.primaryVelocity! > 0) {
                        // Dragged from left to right (swipe right)
                        // Navigate to previous video
                      } else {
                        // Dragged from right to left (swipe left)
                        // Navigate to next video
                      }
                    },
                    child: Container(
                      color: Colors.green,
                      height: height * 0.4,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const VideoNavigationButtons(numVideos: 5,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text('description'),
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
